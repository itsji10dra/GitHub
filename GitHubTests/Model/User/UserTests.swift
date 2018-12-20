//
//  UserTests.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import XCTest
@testable import GitHub

class UserTests: XCTestCase {

    // MARK: - Decoding
    
    func testJSONDecoding() {
        
        let testBundle = Bundle(for: type(of: self))
        guard let fileURL = testBundle.url(forResource: "User", withExtension: "json") else {
            return XCTFail("Unable to load JSON from bundle")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else { return XCTFail("Data conversion failed.") }
        
        do {
            let user = try Mapper.decoder.decode(User.self, from: data)
            XCTAssertEqual(user.login, "dead-horse")
            XCTAssertEqual(user.id, 985607)
            XCTAssertEqual(user.nodeId, "MDQ6VXNlcjk4NTYwNw==")
            XCTAssertEqual(user.avatarURL.absoluteString, "https://avatars3.githubusercontent.com/u/985607?v=4")
            XCTAssertEqual(user.gravatarId, "")
            XCTAssertEqual(user.url.absoluteString, "https://api.github.com/users/dead-horse")
            XCTAssertEqual(user.htmlURL.absoluteString, "https://github.com/dead-horse")
            XCTAssertEqual(user.followersURL.absoluteString, "https://api.github.com/users/dead-horse/followers")
            XCTAssertEqual(user.followingURL, "https://api.github.com/users/dead-horse/following{/other_user}")
            XCTAssertEqual(user.gistsURL, "https://api.github.com/users/dead-horse/gists{/gist_id}")
            XCTAssertEqual(user.starredURL, "https://api.github.com/users/dead-horse/starred{/owner}{/repo}")
            XCTAssertEqual(user.subscriptionsURL.absoluteString, "https://api.github.com/users/dead-horse/subscriptions")
            XCTAssertEqual(user.organizationsURL.absoluteString, "https://api.github.com/users/dead-horse/orgs")
            XCTAssertEqual(user.reposURL.absoluteString, "https://api.github.com/users/dead-horse/repos")
            XCTAssertEqual(user.eventsURL, "https://api.github.com/users/dead-horse/events{/privacy}")
            XCTAssertEqual(user.receivedEventsURL, "https://api.github.com/users/dead-horse/received_events")
            XCTAssertEqual(user.type, .user)
            XCTAssertEqual(user.siteAdmin, false)
            XCTAssertEqual(user.name, "Yiyu He")
            XCTAssertEqual(user.company, "@alipay @alibaba @eggjs ")
            XCTAssertEqual(user.blog, "https://twitter.com/deadhorse_busi")
            XCTAssertEqual(user.location, "Hangzhou, China")
            XCTAssertNil(user.email)
            XCTAssertNil(user.hireable)
            XCTAssertEqual(user.bio, "TypeError: Cannot read property 'Bio' of undefined")
            XCTAssertEqual(user.publicRepos, 119)
            XCTAssertEqual(user.publicGists, 24)
            XCTAssertEqual(user.followers, 3516)
            XCTAssertEqual(user.following, 85)
            XCTAssertEqual(user.following, 85)
            XCTAssertEqual(user.createdAt?.description, "2011-08-17 08:43:05 +0000")
            XCTAssertEqual(user.updatedAt?.description, "2018-08-02 07:57:13 +0000")
        } catch {
            XCTFail("JSON Decoding for class \(User.self) failed.")
        }
    }
}
