//
//  GraphViewController.swift
//  GraphingCalculator
//
//  Created by Scott Moen on 6/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - GraphViewDataSource
    func calculateValue(x x: Double) -> Double {
        brain.varialbeValues["M"] = x
        return brain.result
    }
}
