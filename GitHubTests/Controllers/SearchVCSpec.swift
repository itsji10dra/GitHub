//
//  SearchVCSpec.swift
//  GitHubTests
//
//  Created by Jitendra Gandhi on 20/12/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Quick
import Nimble
@testable import GitHub

class SearchVCSpec: QuickSpec {

    override func spec() {
        describe("SearchVC") {
            var searchVC: SearchVC?

            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                searchVC = storyboard.instantiateViewController(withIdentifier: "Search") as? SearchVC
                
                typealias DisplayModel = SearchVC.ListDisplayModel

                searchVC?.usersArray = [DisplayModel(username: "User",
                                                    profileURL: URL(string: "http://www.xyz.com")!,
                                                    score: "1.7",
                                                    typeIcon: UserType.user.iconImage),
                                        DisplayModel(username: "Organization",
                                                     profileURL: URL(string: "http://pqr.com")!,
                                                     score: "9.4",
                                                     typeIcon: UserType.organization.iconImage)]
                
                _ = searchVC?.view // .view // load it up
            }

            it("should initialize with 2 rows") {
                let userTable = searchVC?.usersTableView

                let rowsCount = userTable?.numberOfRows(inSection: 0)
                expect(rowsCount) == 2

                let firstCell = userTable?.cellForRow(at: IndexPath(row: 0, section: 0)) as? UserCell
                expect(firstCell?.usernameLabel.text) == "User"
                expect(firstCell?.scoreLabel?.text) == "1.7"
                
                let secondCell = userTable?.cellForRow(at: IndexPath(row: 1, section: 0)) as? UserCell
                expect(secondCell?.usernameLabel.text) == "Organization"
                expect(secondCell?.scoreLabel?.text) == "9.4"
            }
        }
    }
}
