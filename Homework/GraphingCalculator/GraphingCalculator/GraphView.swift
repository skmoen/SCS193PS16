//
//  GraphView.swift
//  GraphingCalculator
//
//  Created by Scott Moen on 6/11/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func calculateValue(x x: Double) -> Double
}

@IBDesignable class GraphView: UIView {
    weak var dataSource: GraphViewDataSource?

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
//        drawer.drawAxesInRect(bounds, origin: CGPoint(x: bounds.midX, y: bounds.midY), pointsPerUnit: 16)
        drawer.drawAxesInRect(bounds, origin: CGPointZero, pointsPerUnit: 16)
        
        let step = 1 / contentScaleFactor
        var count: CGFloat = 0
        var penDown = false
        let path = UIBezierPath()
        
        while count < bounds.width {
            let x = Double(count)  // todo: translate
            if let y = dataSource?.calculateValue(x: x) {
                if penDown {
                    path.addLineToPoint(CGPoint(x: x, y: y))
                } else {
                    path.moveToPoint(CGPoint(x: x, y: y))
                    penDown = true
                }
            } else {
                penDown = false
            }
            count += step
        }
        
        path.stroke()
    }
}
