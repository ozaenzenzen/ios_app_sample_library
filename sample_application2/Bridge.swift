//
//  Bridge.swift
//  sample_application2
//
//  Created by Fauzan Akmal Mahdi on 26/05/25.
//

import Flutter
import UIKit
import FlutterPluginRegistrant

public class BridgeUI: NSObject {
    private var flutterEngine: FlutterEngine?
    private var flutterVC: FlutterViewController?
    private var floatingButton: UIButton?

    public override init() {
        super.init()
        flutterEngine = FlutterEngine(name: "bridge_engine")
        flutterEngine?.run()
        GeneratedPluginRegistrant.register(with: flutterEngine!)
    }

    public func showFloatingButton() {
        guard let window = Self.getKeyWindow() else { return }

        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "bolt.fill"), for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 60, height: 60)
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(openFlutterScreen), for: .touchUpInside)

        window.addSubview(button)
        floatingButton = button
        makeDraggable(button: button)
    }

    @objc private func openFlutterScreen() {
        guard let engine = flutterEngine,
              let rootVC = Self.getTopViewController() else { return }

        flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        flutterVC?.modalPresentationStyle = .fullScreen

        rootVC.present(flutterVC!, animated: true)
    }

    private func makeDraggable(button: UIButton) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleDrag))
        button.addGestureRecognizer(pan)
    }

    @objc private func handleDrag(gesture: UIPanGestureRecognizer) {
        guard let button = gesture.view else { return }
        let translation = gesture.translation(in: button.superview)
        button.center = CGPoint(x: button.center.x + translation.x, y: button.center.y + translation.y)
        gesture.setTranslation(.zero, in: button.superview)
    }

    // MARK: - Helper Methods

    private static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }

    private static func getTopViewController(base: UIViewController? = getKeyWindow()?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getTopViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

