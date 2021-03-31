//
//  AnimationFrames.swift
//  BWS
//
//  Created by Dhruvit on 07/11/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // MARK:- NowPlayingAnimation
    func createNowPlayingAnimation() {
        self.animationImages = AnimationFrames.createFrames()
        self.animationDuration = 0.7
    }
    
    func startNowPlayingAnimation(_ animate: Bool) {
        self.createNowPlayingAnimation()
        animate ? self.startAnimating() : self.stopAnimating()
    }
    
    // MARK:- Player Tutorial Animation
    func createPlayerTutorialAnimation() {
        self.animationImages = AnimationFrames.createPlayerTutorialAnimationFrames()
        self.animationDuration = 10
    }
    
    func startPlayerTutorialAnimation(_ animate: Bool) {
        self.createPlayerTutorialAnimation()
        animate ? self.startAnimating() : self.stopAnimating()
    }
    
}

class AnimationFrames {
    
    class func createFrames() -> [UIImage] {
    
        // Setup "Now Playing" Animation Bars
        var animationFrames = [UIImage]()
        for i in 0...3 {
            if let image = UIImage(named: "NewNowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        
        for i in stride(from: 2, to: 0, by: -1) {
            if let image = UIImage(named: "NewNowPlayingBars-\(i)") {
                animationFrames.append(image)
            }
        }
        return animationFrames
    }
    
    class func createPlayerTutorialAnimationFrames() -> [UIImage] {
    
        // Setup "Now Playing" Animation Bars
        var animationFrames = [UIImage]()
        for i in 0...6 {
            if let image = UIImage(named: "player_tut-\(i)") {
                animationFrames.append(image)
            }
        }
        
        return animationFrames
    }

}
