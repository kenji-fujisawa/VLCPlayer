//
//  OpenFileCommands.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/11.
//

import SwiftUI

struct OpenFileAction {
    var showImporter: () -> Void
}

struct OpenFileKey: FocusedValueKey {
    typealias Value = OpenFileAction
}

extension FocusedValues {
    var openFileAction: OpenFileAction? {
        get { self[OpenFileKey.self] }
        set { self[OpenFileKey.self] = newValue }
    }
}

struct OpenFileCommands: Commands {
    @FocusedValue(\.openFileAction) private var action
    
    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Open...", systemImage: "arrow.up.right.square") {
                action?.showImporter()
            }
        }
    }
}
