//
//  ControllerView.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/12.
//

import SwiftUI

struct ControllerView: View {
    @ObservedObject var model: VideoPlayerViewModel
    @State private var editing = false
    @State private var position: Double = 0
    @State private var hover: Bool = false
    
    private let rateCanditates: [Float] = [0.5, 1.0, 1.5, 2.0]
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Rectangle()
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                
                HStack {
                    Button {
                        model.jumpBackward(seconds: 15)
                    } label: {
                        Image(systemName: "gobackward.15")
                    }
                    
                    if model.state == .playing {
                        Button {
                            model.pause()
                        } label: {
                            Image(systemName: "pause.fill")
                        }
                    } else if model.state == .paused {
                        Button {
                            model.play()
                        } label: {
                            Image(systemName: "play.fill")
                        }
                    } else {
                        Image(systemName: "play.fill")
                    }
                    
                    Button {
                        model.jumpForward(seconds: 15)
                    } label: {
                        Image(systemName: "goforward.15")
                    }
                    
                    Slider(value: $position) { editing in
                        self.editing = editing
                        if !editing {
                            model.jump(to: position)
                        }
                    }
                    .onChange(of: position, { _, _ in
                        if editing {
                            model.jump(to: position)
                        }
                    })
                    .onChange(of: model.position) { _, _ in
                        if !editing {
                            position = model.position
                        }
                    }
                    
                    Text(model.currentTime, format: .time(pattern: .minuteSecond))
                    Text("/")
                    Text(model.totalTime, format: .time(pattern: .minuteSecond))
                    
                    Picker("Speed", selection: $model.rate) {
                        ForEach(rateCanditates, id: \.self) { rate in
                            Text("x\(rate.formatted(.number.precision(.fractionLength(1))))")
                        }
                    } currentValueLabel: {
                        Text("x\(model.rate.formatted(.number.precision(.fractionLength(1))))")
                            .foregroundStyle(.white)
                    }
                    .labelsHidden()
                    .onChange(of: model.rate) { _, _ in
                        model.setRate(model.rate)
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(.white)
                .padding()
            }
            .opacity(hover ? 1.0 : 0.0)
            .onHover { hover in
                withAnimation {
                    self.hover = hover
                }
            }
        }
    }
}

#Preview {
    let model = VideoPlayerViewModel()
    ControllerView(model: model)
}
