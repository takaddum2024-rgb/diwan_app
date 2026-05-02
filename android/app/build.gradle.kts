val kotlin_version = "1.9.22"

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // هذا السطر مهم جداً لتعريف هوية التطبيق
    namespace = "com.example.diwan_app" 
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.diwan_app"
        // استخدمي أرقاماً صريحة هنا لضمان عدم وجود أخطاء في التعاريف
        minSdk = 21 
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            // ملاحظة: في النسخة النهائية سنغير هذا لإعدادات الـ Signing الحقيقية
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
