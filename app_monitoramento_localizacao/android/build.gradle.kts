buildscript {
    val flutter = mapOf(
        "compileSdkVersion" to 35,
        "minSdkVersion" to 21,
        "targetSdkVersion" to 35,
        "versionCode" to 1,
        "versionName" to "1.0.0",
        "ndkVersion" to "29.0.13113456"
    )
    extra.set("flutter", flutter)

    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
