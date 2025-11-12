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
    @ObservedObject private var model = VideoPlayerViewModel()
    @State private var showImporter: Bool = false
    @State private var image: String = ""
    
    var body: some View {
        ZStack {
            VideoPlayerView(model: model)
                .onTapGesture {
                    if model.state == .playing {
                        model.pause()
                        image = "pause.circle"
                    } else if model.state == .paused {
                        model.play()
                        image = "play.circle"
                    }
                }
            
            FadeImageView(image: $image)
                .foregroundStyle(.white)
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
