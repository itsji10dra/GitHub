//
//  DetailsViewModel.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class DetailsViewModel {

    // MARK: - Alias
    
    typealias DetailsViewResult = ((_ details: UserDetailsVC.DetailsDisplayModel?, _ error: Error?) -> Void)
    
    // MARK: - Data
    
    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()
    
    internal let username: String
    
    // MARK: - Initializer
    
    public init(username: String) {
        self.username = username
    }
    
    // MARK: - De-Initializer
    
    deinit {
        dataTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    public func loadUserDetails(_ completion: @escaping DetailsViewResult) {
        
        let pathInfo: PathParameter = [.username: username]
        
        guard let url = URLManager.getURLForEndpoint(.user, path: pathInfo) else { return completion(nil, nil) }
        
        dataTask?.cancel()
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { (result: Result<User>) in
                                                    
            switch result {
            case .success(let user):
                
                let details = UserDetailsVC.DetailsDisplayModel(username: user.login,
                                                                name: user.name,
                                                                profileImageURL: user.avatarURL,
                                                                company: user.company,
                                                                blog: user.blog,
                                                                location: user.location,
                                                                email: user.email,
                                                                hireable: user.hireable ?? false,
                                                                bio: user.bio,
                                                                publicRepoCount: user.publicRepos ?? 0,
                                                                publicGistCount: user.publicGists ?? 0,
                                                                followersCount: user.followers ?? 0,
                                                                followingCount: user.following ?? 0,
                                                                createdDate: user.createdAt?.description)
                
                completion(details, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        })
        
        dataTask?.resume()
    }
}
