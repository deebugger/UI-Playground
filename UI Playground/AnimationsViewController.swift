//
//  AnimationsViewController.swift
//  UI Playground
//
//  Created by Dror Ben-Gai on 29/07/2016.
//  Copyright © 2016 Dror Ben-Gai. All rights reserved.
//

import UIKit

enum Direction {
    case RIGHT
    case LEFT
}

class AnimationsViewController: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    private var timer: NSTimer?
    private var currentFrameIndex: Int = 0
    private var currentDirection: Direction = .RIGHT
    private var lastHorizontalVelocity: CGFloat = 0.0
    
    private var currentRotation: CGFloat = 0.0
    
    private let imageFileName = "animated-screw-"
    private let imageFileExt = ".gif"
    private let minInterval: Double = 0.0075
    private let maxInterval: Double = 0.075
    
    private let minScale: CGFloat = 0.25
    private let maxScale: CGFloat = 2.0
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // stop the animation if the view isn't visible anymore
        stopAnimation()
    }
    
    // stop the animation when the user taps on the image
    @IBAction func tapImage(sender: UITapGestureRecognizer) {
        stopAnimation()
    }
    
    // swiping action, with velocity for setting the speed of the resulting animation
    @IBAction func panImage(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Began:
            // when starting to pan, stop the animation
            // so that the user can control the rotation of the image
            stopAnimation()
        case .Changed:
            // upon panning, rotate left and right according to how the user moves
            lastHorizontalVelocity = sender.velocityInView(parentView).x
            currentDirection = lastHorizontalVelocity > 0 ? .RIGHT : .LEFT
            tick()
        case .Ended:
            // when the pan is done, continue rotating at the last velocity
            animate()
        default:
            break
        }
    }
    
    // resize the image, within some min/max boundries
    @IBAction func pinchImage(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .Changed:
            let currentScale: CGFloat = imgView.frame.size.width / imgView.bounds.size.width
            var newScale: CGFloat = currentScale * sender.scale
            newScale = max(newScale, minScale)
            newScale = min(newScale, maxScale)
            
            let transform = CGAffineTransformMakeScale(newScale, newScale)
            imgView.transform = transform
            sender.scale = 1
        default:
            break
        }
    }
    
    // long-press to scale the image back to its default size
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        UIView.animateWithDuration(
            0.5,
            animations: {
                let transform = CGAffineTransformMakeScale(1, 1)
                self.imgView.transform = transform
            }
        )
    }
    
    // starts the timer for animating the image
    private func animate() {
        var interval: Double = Double( 10 / abs(Double(lastHorizontalVelocity)))
        interval = max(interval, minInterval)
        interval = min(interval, maxInterval)
        if timer == nil {
            timer = NSTimer.scheduledTimerWithTimeInterval(
                interval,
                target: self,
                selector: #selector(self.tick),
                userInfo: nil,
                repeats: true)
        }
    }
    
    // stop the animation by invalidating and destroying the timer
    private func stopAnimation() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // one tick of the animation process
    @objc private func tick() {
        imgView.image = UIImage(named: imageFileName + getNextFrameIndex() + imageFileExt)
    }
    
    // get the next frame in the animation,
    // depending on which direction the animation is going
    private func getNextFrameIndex() -> String {
        switch currentDirection {
        case .RIGHT:
            if currentFrameIndex == 0 {
                currentFrameIndex = 35
            } else {
                currentFrameIndex = currentFrameIndex - 1
            }
        case .LEFT:
            if currentFrameIndex == 35 {
                currentFrameIndex = 0
            } else {
                currentFrameIndex = currentFrameIndex + 1
            }
        }

        return currentFrameIndex.description
    }
    
}
