plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sign_wave_v3"
    compileSdk = 35
    ndkVersion = "27.0.12077973"


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
    defaultConfig {
        applicationId = "com.example.sign_wave_v3"
        multiDexEnabled = true
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }


}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation(platform("com.google.firebase:firebase-bom:32.1.1"))

    // Add dependencies for Firebase SDK for Google Analytics and FCM
    // When using BoM, do NOT specify version for Firebase dependencies except Zego which requires explicit version
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging")

    // Zego FCM dependency with explicit version
    implementation("im.zego:zpns-fcm:2.8.0")
}

