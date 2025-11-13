//
//  FadeImageView.swift
//  VLCPlayer
//
//  Created by uhimania on 2025/11/12.
//

import SwiftUI

struct FadeImageView: View {
    @Binding var image: String
    @State private var opacity: Double = 0
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    
    var body: some View {
        if !image.isEmpty {
            Image(systemName: image)
                .resizable()
                .opacity(opacity)
                .frame(width: width, height: height)
                .onAppear() {
                    runAnimation()
                }
                .onChange(of: image) { _, _ in
                    runAnimation()
                }
        }
    }
    
    private func runAnimation() {
        opacity = 1
        width = 50
        height = 50
        
        withAnimation {
            opacity = 0
            width = 100
            height = 100
        }
    }
}

#Preview {
    @Previewable @State var image = ""
    FadeImageView(image: $image)
}
