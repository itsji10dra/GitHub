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
    
    struct ListDisplayModel {
        let username: String
        let profileURL: URL
        let score: String
        let typeIcon: UIImage
    }
    
    internal let cellIdentifier = "UserCell"
    
    internal lazy var usersArray: [ListDisplayModel] = []
    
    internal var pagingModel: PagingViewModel<User, ListDisplayModel>!
    
    // MARK: - View Hierarchy

    override func viewDidLoad() {
        super.viewDidLoad()

        pagingModel = PagingViewModel<User, ListDisplayModel>(endPoint: .searchUsers,
                                                              transform: { result -> [ListDisplayModel] in
            return result.map { ListDisplayModel(username: $0.login,
                                                 profileURL: $0.avatarURL,
                                                 score: "\($0.score ?? 0.0)",
                                                 typeIcon: $0.type.iconImage) }
        })
        
        usersTableView.tableFooterView = UIView()   //For hiding empty cells...
    }
    
    deinit {
        pagingModel.clearDataSource()
    }
    
    // MARK: - Methods
    
    internal func loadUsers(query: String) {
        
        let loadingInfo = pagingModel.loadMoreData(query: query) { [weak self] (data, error, page) in
            
            DispatchQueue.main.async {
                
                ActivityIndicator.stopAnimating()
                
                if let data = data {
                    self?.usersArray.append(contentsOf: data)
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
                ActivityIndicator.startAnimating()
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
            if let query = self.searchBar.text, query.isEmpty == false {
                self.loadUsers(query: query)
            }
        }
        alertController.addAction(retryAction)

        let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    internal func pushDetailsScene(with info: User) {
        
        guard let detailsVC = Navigation.getViewController(type: UserDetailsVC.self,
                                                           identifer: "UserDetails") else { return }
        detailsVC.detailsViewModel = DetailsViewModel(username: info.login)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

