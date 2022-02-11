//
//  MyFlutterBoostDelegate.swift
//  HyperTurboTouch
//
//  Created by Luiz SSB on 24/01/22.
//

import Foundation
import UIKit
import flutter_boost

// luizssb: handles navigation requests from Flutter
class MyFlutterBoostDelegate : NSObject, FlutterBoostDelegate {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        super.init()
    }
    
    // luizssb: handles navigation request from the Flutter side to display a native page
    func pushNativeRoute(_ pageName: String!, arguments: [AnyHashable : Any]!) {
        let animated = (arguments["animated"] as? Bool) ?? true
        let present = (arguments["present"] as? Bool) ?? true
        
        let currentVC = window.topMostViewController()
        if let currentVC = currentVC as? UINavigationController,
           !present {
            currentVC.pushViewController(
                ViewController(inModal: false),
                animated: animated
            )
        } else {
            let vc = UINavigationController(rootViewController: ViewController(inModal: true))
            vc.modalPresentationStyle = .fullScreen
            currentVC.present(vc, animated: animated, completion: nil)
        }
    }
    
    // luizssb: handles navigation request from the native side to display a Flutter page
    func pushFlutterRoute(_ options: FlutterBoostRouteOptions!) {
        // luizssb: dunno exactly why, but we gotta clean this viewController
        let engine = FlutterBoost.instance().engine()
        engine?.viewController = nil
        
        let vc = FBFlutterViewContainer()!
        vc.setName(
            options.pageName,
            uniqueId: options.uniqueId,
            params: options.arguments,
            opaque: true
        )
        let animated = (options.arguments["animated"] as? Bool) ?? true
        let present = (options.arguments["present"] as? Bool) ?? true
        
        let currentVC = window.topMostViewController()
        if let currentVC = currentVC as? UINavigationController,
           !present {
            currentVC.pushViewController(vc, animated: animated)
        } else {
            currentVC.present(vc, animated: animated, completion: nil)
        }
    }
    
    // luizssb: handles navigation request from the Flutter side,
    // specifying that the app should back off of whatever page is
    // currently visible.
    func popRoute(_ options: FlutterBoostRouteOptions!) {
        let currentVC = window.topMostViewController()
        
        // luizssb: each Flutter page presented by FlutterBoost has an uniqueId
        // which identifies it in FlutterBoost's navigation stack.
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
        func getPresented(by vc: UIViewController) -> UIViewController {
            return vc.presentedViewController == nil
                ? vc
                : getPresented(by: vc.presentedViewController!)
        }
        
        return getPresented(by: rootViewController!)
    }
}
