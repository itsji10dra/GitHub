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
    
    @IBOutlet private weak var detailsIconHolder: UIView!

    // MARK: - Data
    
    private var action: (() -> Void)?

    // MARK: - View
    
    init(title: String, text: String, action: (() -> Void)? = nil) {
        super.init(frame: .zero)
        self.loadContentView()
        self.titleLabel.text = title
        self.infoLabel.text = text
        self.action = action
        self.detailsIconHolder.isHidden = action == nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlets Action
    
    @IBAction func viewDidTapped(_ sender: Any) {
        action?()
    }
}
