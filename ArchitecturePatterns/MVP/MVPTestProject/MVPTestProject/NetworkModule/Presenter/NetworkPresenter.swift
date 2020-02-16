//
//  NetworkPresenter.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

protocol NetworkViewProtocol: class {
    func success()
    func failure(error: Error)
}

protocol NetworkViewPresenterProtocol: class {
    var comments: [Comment]? {get set}
    init(view: NetworkViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol)
    func getComments()
    func tapOnTheComment(comment: Comment?)
}


class NetworkPresenter: NetworkViewPresenterProtocol {
    var comments: [Comment]?
    weak var view: NetworkViewProtocol?
    var router: RouterProtocol?
    let networkService: NetworkServiceProtocol!
    
    required init(view: NetworkViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
        
        getComments()
    }
    
    func getComments() {
        networkService.getComments { [weak self] (comments, error) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let comments = comments {
                    self.comments = comments
                    self.view?.success()
                    return
                }
                
                if let error = error {
                    self.view?.failure(error: error)
                }
            }
        }
    }
    
    func tapOnTheComment(comment: Comment?) {
        router?.showDetail(comment: comment)
    }
    
}
