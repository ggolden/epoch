//
//  epochApp.swift
//  epoch
//
//  Created by Glenn Golden on 8/19/25.
//

import SwiftUI

@main
struct EpochApp: App {
    @StateObject private var clipboardChecker = ClipboardChecker()

    let timer = Timer.publish(every: 1.0, on: .main, in: .common)

    var body: some Scene {
        MenuBarExtra("⏱", systemImage: "clock") {
            VStack {
                if let converted = clipboardChecker.convertedTime {
                    Text("Clipboard Time:")
                        .font(.headline)
                    Text(converted)
                        .font(.title3)
                        .padding()
                } else {
                    Text("No valid timestamp in clipboard")
                        .padding()
                }

                Button("Refresh") {
                    clipboardChecker.checkClipboard()
                }
                Divider()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding()
            .frame(width: 200)
            
            .onReceive(timer) { _ in
                clipboardChecker.checkClipboard()
            }
        }
    }
}
