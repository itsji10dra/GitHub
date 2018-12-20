//
//  URLManagerTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
import Nimble
@testable import GitHub

class URLManagerTests: XCTestCase {

    func testGetURLForEndpointWithoutQueryParam() {
        
        var reachedPoint1 = false
        var reachedPoint2 = false
        
        let exception: BadInstructionException? = catchBadInstruction {
            reachedPoint1 = true
            _ = URLManager.getURLForEndpoint(.searchUsers)
            reachedPoint2 = true
        }
        XCTAssertNotNil(exception)
        XCTAssertTrue(reachedPoint1)
        XCTAssertFalse(reachedPoint2)
    }
    
    func testGetURLForEndpointWithoutPathParam() {
        
        var reachedPoint1 = false
        var reachedPoint2 = false
        
        let exception: BadInstructionException? = catchBadInstruction {
            reachedPoint1 = true
            _ = URLManager.getURLForEndpoint(.user)
            reachedPoint2 = true
        }
        XCTAssertNotNil(exception)
        XCTAssertTrue(reachedPoint1)
        XCTAssertFalse(reachedPoint2)
    }

    func testGetURLForEndpoint() {
        
        let parameter: QueryParameter = [.query: "xyz"]

        guard let url = URLManager.getURLForEndpoint(.searchUsers, query: parameter) else {
            return XCTFail("Endpoint searchUsers returning nil URL")
        }
        XCTAssertNotNil(url)
        
        guard let configuredURL = URL(string: Configuration.url) else {
            return XCTFail("Configured string URL not converting to Foundation URL.")
        }
        XCTAssertNotNil(configuredURL)

        XCTAssertEqual(url.host, configuredURL.host)
        XCTAssertEqual(url.scheme, configuredURL.scheme)
        XCTAssertEqual(url.user, configuredURL.user)
        XCTAssertEqual(url.password, configuredURL.password)
        XCTAssertEqual(url.port, configuredURL.port)
        
        let pathComponents = url.pathComponents
        XCTAssertNotNil(pathComponents)
        XCTAssertEqual(pathComponents.count, 3)
        
        guard let urlComponent = URLComponents(string: url.absoluteString) else {
            return XCTFail("Failed to generate `URLComponent` from `url`.")
        }
        XCTAssertEqual(urlComponent.queryItems?.count, 1)
        
        let pageValue = urlComponent.queryItems?.first(where: {$0.name == "page"})?.value
        XCTAssertNil(pageValue)

        let query = urlComponent.queryItems?.first(where: {$0.name == "q"})?.value
        XCTAssertEqual(query, "xyz")
    }
    
    func testGetURLForEndpointWithPage() {
        
        let parameter: QueryParameter = [.query: "xyz"]

        guard let url = URLManager.getURLForEndpoint(.searchUsers, query: parameter, pageNumber: 3) else {
            return XCTFail("Endpoint searchUsers returning nil URL")
        }
        XCTAssertNotNil(url)

        guard let urlComponent = URLComponents(string: url.absoluteString) else {
            return XCTFail("Failed to generate `URLComponent` from `url`.")
        }
        XCTAssertEqual(urlComponent.queryItems?.count, 2)
        
        let page = urlComponent.queryItems?.first(where: {$0.name == "page"})?.value
        XCTAssertNotNil(page)
        XCTAssertEqual(page, "3")
    }
}
