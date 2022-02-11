package com.example.hyperturbo

import android.content.Intent
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostDelegate
import com.idlefish.flutterboost.FlutterBoostRouteOptions
import com.idlefish.flutterboost.FlutterBoostSetupOptions
import com.idlefish.flutterboost.containers.FlutterBoostActivity
import io.flutter.app.FlutterApplication
import io.flutter.embedding.android.FlutterActivityLaunchConfigs

// luizssb: notice that the application got to inherit from `FlutterApplication`
class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        // luizssb: initializes FlutterBoost
        FlutterBoost.instance().setup(
            this,

            // luizssb: hamdles navigation from/to Flutter
            object : FlutterBoostDelegate {

                // luizssb: handles navigation requests from Flutter
                override fun pushNativeRoute(options: FlutterBoostRouteOptions?) {
                    val intent = Intent(
                        FlutterBoost.instance().currentActivity(),
                        MainActivity::class.java
                    )
                    FlutterBoost.instance().currentActivity().startActivity(intent)
                }

                // luizssb: handles navigation request from the native side to display a Flutter page
                override fun pushFlutterRoute(options: FlutterBoostRouteOptions?) {
                    val intent: Intent = FlutterBoostActivity.CachedEngineIntentBuilder(FlutterBoostActivity::class.java)
                        .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.opaque)
                        .destroyEngineWithActivity(false)
                        .url(options?.pageName())
                        .urlParams(options?.arguments())
                        .build(FlutterBoost.instance().currentActivity())
                    FlutterBoost.instance().currentActivity().startActivity(intent)
                }
            },
            {
                println("FlutterBoost is ON")
            }
        )
    }
}