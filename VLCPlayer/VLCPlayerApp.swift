//
//  VLCPlayerApp.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/10.
//

import SwiftUI

@main
struct VLCPlayerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onDisappear() {
                    NSApplication.shared.terminate(nil)
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            OpenFileCommands()
        }
    }
}
