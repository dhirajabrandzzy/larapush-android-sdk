package io.larapush.sdk

data class LaraPushConfig(
    val panelUrl: String,
    val applicationId: String,
    val debug: Boolean = false
)