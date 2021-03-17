//
//  AnimationView.swift
//  kanto-test
//
//  Created by Hugo Jovan Ramírez Cerón on 17/03/21.
//

import Foundation
import Lottie

enum AnimationGallery: String {
    case loading
}

extension AnimationView {
    
    func playAnimation(_ type: AnimationGallery, loopMode: LottieLoopMode = .loop) {
        self.animation = Animation.named(type.rawValue)
        self.loopMode = loopMode
        self.play()
    }
}
