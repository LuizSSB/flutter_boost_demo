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
            // luizssb: requests FlutterBoost to present a Flutter page.
            // The instance passed to FlutterBoost.setup handles the native
            // presentation of the Activity itself, while the Flutter code
            // handles the page itself.
            FlutterBoost.instance().open(
                FlutterBoostRouteOptions.Builder()
                    .pageName("flutterPage")
                    .arguments(emptyMap())
                    .build()
            )
        }

        findViewById<View>(R.id.text_2).setOnClickListener {
            FlutterBoost.instance().open(
                FlutterBoostRouteOptions.Builder()
                    .pageName("flutterPage2")
                    .arguments(emptyMap())
                    .build()
            )
        }
    }
}