//
//  DetailsViewModelTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class DetailsViewModelTests: XCTestCase {

    func testLoadUserDetails() {
        
        let viewModel = DetailsViewModel(username: "itsji10dra")
        
        let expectation = self.expectation(description: "User Details Fetching")
        
        viewModel.loadUserDetails { (data, error) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("Tram Fetching waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
