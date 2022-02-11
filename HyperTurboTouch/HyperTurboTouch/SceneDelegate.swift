//
//  SceneDelegate.swift
//  HyperTurboTouch
//
//  Created by Luiz SSB on 24/01/22.
//

import UIKit
import flutter_boost

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: ViewController(inModal: false))
        window?.makeKeyAndVisible()
        
        // luizssb: FlutterBoost needs a delegate that handle navigation requests from the Flutter Side
        let fbDelegate = MyFlutterBoostDelegate(window: window!)
        FlutterBoost.instance().setup(UIApplication.shared, delegate: fbDelegate) { engine in
            print("FlutterBoost is ACTIVE")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

