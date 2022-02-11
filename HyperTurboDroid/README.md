# Integrating Flutter and FlutterBoost into an Android App

First of all, follow the steps described in [Integrate a Flutter module into your Android project](https://docs.flutter.dev/development/add-to-app/android/project-setup).  If you can not find the "Flutter module" option in the "New Module" dialog of Android Studio/IntelliJ (or if it is available, but breaks the project when used), try the "Manual integration". If Android Studio shows an error when performing the necessary changes in the `settings.gradle` file, ignore it - it should be gone after synchronizing Gradle.

The Flutter module's root directory will be on the same level as the Android app's root directory. It makes sense, since this module will likely also be shared with the iOS app, so it does not *belong* to either code base and should be kept in a separate repository.

Please check out the README.md in the `hyper_turbo` directory of this repository for an explanation on how to configure the Flutter module, and FlutterBoost within it.

On the Android side code, the first step is to set up a custom `Application` implementation that inherits from `io.flutter.app.FlutterApplication`. On its `onCreate` method, you can initialize FlutterBoost like this:

    class MyApplication : FlutterApplication() {
      override fun onCreate() {
        super.onCreate()

        // initializes FlutterBoost
        FlutterBoost.instance().setup(
          this,

          // handles navigation requests from Flutter
          object : FlutterBoostDelegate {
            // handles navigation request from the Flutter side to display a native page
            override fun pushNativeRoute(options: FlutterBoostRouteOptions?) {
              val activityClass = // ...
              val intent = Intent(
                FlutterBoost.instance().currentActivity(),
                activityClass
              )

              // FlutterBoost keeps track of the top activity
              FlutterBoost.instance().currentActivity().startActivity(intent)
            }

            // handles navigation request from the native side to display a Flutter page
            override fun pushFlutterRoute(options: FlutterBoostRouteOptions?) {
              val intent: Intent = FlutterBoostActivity.CachedEngineIntentBuilder(FlutterBoostActivity::class.java)
                .backgroundMode(FlutterActivityLaunchConfigs.BackgroundMode.opaque)
                .destroyEngineWithActivity(false)
                .url(options?.pageName())
                .urlParams(options?.arguments())
                .build(FlutterBoost.instance().currentActivity())
              FlutterBoost.instance().currentActivity().startActivity(intent)
            }
          }
        ) {
          // FlutterBoost is initialized and Flutter engine has started
        }
      }
    }

This is a very basic implementation that presents a new Activity whenever the native part of the app navigates to a Flutter page, or vice-versa. In a real app, with many Activities, on the `pushNativeRoute`, you will probably have to check the `pageName` property of the `options: FlutterBoostRouteOptions` argument, as it species which native page the Flutter code is requesting.

Now, to call some Flutter page from the native code, you can:

    val pageName = "flutterPage"
    val arguments = mapOf("foo" to "bar")
    FlutterBoost.instance().open(  
        FlutterBoostRouteOptions.Builder()  
            .pageName(pageName)  
            .arguments(arguments)  
            .build()  
    )

## Note
After adding the FlutterBoost dependency to `build.gradle` and synchronizing Gradle, Android Studio/IntelliJ may fail to find FlutterBoost's symbols , so whenever you try use its API it will show `Unresolved reference` errors. This seems to affect only the IDE, as the code will compile just fine.
