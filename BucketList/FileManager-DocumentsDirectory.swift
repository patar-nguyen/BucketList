//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Patrick Nguyen on 2023-09-28.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
