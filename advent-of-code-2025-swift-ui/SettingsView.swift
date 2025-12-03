//
//  SettingsView.swift
//  advent-of-code-2025-swift-ui
//
//  Created by Linus Stöckli on 03.12.2025.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isShowingFileImporter = false

    @AppStorage("workingDirectory") var workingDirectory: String = ""
    @State private var selectedURL: URL?

    var body: some View {
        VStack(spacing: 20) {
            Text("Select Working Directory")
                .font(.headline)

            if let url = selectedURL ?? getStoredURL() {
                Text("\(url.path)")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            } else {
                Text("No directory selected")
                    .foregroundColor(.secondary)
            }

            Button("Choose Folder") {
                isShowingFileImporter = true
            }

            Button("Close") {
                dismiss()
            }
        }
        .padding()
        .fileImporter(
            isPresented: $isShowingFileImporter,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    saveBookmark(for: url)
                    selectedURL = url
                }
            case .failure(let error):
                print("Failed to select folder: \(error)")
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                selectedURL = getStoredURL()
            }
        }
    }

    // MARK: - Bookmark handling

    let bookmarkKey = "WorkingDirectoryBookmark"

    func saveBookmark(for url: URL) {
        do {
            let bookmarkData = try url.bookmarkData(
                options: [.withSecurityScope],
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            UserDefaults.standard.set(bookmarkData, forKey: bookmarkKey)
            workingDirectory = url.path
            print("✅ Bookmark saved for: \(url.path)")
        } catch {
            print("❌ Error saving bookmark: \(error)")
        }
    }

    func getStoredURL() -> URL? {
        guard let data = UserDefaults.standard.data(forKey: bookmarkKey) else { return nil }

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
                print("⚠️ Couldn't access resource.")
                return nil
            }
        } catch {
            print("❌ Error resolving bookmark: \(error)")
            return nil
        }
    }
}
