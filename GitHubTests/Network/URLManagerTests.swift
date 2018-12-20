//
//  URLManagerTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class URLManagerTests: XCTestCase {

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
