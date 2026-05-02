pluginManagement {
    val flutterSdkPath = System.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    // قمنا بتحديث الرقم هنا من 8.1.0 إلى 8.1.1
    id("com.android.application") version "8.3.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.22" apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

include(":app")