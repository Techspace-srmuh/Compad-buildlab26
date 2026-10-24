# Proguard rules for Compad Android Release

# Preserve Flutter SharedPreferences registrar and methods for R8/ProGuard
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keepclassmembers class io.flutter.plugins.sharedpreferences.** {
    *;
}

# Preserve local_auth and biometric classes
-keep class androidx.biometric.** { *; }
-keep class io.flutter.plugins.localauth.** { *; }
-keep class androidx.fragment.app.** { *; }

# Preserve Drift and SQLite native libraries
-keep class org.sqlite.** { *; }
-keep class io.requery.android.database.** { *; }
-keep class androidx.window.** { *; }

# Flutter engine and plugins reflection
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**
