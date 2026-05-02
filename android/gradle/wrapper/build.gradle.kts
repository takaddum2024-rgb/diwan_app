val kotlin_version = "1.9.22"  // 👈 أضف هذا السطر

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
   applicationId = "com.example.diwan_app" // يجب أن يطابق الـ namespace
        minSdk = 21                             // لضمان عمله على الهواتف القديمة والجديدة
        targetSdk = 34                          // يجب أن يطابق الـ compileSdk
        versionCode = 1
        versionName = "1.0"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.diwan_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version")
}

flutter {
    source = "../.."
}
