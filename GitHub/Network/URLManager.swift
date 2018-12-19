//
//  URLManager.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct URLManager {
    
    // MARK: - Public Methods
    
    public static func getURLForEndpoint(_ endpoint: EndPoint,
                                         path: PathParameter? = nil,
                                         query: QueryParameter? = nil) -> URL? {
        
        let path = endpoint.updatePath(from: path ?? [:])       //let's create full path
        
        let url = Configuration.url + path                      //Create full URL
        
        guard var urlComponents = URLComponents(string: url) else { return nil }
        
        let queryItems = endpoint.getMandatoryQueryItems(from: query ?? [:])    //Get query Items
        
        urlComponents.queryItems = queryItems                   //Append Query Items
        
        return urlComponents.url                                //Return full URL.
    }
}
