//
//  BookmarkManager.swift
//  advent-of-code-2025-swift-ui
//
//  Created by Linus Stöckli on 03.12.2025.
//


import Foundation

class BookmarkManager {
    static let shared = BookmarkManager()

    private let key = "WorkingDirectoryBookmark"

    func resolveURL() -> URL? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

        var isStale = false
        do {
            let url = try URL(
                resolvingBookmarkData: data,
                options: [.withSecurityScope],
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            if url.startAccessingSecurityScopedResource() {
                return url
            } else {
                print("Could not access resource.")
                return nil
            }
        } catch {
            print("Error resolving bookmark: \(error)")
            return nil
        }
    }

    func clearBookmark() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
