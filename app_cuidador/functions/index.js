const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.verificarLocalizacao = functions.database
  .ref("/localizacoes/{codigo}")
  .onWrite(async (change, context) => {
    const codigo = context.params.codigo;
    const novaLocalizacao = change.after.val();
    if (!novaLocalizacao) return null;

    const db = admin.firestore();

    const usuariosSnap = await db.collection("usuarios").get();

    for (const usuarioDoc of usuariosSnap.docs) {
      const pacienteSnap = await usuarioDoc.ref
        .collection("pacientes")
        .where("codigo", "==", codigo)
        .limit(1)
        .get();

      if (!pacienteSnap.empty) {
        const pacienteDoc = pacienteSnap.docs[0];
        const paciente = pacienteDoc.data();

        const lat1 = paciente.localizacao.latitude;
        const lon1 = paciente.localizacao.longitude;
        const raio = paciente.localizacao.raio;
        const lat2 = novaLocalizacao.latitude;
        const lon2 = novaLocalizacao.longitude;

        const distancia = calcularDistancia(lat1, lon1, lat2, lon2);

        console.log(
          `Paciente ${paciente.nome} está a ${distancia.toFixed(
            2
          )} metros da área.`
        );

        if (distancia > raio) {
          const token = usuarioDoc.data().tokenFCM;

          if (token) {
            await admin.messaging().send({
              token: token,
              notification: {
                title: "Paciente fora da área!",
                body: `${paciente.nome} saiu da área delimitada.`,
              },
            });
            console.log("Notificação enviada para o cuidador!");
          }
        }

        break;
      }
    }

    return null;
  });

function calcularDistancia(lat1, lon1, lat2, lon2) {
  function toRad(x) {
    return (x * Math.PI) / 180;
  }

  const R = 6371000; // raio da Terra em metros
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) *
      Math.cos(toRad(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}
