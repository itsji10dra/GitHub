//
//  SearchVC+Delegates.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import UIKit
import FireCache

extension SearchVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        pagingModel.clearDataSource()
        usersArray.removeAll()
        
        searchText.isEmpty ? usersTableView.reloadData() : loadUsers(query: searchText)
    }
}

extension SearchVC: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.height
        
        if bottomEdge >= scrollView.contentSize.height {    //We reached bottom
            if let query = searchBar.text {
                loadUsers(query: query)
            }
        }
    }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserCell
        
        let user = usersArray[indexPath.row]
        
        cell?.usernameLabel?.text = user.username
        cell?.scoreLabel?.text = user.score
        cell?.profileImageView.setImage(with: user.profileURL, placeholder: nil)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let infoObj = pagingModel.dataSource(at: indexPath.row) else { return }
        pushDetailsScene(with: infoObj)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
