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
    // استخدمي هذه الإصدارات لضمان التوافق مع Gradle 8.1
    id("com.android.application") version "8.1.0" apply false
    id("org.jetbrains.kotlin.android") version "1.9.0" apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

include(":app")
