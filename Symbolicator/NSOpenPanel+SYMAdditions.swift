//
//  NSOpenPanel+SYMAdditions.swift
//  Symbolicator
//
//  Created by Sam Stigler on 6/6/14.
//  Copyright (c) 2014 Symbolicator. All rights reserved.
//

import AppKit

extension NSOpenPanel {
    convenience init(message: String, fileType: String) {
        self.init()
        canChooseDirectories = false
        canChooseFiles = true
        allowsMultipleSelection = false
        allowedFileTypes = [fileType]
        canCreateDirectories = false
        prompt = "Choose"
        self.message = message
        treatsFilePackagesAsDirectories = false
    }
}