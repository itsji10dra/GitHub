//
//  ViewController.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var usersTableView: UITableView!
    
    @IBOutlet weak var loaderView: LoadingView!

    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Data
    
    struct UserListDisplayModel {
        let name: String
    }
    
    internal let cellIdentifier = "UserCell"
    
    internal lazy var usersArray: [UserListDisplayModel] = []
    
    internal var pagingModel: PagingViewModel<User, UserListDisplayModel>!
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        pagingModel = PagingViewModel<User, UserListDisplayModel>(endPoint: .searchUsers,
                                                              transform: { result -> [UserListDisplayModel] in
            return result.map { UserListDisplayModel(name: $0.login) }
        })
    }
    
    deinit {
        pagingModel.clearDataSource()
    }
    
    // MARK: - Methods
    
    internal func loadUsers(query: String) {
        
        let loadingInfo = pagingModel.loadMoreData(query: query) { [weak self] (data, error, page) in
            
            DispatchQueue.main.async {
                if let data = data {
                    self?.usersArray = data
                    self?.usersTableView.reloadData()
                    self?.loaderView.hide()
                } else if let error = error {
                    if page == 0 {
                        if (error as NSError).code != NSURLErrorCancelled {
                            self?.showErrorAlert(with: error.localizedDescription)
                        }
                    } else {
                        self?.loaderView.showMessage("Error loading data.", animateLoader: false, autoHide: 5.0)
                    }
                }
            }
        }
        
        if loadingInfo.isLoading {
            if loadingInfo.page == 0 {
//                refreshControl.endRefreshing()
            } else {
                loaderView.showMessage("Loading...", animateLoader: true)
            }
        } else {
            loaderView.hide()
        }
    }
    
    // MARK: - Alerts
    
    private func showErrorAlert(with message: String) {
        
        let alertController = UIAlertController(title: "Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [unowned self] _ in
            if let query = self.searchBar.text {
                self.loadUsers(query: query)
            }
        }
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

