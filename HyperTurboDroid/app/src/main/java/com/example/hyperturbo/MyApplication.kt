package com.example.hyperturbo

import android.content.Intent
import com.idlefish.flutterboost.FlutterBoost
import com.idlefish.flutterboost.FlutterBoostDelegate
import com.idlefish.flutterboost.FlutterBoostRouteOptions
import com.idlefish.flutterboost.FlutterBoostSetupOptions
import com.idlefish.flutterboost.containers.FlutterBoostActivity
import io.flutter.app.FlutterApplication
import io.flutter.embedding.android.FlutterActivityLaunchConfigs


/**
 * Created by luizssb on 14/01/22.
 *
 * @author rcosta
 */
class MyApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        FlutterBoost.instance().setup(
            this,
            object : FlutterBoostDelegate {
                override fun pushNativeRoute(options: FlutterBoostRouteOptions?) {
                    val intent = Intent(
                        FlutterBoost.instance().currentActivity(),
                        MainActivity::class.java
                    )
                    FlutterBoost.instance().currentActivity().startActivity(intent)
                }

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

            }
        )
    }
}