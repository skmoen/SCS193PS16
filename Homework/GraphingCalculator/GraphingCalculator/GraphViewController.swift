//
//  GraphViewController.swift
//  GraphingCalculator
//
//  Created by Scott Moen on 6/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var program: AnyObject?
    
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
        return 2 * x
    }
}
