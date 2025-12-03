//
//  Utils.swift
//  advent-of-code-2025-swift
//
//  Created by Linus Stöckli on 01.12.2025.
//

import Foundation

func readInput(filename: String) -> String {
    let fileURL = URL(fileURLWithPath: filename)

    guard FileManager.default.fileExists(atPath: fileURL.path) else {
        print("File not found at path: \(fileURL.path)")
        return ""
    }

    guard let contents = try? String(contentsOf: fileURL, encoding: .utf8) else {
        fatalError("Could not read contents of: \(fileURL.path)")
    }

    return contents}
