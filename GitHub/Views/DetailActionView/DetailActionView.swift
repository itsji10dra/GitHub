//
//  DetailActionView.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class DetailActionView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Data

    private var action: (() -> Void)!
    
    // MARK: - View
    
    init(title: String, action: @escaping (() -> Void)) {
        super.init(frame: .zero)
        loadContentView()
        self.titleLabel.text = title
        self.action = action
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlets Action

    @IBAction func viewDidTapped(_ sender: Any) {
        action()
    }
}
