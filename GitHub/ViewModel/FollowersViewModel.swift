//
//  FollowersViewModel.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

class FollowersViewModel {
    
    // MARK: - Alias
    
    typealias FollowersViewResult = ((_ data: [FollowersListVC.ListDisplayModel]?, _ error: Error?) -> Void)
    
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
    
    public func loadFollowersDetails(_ completion: @escaping FollowersViewResult) {
        
        let pathInfo: PathParameter = [.username: username]
        
        guard let url = URLManager.getURLForEndpoint(.followers, path: pathInfo) else { return completion(nil, nil) }
        
        dataTask?.cancel()
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { (result: Result<[User]>) in
                                                    
            switch result {
            case .success(let users):
                
                let followers = users.map { FollowersListVC.ListDisplayModel(username: $0.login,
                                                                             profileURL: $0.avatarURL,
                                                                             score: "\($0.score ?? 0.0)",
                                                                             typeIcon: $0.type.iconImage) }
                
                completion(followers, nil)
                
            case .failure(let error):
                completion(nil, error)
            }
        })
        
        dataTask?.resume()
    }

    
}
