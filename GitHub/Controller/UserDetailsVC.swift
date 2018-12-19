//
//  UserDetailsVC.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class UserDetailsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImageHolderView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var contentScrollView: UIScrollView!

    @IBOutlet weak var contentStackView: UIStackView!
    
    // MARK: - Data
    
    struct DetailsDisplayModel {
        let username: String
        let name: String?
        let profileImageURL: URL
        let company: String?
        let blog: String?
        let location: String?
        let email: String?
        let hireable: Bool
        let bio: String?
        let publicRepoCount: Int
        let publicGistCount: Int
        let followersCount: Int
        let followingCount: Int
        let createdDate: String?
    }
    
    internal var detailsViewModel: DetailsViewModel!
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = detailsViewModel.username
        
        customiseUI()
        loadDetails()
    }
    
    // MARK: - Private Method

    private func customiseUI() {
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2;
    }
    
    private func loadDetails() {
        
        ActivityIndicator.startAnimating() { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        detailsViewModel.loadUserDetails { [weak self] details, error in
            
            ActivityIndicator.stopAnimating()

            DispatchQueue.main.async {
                if let details = details {
                    self?.loadDetailsInUI(using: details)
                } else if let error = error {
                    
                }
            }
        }
    }
    
    private func loadDetailsInUI(using details: DetailsDisplayModel) {
        
        profileImageView.setImage(with: details.profileImageURL, placeholder: nil)
        
        let views = [DetailInfoView(title: "Name:", text: details.name ?? "NA"),
                     DetailInfoView(title: "Company:", text: details.company ?? "NA"),
                     DetailInfoView(title: "Blog:", text: details.blog ?? "NA"),
                     DetailInfoView(title: "Location:", text: details.location ?? "NA"),
                     DetailInfoView(title: "Email:", text: details.email ?? "NA"),
                     DetailInfoView(title: "Hireable:", text: details.hireable ? "Yes" : "No"),
                     DetailInfoView(title: "Bio:", text: details.bio ?? "NA"),
                     DetailInfoView(title: "Public Repos:", text: "\(details.publicRepoCount)"),
                     DetailInfoView(title: "Public Gists:", text: "\(details.publicGistCount)"),
                     DetailInfoView(title: "Followers:", text: "\(details.followersCount)"),
                     DetailInfoView(title: "Following:", text: "\(details.followingCount)"),
                     DetailInfoView(title: "Created At:", text: details.createdDate ?? "NA")]

        views.forEach { view in contentStackView.addArrangedSubview(view) }
    }
}
