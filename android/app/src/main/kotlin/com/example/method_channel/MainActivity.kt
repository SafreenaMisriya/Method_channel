package com.example.method_channel

import android.content.Context
import android.database.Cursor
import android.media.Ringtone
import android.media.RingtoneManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        var channel= "ringtone_channel"
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel).setMethodCallHandler{call,result ->when(call.method){
            "getRingtones" ->{
                val ringtone = getAllRingtones(this)
                result.success(ringtone)
            }
        } }
    }

    private fun getAllRingtones(context: Context): MutableList<String> {
        val manager= RingtoneManager(context)
        manager.setType(RingtoneManager.TYPE_RINGTONE)
        var cursor:Cursor=manager.cursor
        val list:MutableList<String> = mutableListOf()
        while (cursor.moveToNext()){
            val notificationTitle:String=cursor.getString(RingtoneManager.TITLE_COLUMN_INDEX)
            list.add(notificationTitle)
        }
    return list
    }
}
