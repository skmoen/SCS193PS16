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
            // convert X in view bounds to graph's coordinate system
            let xGraph = xToGraph(x: xBounds)
            
            // calculate value of Y from graph's X value
            if let yGraph = dataSource?.calculateValue(x: xGraph) {
                
                // convert Y result back to view bounds coordinate
                let yBounds = yToBounds(y: yGraph)
                
                // if pen is down, draw a line; otherwise move to point
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
    
    // convert X coordinate from view bounds to graph coordinate system
    private func xToGraph(x x: CGFloat) -> Double {
        return Double((x - origin.x) / scale)
    }
    
    // convert Y coordinate from graph coordinate system to view bounds
    private func yToBounds(y y: Double) -> CGFloat {
        return origin.y - (CGFloat(y) * scale)
    }
}
