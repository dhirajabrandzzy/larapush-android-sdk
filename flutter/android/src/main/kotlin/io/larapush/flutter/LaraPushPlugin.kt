package io.larapush.flutter

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.larapush.sdk.LaraPush
import io.larapush.sdk.LaraPushConfig
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class LaraPushPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "larapush")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                initialize(call, result)
            }
            "setTags" -> {
                setTags(call, result)
            }
            "removeTags" -> {
                removeTags(call, result)
            }
            "clearTags" -> {
                clearTags(result)
            }
            "getTags" -> {
                getTags(result)
            }
            "getToken" -> {
                getToken(result)
            }
            "refreshToken" -> {
                refreshToken(result)
            }
            "areNotificationsEnabled" -> {
                areNotificationsEnabled(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        try {
            val panelUrl = call.argument<String>("panelUrl")
            val applicationId = call.argument<String>("applicationId")
            val debug = call.argument<Boolean>("debug") ?: false

            if (panelUrl == null || applicationId == null) {
                result.error("INVALID_ARGUMENTS", "panelUrl and applicationId are required", null)
                return
            }

            val config = LaraPushConfig(
                panelUrl = panelUrl,
                applicationId = applicationId,
                debug = debug
            )

            context?.let { ctx ->
                LaraPush.init(ctx, config)
                result.success(true)
            } ?: result.error("CONTEXT_ERROR", "Context not available", null)
        } catch (e: Exception) {
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun setTags(call: MethodCall, result: Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val tags = call.argument<List<String>>("tags") ?: emptyList()
                LaraPush.getInstance().setTags(*tags.toTypedArray())
                result.success(true)
            } catch (e: Exception) {
                result.error("SET_TAGS_ERROR", e.message, null)
            }
        }
    }

    private fun removeTags(call: MethodCall, result: Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val tags = call.argument<List<String>>("tags") ?: emptyList()
                LaraPush.getInstance().removeTags(*tags.toTypedArray())
                result.success(true)
            } catch (e: Exception) {
                result.error("REMOVE_TAGS_ERROR", e.message, null)
            }
        }
    }

    private fun clearTags(result: Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                LaraPush.getInstance().clearTags()
                result.success(true)
            } catch (e: Exception) {
                result.error("CLEAR_TAGS_ERROR", e.message, null)
            }
        }
    }

    private fun getTags(result: Result) {
        try {
            val tags = LaraPush.getInstance().getTags()
            result.success(tags.toList())
        } catch (e: Exception) {
            result.error("GET_TAGS_ERROR", e.message, null)
        }
    }

    private fun getToken(result: Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val token = LaraPush.getInstance().getToken()
                result.success(token)
            } catch (e: Exception) {
                result.error("GET_TOKEN_ERROR", e.message, null)
            }
        }
    }

    private fun refreshToken(result: Result) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                LaraPush.getInstance().refreshToken()
                result.success(true)
            } catch (e: Exception) {
                result.error("REFRESH_TOKEN_ERROR", e.message, null)
            }
        }
    }

    private fun areNotificationsEnabled(result: Result) {
        try {
            val enabled = LaraPush.getInstance().areNotificationsEnabled()
            result.success(enabled)
        } catch (e: Exception) {
            result.error("NOTIFICATIONS_ENABLED_ERROR", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // Activity is available if needed
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // Activity detached for config changes
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // Activity reattached after config changes
    }

    override fun onDetachedFromActivity() {
        // Activity detached
    }
}