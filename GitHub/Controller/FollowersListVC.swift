//
//  FollowersListVC.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class FollowersListVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var followersTableView: UITableView!
        
    // MARK: - Data
    
    struct ListDisplayModel {
        let username: String
        let profileURL: URL
        let typeIcon: UIImage
    }
    
    internal let cellIdentifier = "UserCell"
    
    internal lazy var followersArray: [ListDisplayModel] = []
    
    internal var followersViewModel: FollowersViewModel!

    // MARK: - View Hierarchy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customiseUI()
        loadFollowers()
    }
    
    // MARK: - Methods

    private func customiseUI() {
        followersTableView.tableFooterView = UIView()   //For hiding empty cells...
    }

    private func loadFollowers() {
        
        ActivityIndicator.startAnimating() { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        followersViewModel.loadFollowersDetails { [weak self] (data, error) in
            
            ActivityIndicator.stopAnimating()
            
            DispatchQueue.main.async {
                if let data = data {
                    if data.isEmpty {
                        self?.showErrorAlert(with: "No followers found.")
                    } else {
                        self?.followersArray = data
                        self?.followersTableView.reloadData()
                    }
                } else if let error = error {
                    self?.showErrorAlert(with: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
            self.loadFollowers()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel){ [unowned self] _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension FollowersListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserCell
        
        let user = followersArray[indexPath.row]
        
        cell?.usernameLabel?.text = user.username
        cell?.profileImageView.setImage(with: user.profileURL, placeholder: nil)
        cell?.typeIconImageView.image = user.typeIcon
        
        return cell ?? UITableViewCell()
    }
}
