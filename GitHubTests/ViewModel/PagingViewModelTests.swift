//
//  PagingViewModelTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class PagingViewModelTests: XCTestCase {

    func testLoadMoreData() {
        
        typealias DisplayModel = SearchVC.ListDisplayModel
        
        let pagingViewModel = PagingViewModel<User, DisplayModel>(endPoint: .searchUsers,
                                                                  transform: { result -> [DisplayModel] in
            return result.map { DisplayModel(username: $0.login,
                                             profileURL: $0.avatarURL,
                                             score: "\($0.score ?? 0.0)",
                                             typeIcon: $0.type.iconImage) }
        })
        
        let expectationPage0 = self.expectation(description: "Paging Data Fetching - Page 0")
        
        pagingViewModel.loadMoreData(query: "hello") { (data, error, page) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(page, 0)
            expectationPage0.fulfill()
        }
        
        self.waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("Paging Data Fetching - Page 0 - Expectations Timeout errored: \(error)")
            }
        }
        
        let expectationPage1 = self.expectation(description: "Paging Data Fetching - Page 1")
        
        pagingViewModel.loadMoreData(query: "hello") { (data, error, page) in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(page, 1)
            expectationPage1.fulfill()
        }
        
        self.waitForExpectations(timeout: 8) { error in
            if let error = error {
                XCTFail("Paging Data Fetching - Page 1 - Expectations Timeout errored: \(error)")
            }
        }
    }

}
