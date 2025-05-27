//
//  ContentView.swift
//  sample_application2
//
//  Created by Fauzan Akmal Mahdi on 26/05/25.
//

import SwiftUI
import Flutter
import FlutterPluginRegistrant

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Sample App iOS - Konnek")
            }
        }
    }
}

#Preview {
    ContentView()
}
