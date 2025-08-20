//
//  ClipboardChecker.swift
//  epoch
//
//  Created by Glenn Golden on 8/19/25.
//

import Foundation
import AppKit

class ClipboardChecker: ObservableObject {
    @Published var convertedTime: String?

    private var lastChangeCount: Int
    private var timer: Timer?

    init() {
        let pasteboard = NSPasteboard.general
        lastChangeCount = pasteboard.changeCount

        checkClipboard()

        // Start polling every 1 second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.checkForChanges()
        }
    }

    private func checkForChanges() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            checkClipboard()
        }
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

            DispatchQueue.main.async {
                self.convertedTime = formatter.string(from: date)
            }
        } else {
            DispatchQueue.main.async {
                self.convertedTime = nil
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
}
