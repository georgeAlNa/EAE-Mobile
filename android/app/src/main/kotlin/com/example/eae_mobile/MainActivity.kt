package com.example.eae_mobile

import android.Manifest
import android.app.ActivityManager
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import android.view.View
import android.view.WindowManager
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "eae_mobile/exam_security"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setSecureScreen" -> {
                        val enabled = call.argument<Boolean>("enabled") ?: false
                        if (enabled) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(true)
                    }
                    "enterFullscreen" -> {
                        window.decorView.systemUiVisibility =
                            View.SYSTEM_UI_FLAG_FULLSCREEN or
                                View.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
                                View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or
                                View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or
                                View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
                                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        result.success(true)
                    }
                    "exitFullscreen" -> {
                        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        result.success(true)
                    }
                    "isInMultiWindowMode" -> {
                        val inMultiWindow = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                            isInMultiWindowMode
                        } else {
                            false
                        }
                        result.success(inMultiWindow)
                    }
                    "checkDeviceIntegrity" -> result.success(checkDeviceIntegrity())
                    "hasPermission" -> {
                        val permission = call.argument<String>("permission") ?: ""
                        result.success(hasRuntimePermission(permission))
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun hasRuntimePermission(permissionName: String): Boolean {
        val permission = when (permissionName) {
            "camera" -> Manifest.permission.CAMERA
            "microphone" -> Manifest.permission.RECORD_AUDIO
            "notifications" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                Manifest.permission.POST_NOTIFICATIONS
            } else {
                return true
            }
            else -> return false
        }

        return ContextCompat.checkSelfPermission(this, permission) ==
            PackageManager.PERMISSION_GRANTED
    }

    private fun checkDeviceIntegrity(): Map<String, Any> {
        val rooted = isRootedDevice()
        val emulator = isProbablyEmulator()
        val debugger = isDebuggerConnected()

        return mapOf(
            "isRooted" to rooted,
            "isEmulator" to emulator,
            "isDebuggerConnected" to debugger,
            "isCompromised" to (rooted || emulator || debugger),
        )
    }

    private fun isRootedDevice(): Boolean {
        val buildTags = Build.TAGS ?: ""
        if (buildTags.contains("test-keys")) return true

        val paths = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
        )
        return paths.any { File(it).exists() }
    }

    private fun isProbablyEmulator(): Boolean {
        val androidId = Settings.Secure.getString(
            contentResolver,
            Settings.Secure.ANDROID_ID,
        )
        return Build.FINGERPRINT.startsWith("generic") ||
            Build.FINGERPRINT.lowercase().contains("vbox") ||
            Build.FINGERPRINT.lowercase().contains("test-keys") ||
            Build.MODEL.contains("google_sdk") ||
            Build.MODEL.contains("Emulator") ||
            Build.MODEL.contains("Android SDK built for x86") ||
            Build.MANUFACTURER.contains("Genymotion") ||
            Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic") ||
            Build.PRODUCT == "google_sdk" ||
            androidId.isNullOrEmpty()
    }

    private fun isDebuggerConnected(): Boolean {
        return android.os.Debug.isDebuggerConnected() ||
            ActivityManager.isUserAMonkey()
    }
}
