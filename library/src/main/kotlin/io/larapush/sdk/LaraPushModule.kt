package com.reactnativelarapush

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableArray
import io.larapush.sdk.LaraPush
import io.larapush.sdk.LaraPushConfig

class LaraPushModule(private val reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

    override fun getName(): String = "LaraPushModule"

    @ReactMethod
    fun initialize(panelUrl: String, applicationId: String, debug: Boolean, promise: Promise) {
        try {
            val config = LaraPushConfig(panelUrl, applicationId, debug)
            currentActivity?.let { activity ->
                LaraPush.init(activity, config)
                promise.resolve(true)
            } ?: run {
                promise.reject("INIT_ERROR", "Activity is null")
            }
        } catch (e: Exception) {
            promise.reject("INIT_ERROR", e.message)
        }
    }

    @ReactMethod
    fun setTags(tags: ReadableArray, promise: Promise) {
        try {
            val tagsArray = Array(tags.size()) { i -> tags.getString(i) }
            LaraPush.setTags(*tagsArray)
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("SET_TAGS_ERROR", e.message)
        }
    }

    @ReactMethod
    fun getTags(promise: Promise) {
        try {
            val tags = LaraPush.getTags()
            promise.resolve(tags.toList())
        } catch (e: Exception) {
            promise.reject("GET_TAGS_ERROR", e.message)
        }
    }

    @ReactMethod
    fun getToken(promise: Promise) {
        try {
            val token = LaraPush.getToken()
            promise.resolve(token)
        } catch (e: Exception) {
            promise.reject("GET_TOKEN_ERROR", e.message)
        }
    }

    @ReactMethod
    fun refreshToken(promise: Promise) {
        try {
            LaraPush.refreshToken()
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("REFRESH_TOKEN_ERROR", e.message)
        }
    }

    @ReactMethod
    fun removeTags(tags: ReadableArray, promise: Promise) {
        try {
            val tagsArray = Array(tags.size()) { i -> tags.getString(i) }
            LaraPush.removeTags(*tagsArray)
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("REMOVE_TAGS_ERROR", e.message)
        }
    }

    @ReactMethod
    fun clearTags(promise: Promise) {
        try {
            LaraPush.clearTags()
            promise.resolve(true)
        } catch (e: Exception) {
            promise.reject("CLEAR_TAGS_ERROR", e.message)
        }
    }

    @ReactMethod
    fun areNotificationsEnabled(promise: Promise) {
        try {
            val enabled = LaraPush.areNotificationsEnabled()
            promise.resolve(enabled)
        } catch (e: Exception) {
            promise.reject("NOTIFICATIONS_ERROR", e.message)
        }
    }
}