//
//  ContentView.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/10.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Environment(AppDelegate.self) private var appDelegate
    @State private var showImporter: Bool = false
    @State private var url: URL? = nil
    
    var body: some View {
        VStack {
            VideoPlayerView(url: $url)
        }
        .padding()
        .focusedSceneValue(\.openFileAction, OpenFileAction(showImporter: { showImporter = true }))
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.movie], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    self.url = url
                }
            case .failure(let error):
                print(error)
            }
        }
        .dropDestination(for: URL.self) { items, location in
            if let url = items.first {
                self.url = url
            }
        }
        .onAppear() {
            if let url = appDelegate.urls.first {
                self.url = url
            }
        }
    }
}

#Preview {
    ContentView()
}
