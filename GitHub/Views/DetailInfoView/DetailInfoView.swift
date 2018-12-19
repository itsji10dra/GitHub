//
//  DetailInfoView.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class DetailInfoView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var infoLabel: UILabel!
    
    // MARK: - View
    
    init(title: String, text: String) {
        super.init(frame: .zero)
        loadContentView()
        self.titleLabel.text = title
        self.infoLabel.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
