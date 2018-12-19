//
//  PagingViewModel.swift
//  GitHub
//
//  Created by Jitendra Gandhi on 19/11/18.
//  Copyright © 2018 Jitendra Gandhi. All rights reserved.
//

import Foundation

///
/// T: Expected array model from server
/// E: Desired array model object
///

class PagingViewModel<T, E> where T:Decodable {
    
    typealias PagingDataResult = ((_ data: [E]?, _ error: Error?, _ page: UInt) -> Void)
    
    // MARK: - Private Properties
    
    private lazy var receivedDataSource: [T] = []

    private lazy var dataSource: [E] = []
    
    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()
    
    private var lastPageLoaded: Int = -1
    
    // MARK: - Public Properties
    
    private let transform: (([T]) -> [E])
    
    private let endPoint: EndPoint
        
    // MARK: - Initializer
    
    init(endPoint: EndPoint, transform block: @escaping (([T]) -> [E])) {
        self.endPoint = endPoint
        self.transform = block
    }
    
    // MARK: - De-Initializer
    
    deinit {
        dataTask?.cancel()
    }
    
    // MARK: - Public Methods
    
    @discardableResult
    public func loadMoreData(query: String, handler: @escaping PagingDataResult) -> (isLoading: Bool, page: Int) {
        
        //Figure out next page number to be loaded
        let nextPage = lastPageLoaded + 1
        
//        //Do not load, if last data task is already in progress.
//        guard dataTask?.state != .running else { return (true, nextPage) }

        //Add `if` statement and load, only if next page is available.
        //--
            
        //Load next page
        loadData(query: query, page: UInt(nextPage), completionHandler: handler)
        
        return (true, nextPage)
    }
    
    public func dataSource(at index: Int) -> T? {
        return index < receivedDataSource.count ? receivedDataSource[index] : nil
    }
    
    public func clearDataSource() {
        lastPageLoaded = -1
        dataSource.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func loadData(query: String, page: UInt = 0, completionHandler: @escaping PagingDataResult) {
        
        print("Loading Page:", page, " ↔️ Endpoint:", endPoint.rawValue)
        
        let parameter: QueryParameter = [.query: query]
        
        dataTask?.cancel()
        
        guard let url = URLManager.getURLForEndpoint(endPoint, query: parameter, pageNumber: page) else { return }
        
        dataTask = networkManager.dataTaskFromURL(url,
                                                  completion: { [weak self] (result: Result<Response<[T]>>) in
                                                    
            switch result {
            case .success(let response):
                print(" • Page:", page, " success")
                
                let users = response.data
                
                guard let data = self?.transform(users) else { return completionHandler([], nil, page) }
                
                self?.lastPageLoaded = Int(page)
                
                self?.dataSource.append(contentsOf: data)
                
                self?.receivedDataSource.append(contentsOf: users)

                completionHandler(self?.dataSource, nil, UInt(page))
                
            case .failure(let error):
                print(" • Page:", page, " failed. Reason: ", error.localizedDescription)
                completionHandler(nil, error, page)
            }
            
            print("--------------------------------------------------------------------------------------")
        })
        
        dataTask?.resume()
    }
}
