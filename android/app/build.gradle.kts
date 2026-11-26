import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "za.co.gwinya.ronditrack_app"
    // 37, and core library desugaring below: flutter_local_notifications 23
    // needs both (README "Notifications").
    compileSdk = 37
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "za.co.gwinya.ronditrack_app"
        // Android 8.0 (API 26), for sentry_flutter 10 (README "Decisions").
        // Was flutter.minSdkVersion (24, Android 7.0). It applies to every
        // build, DSN or not: members on Android 7.0 and 7.1 can't install or
        // update the app from this release on. Their installed copy keeps
        // working, and the web app still serves them.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    // AGP 9 turns resValue off by default, so each flavour names its launcher
    // through a manifest placeholder (AndroidManifest.xml: ${appName}).
    // Each flavour also has its own deep-link scheme (${deepLinkScheme}), so a
    // link aimed at the dev build opens the dev build: README "Deep links".
    flavorDimensions += "environment"

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            manifestPlaceholders["appName"] = "RondiTrack Dev"
            manifestPlaceholders["deepLinkScheme"] = "ronditrack-dev"
        }

        create("staging") {
            dimension = "environment"
            applicationIdSuffix = ".staging"
            manifestPlaceholders["appName"] = "RondiTrack Staging"
            manifestPlaceholders["deepLinkScheme"] = "ronditrack-staging"
        }

        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appName"] = "RondiTrack"
            manifestPlaceholders["deepLinkScheme"] = "ronditrack"
        }
    }

    // The upload key (README "Releases"): android/key.properties names the
    // keystore and its password, and is git-ignored, as is the keystore,
    // which lives outside the repository. Without it, release builds fall
    // back to the debug key so `flutter run --release` still works, and
    // tool/release.sh refuses to ship them: it checks each build's
    // certificate against the upload key's fingerprint.
    val keyProperties = Properties().apply {
        val file = rootProject.file("key.properties")
        if (file.exists()) file.inputStream().use { load(it) }
    }
    val hasUploadKey = keyProperties.getProperty("storeFile") != null

    signingConfigs {
        if (hasUploadKey) {
            create("upload") {
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasUploadKey) {
                signingConfigs.getByName("upload")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
