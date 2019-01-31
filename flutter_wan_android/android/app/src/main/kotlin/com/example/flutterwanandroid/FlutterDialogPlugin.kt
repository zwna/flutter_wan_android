package com.example.flutterwanandroid

import android.content.Context
import android.graphics.Color
import android.os.Handler
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import net.steamcrafted.loadtoast.LoadToast


object FlutterDialogPlugin {

    /** Channel名称  **/
    private const val ChannelName = "flutter_dialog_plugin"

    @JvmStatic
    fun register(context: Context, messenger: BinaryMessenger) = MethodChannel(messenger, ChannelName).setMethodCallHandler { methodCall, result ->
        when (methodCall.method) {
            "tip" -> {
                val loadToast = LoadToast(context)
                loadToast.setBackgroundColor(Color.GREEN)
                loadToast.setText("Flutter调用安卓原生")
                loadToast.show()
                Handler().postDelayed({
                   loadToast.hide()
               },5000)
            }
            "pop" -> {
                val loadToast = LoadToast(context)
                loadToast.success()
                loadToast.setText("Flutter调用安卓原生")
                loadToast.show()
                Handler().postDelayed({
                    loadToast.hide()
                },5000)
            }
            "dialog" -> {
        val loadToast = LoadToast(context)
        loadToast.setBackgroundColor(Color.GREEN)
        loadToast.setText("Flutter调用安卓原生")
        loadToast.show()
        Handler().postDelayed({
            loadToast.hide()
        },5000)
    }
        }
        result.success(null) //没有返回值，所以直接返回为null
    }

}