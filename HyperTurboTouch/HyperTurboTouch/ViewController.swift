//
//  ViewController.swift
//  HyperTurboTouch
//
//  Created by Luiz SSB on 24/01/22.
//

import UIKit
import flutter_boost

class ViewController: UIViewController {
    let inModal: Bool
    
    init(inModal: Bool) {
        self.inModal = inModal
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.inModal = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        self.inModal = false
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Tela nativa mon fils"
        
        if inModal {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(die))
        }
    }
    
    @objc func die() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushNative(_ sender: Any) {
        navigationController?.pushViewController(ViewController(inModal: false), animated: true)
    }
    
    @IBAction func presentNative(_ sender: Any) {
        let navigation = UINavigationController(rootViewController: ViewController(inModal: true))
        navigation.modalPresentationStyle = .fullScreen
        present(
            navigation,
            animated: true,
            completion: nil
        )
    }
    
    @IBAction func pushFlutter(_ sender: Any) {
        // luizssb: requests FlutterBoost to present a Flutter page.
        // Our `MyFlutterBoostDelegate` handles the native presentation
        // of the ViewController itself, while the Flutter code handles the
        // page.
        FlutterBoost.instance().open(
            "flutterPage",
            arguments: ["animated": true, "present": false],
            completion: { _ in }
        )
    }
    
    @IBAction func presentFlutter(_ sender: Any) {
        FlutterBoost.instance().open(
            "flutterPage",
            arguments: ["animated": true],
            completion: { _ in }
        )
    }
}

