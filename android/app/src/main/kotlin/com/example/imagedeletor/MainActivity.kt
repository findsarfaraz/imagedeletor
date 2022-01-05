package com.example.imagedeletor

import android.Manifest.permission.*
import android.app.AppComponentFactory
import android.content.Context


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.BatteryManager
import android.content.IntentFilter



import android.content.ContextWrapper
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.loader.FlutterLoader
import java.security.Permission

import androidx.core.content.ContextCompat

import android.os.Build.VERSION.SDK_INT
import android.content.pm.PackageManager
import android.os.Build

import androidx.core.app.ActivityCompat

import android.os.Build.VERSION.SDK_INT
import android.os.Environment
import android.provider.Settings
import android.provider.Settings.*
import io.flutter.BuildConfig
import java.lang.Exception


class MainActivity: FlutterActivity() {

    private val CHANNEL = "samples.flutter.dev/battery"

        override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
            println("this configure ran")
            super.configureFlutterEngine(flutterEngine)

            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { Methodcall, result ->


                if (Methodcall.method=="getPermission"){
                    getPermission()
                }
                else{
                    print("No Permission provided")
                }

                if (Methodcall.method=="onActivityResult"){
                    val uri = Uri.parse("package:${ com.example.imagedeletor.BuildConfig.APPLICATION_ID}")

                    onActivityResult(501,1, Intent(ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,uri))
                }


                if (Methodcall.method == "getBatteryLevel") {
                    val batteryLevel = getBatteryLevel()
                    if (batteryLevel != -1) {
                        result.success(batteryLevel)
                    } else {
                        result.error("UNAVAILABLE", "Battery level not available.", null)
                    }
                }
                else {

//                    result.notImplemented()
                }
            }


        }

    fun getBatteryLevel(): Int {

            val batteryLevel = if(VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP){
                val bm = context.getSystemService(FlutterActivity.BATTERY_SERVICE) as BatteryManager
                bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            }
            else{
                val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
                intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
            }
            return batteryLevel
        }



        val APP_STORAGE_ACCESS_REQUEST_CODE = 132131

    fun getPermission(){
        val uri = Uri.parse("package:${ com.example.imagedeletor.BuildConfig.APPLICATION_ID}")



        if (SDK_INT >= VERSION_CODES.R){

            if (!Environment.isExternalStorageManager()){
                try {

                    val intent = Intent(ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,uri)
                    startActivityForResult(intent, APP_STORAGE_ACCESS_REQUEST_CODE)

                }
                catch(e: Exception){
                    val intent = Intent(ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION,uri)
                    startActivityForResult(intent, APP_STORAGE_ACCESS_REQUEST_CODE)
                }
            }
        }

}

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == RESULT_OK && requestCode == APP_STORAGE_ACCESS_REQUEST_CODE) {
            if (SDK_INT >= VERSION_CODES.R){
                if (Environment.isExternalStorageManager()) {
                    print("permission granted")
                }
                else{
                    print("no permission obtained")
                }
            }

        }
        else{
            print("Result code not OK")
        }
        print("function ran")
    }
    }


