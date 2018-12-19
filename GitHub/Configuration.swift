//
//  Configuration.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

struct Configuration {
    
    // Mark: - App Configuration
    
    static let url = "https://api.github.com/"
    
    static let pageSize = 15
    
    // Mark: - Initializer
    
    private init() { }      //Private, init not allowed
    
    // Mark: - Methods
    
    static func checkConfiguration() {
        if url.isEmpty {
            fatalError("Invalid configuration found.")
        }
    }
}
