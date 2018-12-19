//
//  User.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let login: String
    let id: Int
    let nodeId: String
    let avatarURL: URL
    let gravatarId: String
    let url, htmlURL, followersURL: URL
    let followingURL, gistsURL, starredURL: String
    let subscriptionsURL, organizationsURL, reposURL: URL
    let eventsURL: String
    let receivedEventsURL: String
    let type: UserType
    let siteAdmin: Bool
    let score: Double?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let publicRepos, publicGists, followers, following: Int?
    let createdAt, updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeId = "node_id"
        case avatarURL = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case score
        case name, company, blog, location, email, hireable, bio
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
