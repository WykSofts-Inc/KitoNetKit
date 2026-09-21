//
//  KitoNetKitTests.swift
//  KitoNetKit
//
//  Created by Wycliff on 9/19/26.
//  Copyright © 2026 wyksoftsinc.com. All rights reserved.
//

import XCTest
@testable import KitoNetKit

final class KitoNetKitTests: XCTestCase {
    override func tearDown() {
        KitoNetKit.clearAll()
        super.tearDown()
    }

    func testSetScenarioReplacesExistingForSamePattern() {
        KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/pay", condition: .offline))
        KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/pay", condition: .timeout))
        XCTAssertEqual(KitoNetKit.scenarios.count, 1)
    }

    func testScenarioMatchesURLByPattern() {
        let scenario = KitoNetScenario(urlPattern: "api/pay", condition: .offline)
        let url = URL(string: "https://example.com/api/payments/charge")!
        XCTAssertTrue(scenario.matches(url))
    }

    func testRemoveScenarioByPattern() {
        KitoNetKit.setScenario(KitoNetScenario(urlPattern: "api/pay", condition: .offline))
        KitoNetKit.removeScenario(urlPattern: "api/pay")
        XCTAssertTrue(KitoNetKit.scenarios.isEmpty)
    }

    func testInvalidForcedResponseErrorHasMessage() {
        let error = KitoNetKitError.invalidForcedResponse(statusCode: -1)
        XCTAssertNotNil(error.errorDescription)
    }
}
