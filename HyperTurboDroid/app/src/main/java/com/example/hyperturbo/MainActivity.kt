package com.example.hyperturbo

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostRouteOptions
import com.idlefish.flutterboost.containers.FlutterBoostActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterActivityLaunchConfigs


class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<View>(R.id.text_1).setOnClickListener {
//            val params = emptyMap<String, Any>()
//            val intent = FlutterBoostActivity.CachedEngineIntentBuilder(
//                FlutterBoostActivity::class.java
//            )
//                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.opaque)
//                .destroyEngineWithActivity(false)
//                .url("flutterPage")
//                .urlParams(params)
//                .build(this)
//            startActivity(intent)
            FlutterBoost.instance().open(
                FlutterBoostRouteOptions.Builder()
                    .pageName("flutterPage")
                    .arguments(emptyMap())
                    .build()
            )
        }

        findViewById<View>(R.id.text_2).setOnClickListener {
//            val params = emptyMap<String, Any>()
//            val intent = FlutterBoostActivity.CachedEngineIntentBuilder(
//                FlutterBoostActivity::class.java
//            )
//                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.opaque)
//                .destroyEngineWithActivity(false)
//                .url("flutterPage")
//                .urlParams(params)
//                .build(this)
//            startActivity(intent)
//            startActivity(
//                FlutterActivity
//                    .withCachedEngine("flutter_boost_default_engine")
//                    .build(this)
//            )
            FlutterBoost.instance().open(
                FlutterBoostRouteOptions.Builder()
                    .pageName("flutterPage2")
                    .arguments(emptyMap())
                    .build()
            )
        }
    }
}