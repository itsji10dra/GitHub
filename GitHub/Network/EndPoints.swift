//
//  EndPoint.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

typealias PathParameter = [EndPointPath:String]
typealias QueryParameter = [QueryItem:String]

enum EndPoint {
    
    case user
    
    case searchUsers
    
    case followers

    var rawValue: String {
        switch self {
        case .user:
            let usernamePath = EndPointPath.username.rawValue
            return "users/" + usernamePath
        case .searchUsers:
            return "search/users"
        case .followers:
            let usernamePath = EndPointPath.username.rawValue
            return "users/" + usernamePath + "/followers"
        }
    }
}

// MARK: - Query Items

extension EndPoint {
    
    private var mandatoryQueryItems: [QueryItem] {     //This includes array of mandatory parameters, for status-code 200.
        switch self {
        case .user:
            return []
        case .searchUsers:
            return [.query]
        case .followers:
            return []
        }
    }
    
    public func getMandatoryQueryItems(from parameters: QueryParameter) -> [URLQueryItem] {
        
        //Validating, query parameters passed contains all mandatory items or not.
        let missingParameters = mandatoryQueryItems.filter { parameters.keys.contains($0) == false }
        
        assert(missingParameters.isEmpty, "Missing query parameters: \(missingParameters)")
        
        return parameters.map { URLQueryItem(name: $0.key.rawValue, value: $0.value) }
    }
}

// MARK: - Endpoint Paths

extension EndPoint {
    
    private var endpointPaths: [EndPointPath] {     //This includes array of paths parameters, for `errorMessage` to be null.
        switch self {
        case .user:
            return [.username]
        case .searchUsers:
            return []
        case .followers:
            return [.username]
        }
    }

    public func updatePath(from parameters: PathParameter) -> String {
        
        //Validating, path parameters passed contains all possible values or not.
        let missingParameters = endpointPaths.filter { parameters.keys.contains($0) == false }
        
        assert(missingParameters.isEmpty, "Missing endpoint path: \(missingParameters)")
        
        var url = self.rawValue
        
        parameters.forEach { url = url.replacingOccurrences(of: $0.key.rawValue, with: $0.value) }
        
        return url
    }
}
