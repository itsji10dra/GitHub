//
//  UserDetailsVC.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit
import SafariServices

class UserDetailsVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var profileImageHolderView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var contentScrollView: UIScrollView!

    @IBOutlet weak var contentStackView: UIStackView!
    
    @IBOutlet weak var profileViewHolderHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Data
    
    struct DetailsDisplayModel {
        let username: String
        let name: String?
        let profileImageURL: URL
        let webProfileURL: URL
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
        let updatedDate: String?
    }
    
    internal var detailsViewModel: DetailsViewModel!
    
    private var loadedDetails: DetailsDisplayModel?
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = detailsViewModel.username
        
        customiseUI()
        loadDetails()
    }
    
    // MARK: - IBOutlets Action
    
    @IBAction func shareProfileAction(_ sender: UIBarButtonItem) {
        let text = "Username: \(loadedDetails?.username ?? "NA"), Profile: \(loadedDetails?.webProfileURL.absoluteString ?? "-")"
        let content = [profileImageView.image as Any, text].compactMap { $0 }
        let activityViewController = UIActivityViewController(activityItems: content, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true, completion: nil)
    }

    // MARK: - Private Method

    private func customiseUI() {
        contentScrollView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
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
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadDetailsInUI(using details: DetailsDisplayModel) {
        
        contentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
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
                     DetailInfoView(title: "Followers:", text: "\(details.followersCount)", action: { [unowned self] in self.loadFollowers() }),
                     DetailInfoView(title: "Following:", text: "\(details.followingCount)"),
                     DetailInfoView(title: "Last Updated:", text: details.updatedDate ?? "NA"),
                     DetailInfoView(title: "Show on web", text: "", action: { [unowned self] in self.loadURL(url: details.webProfileURL) })]

        views.forEach { view in contentStackView.addArrangedSubview(view) }
        
        loadedDetails = details
    }
    
    private func loadURL(url: URL) {
        let controller = SFSafariViewController(url: url)
        present(controller, animated: true, completion: nil)
    }
    
    private func loadFollowers() {
        pushFollowersScene(username: detailsViewModel.username)
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
            self.loadDetails()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel){ [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    internal func pushFollowersScene(username: String) {
        
        guard let followersVC = Navigation.getViewController(type: FollowersListVC.self,
                                                           identifer: "FollowersList") else { return }
        followersVC.followersViewModel = FollowersViewModel(username: username)
        navigationController?.pushViewController(followersVC, animated: true)
    }

}
