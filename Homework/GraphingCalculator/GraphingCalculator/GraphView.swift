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
        return CGPoint(x: bounds.midX, y: bounds.midY)
//        return CGPointZero
    }
    
    private var scale: CGFloat {
        return 16
    }

    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        drawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        let step = 1 / contentScaleFactor
        var xBounds: CGFloat = 0
        var penDown = false
        let path = UIBezierPath()
        
        while xBounds < bounds.width {
            let xGraph = xToGraph(x: xBounds)
            if let yGraph = dataSource?.calculateValue(x: xGraph) {
                let yBounds = yToBounds(y: yGraph)
                
                if penDown {
                    path.addLineToPoint(CGPoint(x: xBounds, y: yBounds))
                } else {
                    path.moveToPoint(CGPoint(x: xBounds, y: yBounds))
                    penDown = true
                }
            } else {
                penDown = false
            }
            xBounds += step
        }
        
        
        path.stroke()
    }
    
    // MARK: - Translation
    private func xToGraph(x x: CGFloat) -> Double {
        return Double((x - origin.x) / scale)
    }
    
    private func yToBounds(y y: Double) -> CGFloat {
        return origin.y - (CGFloat(y) * scale)
    }
}
