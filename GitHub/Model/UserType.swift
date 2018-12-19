//
//  UserType.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

enum UserType: String, Decodable {
    
    case user = "User"
    
    case organization = "Organization"
    
    var iconImage: UIImage {
        switch self {
        case .user:
           return  #imageLiteral(resourceName: "user")
        case .organization:
           return  #imageLiteral(resourceName: "organization")
        }
    }
}
