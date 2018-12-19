//
//  UserType.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

enum UserType: String, Decodable {
    
    case user = "User"
    
    case organization = "Organization"
}
