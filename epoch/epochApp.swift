//
//  epochApp.swift
//  epoch
//
//  Created by Glenn Golden on 8/19/25.
//

import SwiftUI
import Combine

@main
struct EpochApp: App {
    @StateObject private var clipboardChecker = ClipboardChecker()

    var body: some Scene {
        MenuBarExtra (
            clipboardChecker.convertedTime == nil ? "🕰️😳" : "🕰️✅"
        ) {
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
        }
    }
}
