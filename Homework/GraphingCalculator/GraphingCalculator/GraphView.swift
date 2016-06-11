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
    
    private var origin: CGPoint {
//        return CGPoint(x: bounds.midX, y: bounds.midY)
        return CGPointZero
    }
    
    private var scale: CGFloat {
        return 16
    }

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        drawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        let step = 1 / contentScaleFactor
        var count: CGFloat = 0
        var penDown = false
        let path = UIBezierPath()
        
        while count < bounds.width {
            let x = xToGraph(x: count)
            if let value = dataSource?.calculateValue(x: x) {
                let y = yToBounds(y: value)
                if penDown {
                    path.addLineToPoint(CGPoint(x: count, y: y))
                } else {
                    path.moveToPoint(CGPoint(x: count, y: y))
                    penDown = true
                }
            } else {
                penDown = false
            }
            count += step
        }
        
        path.stroke()
    }
    
    // MARK: - Translation
    private func xToGraph(x x: CGFloat) -> Double {
        return Double(x)
    }
    
    private func yToBounds(y y: Double) -> CGFloat {
        return CGFloat(y)
    }
}
