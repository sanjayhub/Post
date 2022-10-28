//
//  LoadingView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 28/10/22.
//

import SwiftUI

struct LoadingView: View {
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    
    var body: some View {
        let animation = Animation
            .easeIn(duration: 1.25)
            .repeatForever(autoreverses: false)
       return Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                scale = 0
                opacity = 1
                withAnimation(animation) {
                    scale = 1
                    opacity = 0
                }
            }
    }
}
