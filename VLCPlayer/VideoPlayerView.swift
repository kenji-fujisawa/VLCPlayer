//
//  VideoPlayerView.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/11.
//

import SwiftUI
import VLCKit

struct VideoPlayerView: NSViewRepresentable {
    @Binding var url: URL?
    
    func makeNSView(context: Context) -> PlayerView {
        PlayerView()
    }
    
    func updateNSView(_ nsView: PlayerView, context: Context) {
        if let url = url {
            nsView.setUrl(url: url)
        }
    }
    
    class PlayerView: NSView {
        private var url: URL? = nil
        private let player = VLCMediaPlayer()
        
        init() {
            super.init(frame: .zero)
            
            self.player.drawable = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            if let url = self.url,
               !isSecurityScoped(url: url) {
                url.stopAccessingSecurityScopedResource()
            }
        }
        
        func setUrl(url: URL) {
            if url == self.url { return }
            
            if let url = self.url,
               !isSecurityScoped(url: url){
                url.stopAccessingSecurityScopedResource()
            }
            
            if !isSecurityScoped(url: url) {
                guard url.startAccessingSecurityScopedResource() else { return }
            }
            
            let media = VLCMedia(url: url)
            player.media = media
            player.play()
            
            self.url = url
        }
        
        private func isSecurityScoped(url: URL) -> Bool {
            (try? url.bookmarkData(options: .withSecurityScope)) != nil
        }
    }
}

#Preview {
    @Previewable @State var url: URL?
    VideoPlayerView(url: $url)
}
