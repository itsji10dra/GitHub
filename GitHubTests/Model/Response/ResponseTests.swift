//
//  ResponseTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class ResponseTests: XCTestCase {
    
    // MARK: - Decoding
    
    func testJSONDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "Response", withExtension: "json") else {
            return XCTFail("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { return XCTFail("Data conversion failed.") }
        
        do {
            let response = try Mapper.decoder.decode(Response<User>.self, from: data)
            XCTAssertEqual(response.totalCount, 32)
            XCTAssertEqual(response.incompleteResults, false)
            XCTAssertNotNil(response.data)
        } catch {
            XCTFail("JSON Decoding for class \(Response<User>.self) failed.")
        }
    }
}
