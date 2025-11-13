//
//  VLCPlayerApp.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/10.
//

import SwiftUI

@main
struct VLCPlayerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appDelegate)
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .pasteboard) {}
            CommandGroup(replacing: .undoRedo) {}
            OpenFileCommands()
        }
    }
}

@Observable
class AppDelegate: NSObject, NSApplicationDelegate {
    var urls: [URL] = []
    
    func application(_ application: NSApplication, open urls: [URL]) {
        self.urls = urls
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
