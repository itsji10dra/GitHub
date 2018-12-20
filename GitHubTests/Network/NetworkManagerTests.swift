//
//  NetworkManagerTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class NetworkManagerTests: XCTestCase {

    var session: URLSessionMock!
    var manager: NetworkManager!

    override func setUp() {
        session = URLSessionMock()
        manager = NetworkManager(session: session)
    }
    
    func testSuccess() {
        
        let data = getSuccessData()
        session.data = data
        session.error = nil

        let url = URL(fileURLWithPath: "http://mocktest.url")

        var result: Result<Response<[User]>>? = nil
        let task = manager.dataTaskFromURL(url, completion: { result = $0 })
        task.resume()
        XCTAssertNotNil(result)

        switch result {
        case .success(let response)?:
            XCTAssertNotNil(response)
            XCTAssertEqual(response.data.count, 2)
            XCTAssertEqual(response.data.first?.login, "hellyeah")
            XCTAssertEqual(response.data.last?.login, "hellyeahllc")

        case .failure(let error)?:
            XCTAssertNil(error)
        
        case .none:
            XCTFail("Unknown Case Occurred")
        }
    }
    
    func testError() {
        session.error = NSError(domain: "Some Error Domain", code: 101) as Error

        let url = URL(fileURLWithPath: "http://mocktest.url")
        
        var result: Result<Response<[User]>>? = nil
        let task = manager.dataTaskFromURL(url, completion: { result = $0 })
        task.resume()
        XCTAssertNotNil(result)
        
        switch result {
        case .success(let response)?:
            XCTAssertNil(response)
            
        case .failure(let error)?:
            XCTAssertNotNil(error)
            XCTAssertEqual((error as NSError).code, 101)
            XCTAssertEqual((error as NSError).domain, "Some Error Domain")

        case .none:
            XCTFail("Unknown Case Occurred")
        }
    }
    
    private func getSuccessData() -> Data {
        
        let testBundle = Bundle(for: type(of: self))
        
        guard let fileURL = testBundle.url(forResource: "Success", withExtension: "json") else {
            fatalError("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { fatalError("Data conversion failed.") }
        
        return data
    }
}
