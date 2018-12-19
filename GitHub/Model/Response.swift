//
//  Response.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct Response<T>: Decodable where T: Decodable {
    
    let totalCount: Int
    
    let incompleteResults: Bool
    
    let data: T
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case data
    }
}
