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

    private var dataTask: URLSessionDataTask?
    
    private lazy var networkManager = NetworkManager()
    
    private var lastPageNumberLoaded: Int = -1
    
    private var loadedAllData: Bool = false

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
        let nextPage = lastPageNumberLoaded + 1
        
        //Load only if next page is available
        guard loadedAllData == false else { return (false, nextPage) }

        //Load next page
        loadData(query: query, page: UInt(nextPage), completionHandler: handler)
        
        return (true, nextPage)
    }
    
    public func dataSource(at index: Int) -> T? {
        return index < receivedDataSource.count ? receivedDataSource[index] : nil
    }
    
    public func clearDataSource() {
        dataTask?.cancel()
        loadedAllData = false
        lastPageNumberLoaded = -1
        receivedDataSource.removeAll()
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
                
                self?.loadedAllData = users.isEmpty
                
                guard let data = self?.transform(users) else { return completionHandler([], nil, page) }
                
                self?.lastPageNumberLoaded = Int(page)
                                
                self?.receivedDataSource.append(contentsOf: users)

                completionHandler(data, nil, UInt(page))
                
            case .failure(let error):
                print(" • Page:", page, " failed. Reason: ", error.localizedDescription)
                completionHandler(nil, error, page)
            }
            
            print("--------------------------------------------------------------------------------------")
        })
        
        dataTask?.resume()
    }
}
