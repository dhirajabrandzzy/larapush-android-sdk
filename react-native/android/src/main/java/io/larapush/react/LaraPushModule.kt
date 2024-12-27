package io.larapush.react

import com.facebook.react.bridge.*
import io.larapush.sdk.LaraPush
import io.larapush.sdk.LaraPushConfig
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class LaraPushModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "LaraPushModule"

    @ReactMethod
    fun initialize(panelUrl: String, applicationId: String, debug: Boolean, promise: Promise) {
        try {
            val config = LaraPushConfig(
                panelUrl = panelUrl,
                applicationId = applicationId,
                debug = debug
            )
            LaraPush.init(reactApplicationContext, config)
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("INIT_ERROR", e)
        }
    }

    @ReactMethod
    fun setTags(tags: ReadableArray, promise: Promise) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val tagsList = tags.toArrayList().map { it.toString() }.toTypedArray()
                LaraPush.getInstance().setTags(*tagsList)
                promise.resolve(true)
            } catch (e: Exception) {
                promise.reject("SET_TAGS_ERROR", e)
            }
        }
    }

    @ReactMethod
    fun getTags(promise: Promise) {
        try {
            val tags = LaraPush.getInstance().getTags()
            val array = Arguments.createArray()
            tags.forEach { array.pushString(it) }
            promise.resolve(array)
        } catch (e: Exception) {
            promise.reject("GET_TAGS_ERROR", e)
        }
    }

    @ReactMethod
    fun clearTags(promise: Promise) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                LaraPush.getInstance().clearTags()
                promise.resolve(true)
            } catch (e: Exception) {
                promise.reject("CLEAR_TAGS_ERROR", e)
            }
        }
    }

    @ReactMethod
    fun getToken(promise: Promise) {
        CoroutineScope(Dispatchers.Main).launch {
            try {
                val token = LaraPush.getInstance().getToken()
                promise.resolve(token)
            } catch (e: Exception) {
                promise.reject("GET_TOKEN_ERROR", e)
            }
        }
    }
}