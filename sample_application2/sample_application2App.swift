//
//  sample_application2App.swift
//  sample_application2
//
//  Created by Fauzan Akmal Mahdi on 26/05/25.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant


@Observable
class FlutterDependencies {
    let flutterEngine = FlutterEngine(name: "konnek_engine")
    init() {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        // Connects plugins with iOS platform code to this app.
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
    }
}

@main
struct sample_application2App: App {
    //    @State var flutterDependencies = FlutterDependencies()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            // ContentView().environment(flutterDependencies)
            ContentView()
                .onAppear {
                    BridgeUIManager.shared.initFunction(
                        clientId: "b699182d-5ff0-4161-b649-239234ff9cb9",
                        clientSecret: "1dc8e065-2915-4b4e-8df2-45040e8314bd",
                        flavor: "staging"
                    )
                    
                    // Add draggable button to window
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let window = UIApplication.shared.windows.first {
                            let button = BridgeUIManager.shared.getFloatingButton()
                            window.addSubview(button)
                        }
                    }
                    
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {}
