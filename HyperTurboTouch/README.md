# Integrating Flutter and FlutterBoost into an Android App

First of all, follow the steps described in [Integrate a Flutter module into your iOS project](https://docs.flutter.dev/development/add-to-app/ios/project-setup). The Flutter module's root directory will be on the same level as the iOS app's root directory. It makes sense, since this module will likely also be shared with the Android app, so it does not *belong* to either code base and should be kept in a separate repository.

Please check out the README.md in the `hyper_turbo` directory of this repository for an explanation on how to configure the Flutter module, and FlutterBoost within it.

On the iOS side code, the first step is to create a subclass of `NSObject, FlutterBoostDelegate` that handles navigation from/to the native side to/from the Flutter side. It can be tricky, as iOS provides several ways to present a new page (`UIViewController.present(:animated:completed)`, `UINavigationController.pushViewController(:animated:)`, etc.). Not only that, you must keep in mind that FlutterBoost may require navigation *out* of some page, so be sure to in some "remember" how the app navigates to a native page, so you can later undo it. 

    class MyFlutterBoostDelegate : NSObject, FlutterBoostDelegate {
      // needs the app's window
      private let window: UIWindow
      
      init(window: UIWindow) {
        self.window = window
        super.init()
      }

      // handles navigation request from the Flutter side to display a native page
      func pushNativeRoute(_ pageName: String!, arguments: [AnyHashable : Any]!) {
        // the arguments are application-defined - not a part of FlutterBoost
        let present = (arguments["present"] as? Bool) ?? true
        let destinationVC = // ...
        
        let currentVC = window.topMostViewController()
        if let currentVC = currentVC as? UINavigationController,
           !present {
          currentVC.pushViewController(destinationVC, animated: true)
        } else {
          let vc = UINavigationController(rootViewController: destinationVC)
          vc.modalPresentationStyle = .fullScreen
          currentVC.present(vc, animated: true, completion: nil)
        }
      }
      
      // handles navigation request from the native side to display a Flutter page
      func pushFlutterRoute(_ options: FlutterBoostRouteOptions!) {
        // I do not remember exactly why, but we gotta clean this viewController
        let engine = FlutterBoost.instance().engine()
        engine?.viewController = nil
        
        let vc = FBFlutterViewContainer()!
        vc.setName(
          options.pageName,
          uniqueId: options.uniqueId,
          params: options.arguments,
          opaque: true
        )
        let present = (options.arguments["present"] as? Bool) ?? true
        
        let currentVC = window.topMostViewController()
        if let currentVC = currentVC as? UINavigationController,
           !present {
          currentVC.pushViewController(vc, animated: true)
        } else {
          currentVC.present(vc, animated: true, completion: nil)
        }
      }
      
      // handles "back" request from the Flutter side
      func popRoute(_ options: FlutterBoostRouteOptions!) {
        let currentVC = window.topMostViewController()
        
        // each Flutter page presented by FlutterBoost has an uniqueId which
        // identifies it in FlutterBoost's navigation stack.
        // in addition to checking if the currently visible ViewController
        // is presenting Flutter content, we must also check if its uniqueId
        // is the same one of the current "back" request

        if let currentVC = currentVC as? FBFlutterViewContainer,
          currentVC.uniqueIDString() == options.uniqueId {
          currentVC.dismiss(animated: true, completion: nil)

        } else if let currentVC = currentVC as? UINavigationController,
              let topVC = currentVC.viewControllers.last as? FBFlutterViewContainer,
              topVC.uniqueIDString() == options.uniqueId  {
          currentVC.popViewController(animated: true)
        }
      }
    }

    extension UIWindow {
      func topMostViewController() -> UIViewController {
        return // ...
      }
    }

Next, we must initialize FlutterBoost. For this example, which requires the app's window, it must be done wherever this window is created - for older apps it would be `UIApplicationDelegate.application(:didFinishLaunchingWithOptions:)` and for newer ones, `UIWindowSceneDelegate.scene(:willConnectTo:options:)`

    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
      var window: UIWindow?

      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let rootVC = //...
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        
        let fbDelegate = MyFlutterBoostDelegate(window: window!)
        FlutterBoost.instance().setup(UIApplication.shared, delegate: fbDelegate) { engine in
          // FlutterBoost is initialized and engine has started.
        }
      }

      // ...
    }


Now, to call some Flutter page from the native code, you can the code below.

    let page = "flutterPage"
    let arguments = ["foo": "bar"]
    FlutterBoost.instance().open(
        page,
        arguments: arguments,
        completion: { _ in }
    )

## Note
This example shows that ViewControllers containing Flutter content can be navigated to inside of a `UINavigationController`. This may cause two navigation bars to be displayed: the native one from the `UINavigationController` and the `AppBar` from Flutter; in addition, in such case, selecting the native one's back button would back out of the whole Flutter navigation stack, instead of just the current page. Therefore, you should take care of hiding the native `UINavigationBar` whenever displaying Flutter content with `AppBar`.
