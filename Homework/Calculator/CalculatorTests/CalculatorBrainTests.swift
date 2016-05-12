//
//  CalculatorBrainTests.swift
//  Calculator
//
//  Created by Scott Moen on 5/12/16.
//  Copyright © 2016 Scott Moen. All rights reserved.
//

import XCTest
@testable import Calculator


class CalculatorBrainTests: XCTestCase {
    var brain: CalculatorBrain!
    
    override func setUp() {
        super.setUp()
        brain = CalculatorBrain()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescriptionACD() {
        // a. touching 7 + would show “7 + ...” (with 7 still in the display)
        brain.setOperand(7)
        brain.performOperation("+")

        XCTAssert(brain.result == 7, String(brain.result))
        XCTAssert(brain.isPartialResult == true)
        XCTAssert(brain.description == "7.0+", brain.description)
        
        // c. 7 + 9 = would show “7 + 9 =” (16 in the display)
        brain.setOperand(9)
        brain.performOperation("=")
        
        XCTAssert(brain.result == 16, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "7.0+9.0", brain.description)
        
        // d. 7 + 9 = √ would show “√(7 + 9) =” (4 in the display)
        brain.performOperation("√")
        
        XCTAssert(brain.result == 4, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "√(7.0+9.0)", brain.description)
    }
    
    func testDescriptionEF() {
        // e. 7 + 9 √ would show “7 + √(9) ...” (3 in the display)
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        
        XCTAssert(brain.result == 3, String(brain.result))
        XCTAssert(brain.isPartialResult == true)
        XCTAssert(brain.description == "7.0+√(9.0)", brain.description)
        
        // f. 7 + 9 √ = would show “7 + √(9) =“ (10 in the display)
        brain.performOperation("=")
        
        XCTAssert(brain.result == 10, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "7.0+√(9.0)", brain.description)
    }
    
    func testDescriptionG() {
        // g. 7 + 9 = + 6 + 3 = would show “7 + 9 + 6 + 3 =” (25 in the display)
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        
        XCTAssert(brain.result == 25, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "7.0+9.0+6.0+3.0", brain.description)
    }
    
    func testDescriptionK() {
        // k. 4 × π = would show “4 × π =“ (12.5663706143592 in the display)
        brain.setOperand(4)
        brain.performOperation("×")
        brain.performOperation("π")
    
        XCTAssert(brain.result == M_PI, String(brain.result))
        XCTAssert(brain.isPartialResult == true)
        XCTAssert(brain.description == "4.0×π", brain.description)
        
        brain.performOperation("=")
        XCTAssert(brain.result == 4*M_PI, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "4.0×π", brain.description)
    }
    
    func testDescriptionM() {
        // m. 4 + 5 × 3 = could also show “(4 + 5) × 3 =” if you prefer (27 in the display)
        brain.setOperand(4)
        brain.performOperation("+")
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(3)
        brain.performOperation("=")
        
        XCTAssert(brain.result == 27, String(brain.result))
        XCTAssert(brain.isPartialResult == false)
        XCTAssert(brain.description == "(4.0+5.0)×3.0", brain.description)
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}