//
//  VideoPlayerView.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/11.
//

import Combine
import SwiftUI
import VLCKit

class VideoPlayerViewModel: ObservableObject {
    enum State {
        case stopped
        case playing
        case paused
    }
    
    let player = VLCMediaPlayer()
    var media: VLCMedia? = nil
    private var url: URL? = nil
    @Published var state: State = .stopped
    @Published var currentTime: Duration = .zero
    @Published var totalTime: Duration = .zero
    @Published var position: Double = 0
    @Published var rate: Float = 1.0
    
    deinit {
        if let url = self.url,
           !isSecurityScoped(url: url) {
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func play(url: URL) {
        if url == self.url { return }
        
        if let url = self.url,
           !isSecurityScoped(url: url){
            url.stopAccessingSecurityScopedResource()
        }
        
        if !isSecurityScoped(url: url) {
            guard url.startAccessingSecurityScopedResource() else { return }
        }
        
        self.url = url
        
        media = VLCMedia(url: url)
        player.media = media
        player.play()
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func jumpForward(seconds: Int) {
        let position = (currentTime + .seconds(seconds)) / totalTime
        jump(to: position)
    }
    
    func jumpBackward(seconds: Int) {
        let position = (currentTime - .seconds(seconds)) / totalTime
        jump(to: position)
    }
    
    func jump(to position: Double) {
        let time = Double(totalTime.attoseconds) * 1e-15 * min(max(position, 0), 1)
        player.time = VLCTime(int: Int32(time))
        
        self.currentTime = .milliseconds(time)
        self.position = position
    }
    
    func setRate(_ rate: Float) {
        player.fastForward(atRate: rate)
        self.rate = rate
    }
    
    private func isSecurityScoped(url: URL) -> Bool {
        (try? url.bookmarkData(options: .withSecurityScope)) != nil
    }
}

struct VideoPlayerView: NSViewRepresentable {
    @ObservedObject var model: VideoPlayerViewModel
    
    func makeNSView(context: Context) -> some NSView {
        let view = PlayerView(model: model)
        model.player.drawable = view
        model.player.delegate = view
        return view
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
    }
    
    class PlayerView: NSView, VLCMediaPlayerDelegate {
        var model: VideoPlayerViewModel
        
        init(model: VideoPlayerViewModel) {
            self.model = model
            
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func mediaPlayerTimeChanged(_ aNotification: Notification) {
            model.totalTime = .milliseconds(model.media?.length.intValue ?? 0)
            
            if model.player.time == model.media?.length {
                model.currentTime = model.totalTime
            } else {
                model.currentTime = .milliseconds(model.player.time.intValue)
            }
            
            model.position = model.currentTime / model.totalTime
        }
        
        func mediaPlayerStateChanged(_ aNotification: Notification) {
            switch model.player.state {
            case .playing: model.state = .playing
            case .paused: model.state = .paused
            case .stopped: model.state = .stopped
            case .ended: model.state = .stopped
            default: break
            }
        }
    }
}

#Preview {
    let model = VideoPlayerViewModel()
    VideoPlayerView(model: model)
}
