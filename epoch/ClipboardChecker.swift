//
//  ClipboardChecker.swift
//  epoch
//
//  Created by Glenn Golden on 8/19/25.
//

import Foundation
import AppKit
import Combine

class ClipboardChecker: ObservableObject {
    @Published var convertedTime: String?

    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink{ [weak self] _ in
                self?.checkClipboard()
            }
        
        checkClipboard()
    }

    func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if let content = pasteboard.string(forType: .string),
           let timestamp = Double(content.trimmingCharacters(in: .whitespacesAndNewlines)) {

            // If it's in seconds, use directly; if in ms, scale down
            let adjusted = timestamp > 1_000_000_000_000 ? timestamp / 1000 : timestamp
            let date = Date(timeIntervalSince1970: adjusted)

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            formatter.timeZone = .current

            convertedTime = formatter.string(from: date)

        } else {
            convertedTime = nil
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
