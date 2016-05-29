//
//  ViewController.swift
//  FaceIt
//
//  Created by Scott Moen on 5/19/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Grin) {  didSet { updateUI() } }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(
                target: faceView,
                action: #selector(FaceView.changeScale(_:))
            ))
            
            let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.increaseHappiness))
            happierSwipeGestureRecognizer.direction = .Up
            faceView.addGestureRecognizer(happierSwipeGestureRecognizer)

            let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
                target: self,
                action: #selector(FaceViewController.decreaseHappiness))
            sadderSwipeGestureRecognizer.direction = .Down
            faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
            
            updateUI()
        }
    }
    
    private let mouthCurvatures = [
        FacialExpression.Mouth.Frown: -1.0,
        .Smirk: -0.5,
        .Neutral: 0,
        .Grin: 0.5,
        .Smile: 1.0,
    ]
    
    private let eyeBrowTilts = [
        FacialExpression.EyeBrows.Relaxed: 0.5,
        .Furrowed: -0.5,
        .Normal: 0
    ]

    @IBAction func toggleEyes(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private func updateUI() {
        switch expression.eyes {
        case .Open: faceView.eyesOpen = true
        case .Closed: faceView.eyesOpen = false
        case .Squinting: faceView.eyesOpen = false
        }
        faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0
        faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0
    }
}
