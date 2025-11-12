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
    @ObservedObject private var model = VideoPlayerViewModel()
    
    var body: some View {
        VStack {
            VideoPlayerView(model: model)
        }
        .overlay {
            ControllerView(model: model)
        }
        .focusedSceneValue(\.openFileAction, OpenFileAction(showImporter: { showImporter = true }))
        .fileImporter(isPresented: $showImporter, allowedContentTypes: [.movie], allowsMultipleSelection: false) { result in
            switch result {
            case .success(let urls):
                if let url = urls.first {
                    model.play(url: url)
                }
            case .failure(let error):
                print(error)
            }
        }
        .dropDestination(for: URL.self) { items, location in
            if let url = items.first {
                model.play(url: url)
            }
        }
        .onAppear() {
            if let url = appDelegate.urls.first {
                model.play(url: url)
            }
        }
    }
}

#Preview {
    ContentView()
}
