plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    val flutter = rootProject.extra["flutter"] as Map<String, Any>

    namespace = "com.example.app_monitoramento_localizacao"
    compileSdk = flutter["compileSdkVersion"] as Int
    ndkVersion = flutter["ndkVersion"] as String

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.app_monitoramento_localizacao"
        minSdk = flutter["minSdkVersion"] as Int
        targetSdk = flutter["targetSdkVersion"] as Int
        versionCode = flutter["versionCode"] as Int
        versionName = flutter["versionName"] as String
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
