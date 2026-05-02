android {
    compileSdkVersion 34  // ✅ تحديث إلى 34
    // ✅ حذف buildToolsVersion - سيستخدم Gradle الإصدار الافتراضي
    
    defaultConfig {
        applicationId "com.example.app"  // استبدل باسم تطبيقك
        minSdkVersion 21
        targetSdkVersion 34  // ✅ تحديث إلى 34
        versionCode 1
        versionName "1.0.0"
    }
    
    // تأكد من وجود هذه الإعدادات
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
    
    kotlinOptions {
        jvmTarget = '17'
    }
}
