//
//  Mapper.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

struct Mapper {
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.gitHubDateFormatter)
        return decoder
    }()
}
