//
//  sample_application2App.swift
//  sample_application2
//
//  Created by Fauzan Akmal Mahdi on 26/05/25.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant


//@Observable
//class FlutterDependencies {
//    let flutterEngine = FlutterEngine(name: "sag_main_engine")
//    init() {
//        // Runs the default Dart entrypoint with a default Flutter route.
//        flutterEngine.run()
//        // Connects plugins with iOS platform code to this app.
//        GeneratedPluginRegistrant.register(with: self.flutterEngine);
//    }
//}

//@main
//struct sample_application2App: App {
//    //    @State var flutterDependencies = FlutterDependencies()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    var body: some Scene {
//        WindowGroup {
//            // ContentView().environment(flutterDependencies)
//            ContentView()
//                .onAppear {
//                    BridgeUIManager.shared.initFunction(
//                        clientId: "b699182d-5ff0-4161-b649-239234ff9cb9",
//                        clientSecret: "1dc8e065-2915-4b4e-8df2-45040e8314bd",
//                        flavor: "staging"
//                    )
//
//                    // Add draggable button to window
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        if let window = UIApplication.shared.windows.first {
//                            let button = BridgeUIManager.shared.getFloatingButton()
//                            window.addSubview(button)
//                        }
//                    }
//
//                }
//        }
//    }
//}

//class AppDelegate: NSObject, UIApplicationDelegate {}


@Observable
class AppDelegate: FlutterAppDelegate {
    let flutterEngine = FlutterEngine(name: "sag_main_engine")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Runs the default Dart entrypoint with a default Flutter route.
            flutterEngine.run();
            // Used to connect plugins (only if you have plugins with iOS platform code).
            GeneratedPluginRegistrant.register(with: self.flutterEngine);
            return true;
        }
}

@main
struct sample_application2App: App {
    // Use this property wrapper to tell SwiftUI
    // it should use the AppDelegate class for the application delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear() {
                    BridgeUIManager.shared.initFunction(
                        clientId: "b699182d-5ff0-4161-b649-239234ff9cb9",
                        clientSecret: "1dc8e065-2915-4b4e-8df2-45040e8314bd",
                        flavor: "staging"
                    )
                    
                    // Add draggable button to window
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if let window = UIApplication.shared.windows.first {
                            let buttonTag = 12345
                            if window.viewWithTag(buttonTag) == nil {
                                let button = BridgeUIManager.shared.getFloatingButton()
                                button.tag = buttonTag
                                window.addSubview(button)
                            }
                            else {
                                print("Floating button already exists")
                            }
                        }
                    }
                    
                }
        }
    }
}
