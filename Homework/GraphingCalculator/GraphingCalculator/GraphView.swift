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
    
    @IBInspectable var scale: CGFloat = 16 {
        didSet {
            setNeedsDisplay()
        }
    }

    var origin = CGPoint(x: 100, y: 200) {
        didSet {
            setNeedsDisplay()
        }
    }
    
//    private var origin: CGPoint {
//        return CGPoint(x: bounds.midX, y: bounds.midY)
//    }
    
    override func drawRect(rect: CGRect) {
        let drawer = AxesDrawer(contentScaleFactor: contentScaleFactor)
        drawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: scale)
        
        if dataSource != nil {
            let maxCount = Int(bounds.width * contentScaleFactor)
            var penDown = false
            let path = UIBezierPath()
            
            for count in 0...maxCount {
                let xBounds = CGFloat(count) / contentScaleFactor
                
                // convert X in view bounds to graph's coordinate system
                let xGraph = xToGraph(x: xBounds)
                
                // calculate value of Y from graph's X value
                let yGraph = dataSource!.calculateValue(x: xGraph)
                if yGraph.isFinite {
                    // convert Y result back to view bounds coordinate
                    let yBounds = yToBounds(y: yGraph)
                    let newPoint = CGPoint(x: xBounds, y: yBounds)
                    
                    // if pen is down, draw a line; otherwise move to point
                    if penDown {
                        path.addLineToPoint(newPoint)
                    } else {
                        path.moveToPoint(newPoint)
                        penDown = true
                    }
                } else {
                    penDown = false
                }
            }
            
            path.stroke()
        }
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
