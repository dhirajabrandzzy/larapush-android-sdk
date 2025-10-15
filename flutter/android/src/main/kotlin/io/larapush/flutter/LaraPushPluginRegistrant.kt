package io.larapush.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin

class LaraPushPluginRegistrant {
    companion object {
        @JvmStatic
        fun registerWith(registrar: io.flutter.plugin.common.PluginRegistry.Registrar) {
            val channel = io.flutter.plugin.common.MethodChannel(registrar.messenger(), "larapush")
            val plugin = LaraPushPlugin()
            channel.setMethodCallHandler(plugin)
        }
    }
}
