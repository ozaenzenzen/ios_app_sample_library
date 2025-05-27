//
//  BridgeUIManager.swift
//  sample_application2
//
//  Created by Fauzan Akmal Mahdi on 26/05/25.
//

import Foundation
import Flutter
import UIKit
import FlutterPluginRegistrant
import SwiftUI

public class BridgeUIManager {
    public static let shared = BridgeUIManager()
    
    static private var flutterEngine: FlutterEngine?
    static private var flutterVC: FlutterViewController?
    static private var floatingButton: DraggableButton2?
    
    static private(set) var clientId: String = ""
    static private(set) var clientSecret: String = ""
    static private(set) var flavor: String = ""
    
    static private var engineName = "sag_main_engine"
    static private var channelName = "konnek_native"
    static private var methodChannel: FlutterMethodChannel?
    
    static private var konnekService = KonnekService()
    
    static private let jsonEncode = JSONEncoder()
    
    static private var initConfigData = ""
    var configSetup: (() -> Void)?
    
    private init() {}
    
    static public func getFlutterEngine() -> FlutterEngine? {
        return flutterEngine
    }
    
    // ✅ Called first by the client
    public func initFunction(clientId: String, clientSecret: String, flavor: String) {
        BridgeUIManager.clientId = clientId
        BridgeUIManager.clientSecret = clientSecret
        BridgeUIManager.flavor = flavor
        
        BridgeUIManager.flutterEngine = FlutterEngine(name: BridgeUIManager.engineName)
        BridgeUIManager.flutterEngine?.run()
        if let engine = BridgeUIManager.flutterEngine {
            GeneratedPluginRegistrant.register(with: engine)
        }
        // Setup method channel
        if let binaryMessenger = BridgeUIManager.flutterEngine?.binaryMessenger {
            BridgeUIManager.methodChannel = FlutterMethodChannel(
                name: BridgeUIManager.channelName,
                binaryMessenger: binaryMessenger,
            )
        }
        callConfig()
    }
    
    private func callConfig() {
        BridgeUIManager.konnekService.getConfig(clientIdValue: BridgeUIManager.clientId) { output in
            switch output {
            case .success(let data):
                // print("Success getConfig: \(data)")
                BridgeUIManager.initConfigData = data
                self.configSetup = {
                    if let datas1 = JSONHelper().jsonStringToDict(data) {
                        //                        print("datas1: \(datas1)")
                        if let dataMap = datas1["data"] as? [String: Any],
                           let textStatus = dataMap["text_status"] as? String {
                            print("textStatus: \(textStatus)")
                        }
                        if let dataMap = datas1["data"] as? [String: Any],
                           let textButton = dataMap["text_button"] as? String {
                            print("textButton: \(textButton)")
                            BridgeUIManager.floatingButton?.setTextButton(text: textButton)
                        }
                        if let dataMap = datas1["data"] as? [String: Any],
                           let textButtonColor = dataMap["text_button_color"] as? String {
                            print("textButtonColor: \(textButtonColor)")
                            BridgeUIManager.floatingButton?.setTextColor(
                                color: (BridgeUIManager.floatingButton?.hexStringToUIColor(
                                    hex: textButtonColor
                                ) ?? UIColor(.black)
                                )
                            )
                        }
                        if let dataMap = datas1["data"] as? [String: Any],
                           let buttonColor = dataMap["button_color"] as? String {
                            print("button_color: \(buttonColor)")
                            BridgeUIManager.floatingButton?.setButtonColor(color: (BridgeUIManager.floatingButton?.hexStringToUIColor(
                                hex: buttonColor
                            ) ?? UIColor(.white)
                            )
                            )
                        }
                        if let dataMap = datas1["data"] as? [String: Any],
                           let iosIcon = dataMap["ios_icon"] as? String {
                            // print("ios_icon: \(iosIcon)")
                            print("ios_icon: ")
                            BridgeUIManager.floatingButton?.setImageButton(image: (BridgeUIManager.floatingButton?.base64ToUIImage(
                                iosIcon
                            ) ?? UIImage()
                            )
                            )
                        }
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    // ✅ Client uses this to get the floating button
    public func getFloatingButton() -> UIView {
        let button = DraggableButton2()
        button.addTarget(self, action: #selector(floatingButtonTapped), for: .touchUpInside)
        BridgeUIManager.floatingButton = button
        self.configSetup?()
        return button
    }
    
    @objc private func floatingButtonTapped() {
        guard let topVC = Self.topViewController(),
              let engine = BridgeUIManager.flutterEngine else { return }
        
        BridgeUIManager.flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
        BridgeUIManager.flutterVC?.modalPresentationStyle = .fullScreen
        
        // Send data to Flutter before showing the screen
        invokeFlutter()
        
        topVC.present(BridgeUIManager.flutterVC!, animated: true)
    }
    
    /// ✅ Sends data to Flutter via MethodChannel
    public func invokeFlutter() {
        let args: [String: Any] = [
            "clientId": BridgeUIManager.clientId,
            "clientSecret": BridgeUIManager.clientSecret,
            "flavor": BridgeUIManager.flavor
        ]
        
        let newValue: String = JSONHelper().dictionaryToJsonString(args) ?? ""
        
        print("🔵 Sending initData to Flutter: \(newValue)")
        BridgeUIManager.methodChannel?.invokeMethod("clientConfigChannel", arguments: newValue)
        if (BridgeUIManager.initConfigData != "") {
            BridgeUIManager.methodChannel?.invokeMethod("fetchConfigData", arguments: BridgeUIManager.initConfigData)
        }
    }
    
    /// ✅ Listen for messages from Flutter
    public func startFlutterMethodChannelListener(onEvent: @escaping (String, Any?) -> Void) {
        BridgeUIManager.methodChannel?.setMethodCallHandler { call, result in
            onEvent(call.method, call.arguments)
            result(nil) // respond to Flutter if needed
        }
    }
    
    private static func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

