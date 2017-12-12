//
//  cariocaUITests.swift
//  cariocaUITests
//
//  Created by Arnaud Schloune on 09/03/2017.
//  Copyright © 2017 Arnaud Schloune. All rights reserved.
//

import XCTest

class CariocaUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
