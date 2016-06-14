//
//  GraphViewController.swift
//  GraphingCalculator
//
//  Created by Scott Moen on 6/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit


// MARK: - CGPoint arithmetic

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func +=(inout left: CGPoint, right: CGPoint) {
    left = left + right
}

// MARK: - GraphViewController

class GraphViewController: UIViewController, GraphViewDataSource {

    var program: AnyObject? {
        didSet {
            if program != nil {
                brain.program = program!
            }
        }
    }
    
    private let brain = CalculatorBrain()
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
        }
    }
    
    // MARK: - UIGestureRecognizers

    @IBAction func pan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Changed, .Ended:
            graphView.origin += sender.translationInView(graphView)
            sender.setTranslation(CGPointZero, inView: graphView)
        default:
            break
        }
    }
    
    @IBAction func pinch(sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .Changed, .Ended:
            graphView.scale *= sender.scale
            sender.scale = 1
        default: break
        }
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            graphView.origin = sender.locationInView(graphView)
        }
    }

    // MARK: - GraphViewDataSource
    func calculateValue(x x: Double) -> Double {
        brain.varialbeValues["M"] = x
        return brain.result
    }
}
