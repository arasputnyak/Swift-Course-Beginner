//
//  DetailPresenter.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


protocol DetailViewProtocol: class {
    func setComment(comment: Comment?)
}

protocol DetailViewPresenterProtocol: class {
    init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, comment: Comment?)
    func setComment()
    func pop()
}


class DetailPresenter: DetailViewPresenterProtocol {
    var view: DetailViewProtocol?
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol?
    var comment: Comment?
    
    required init(view: DetailViewProtocol, networkService: NetworkServiceProtocol, router: RouterProtocol, comment: Comment?) {
        self.view = view
        self.networkService = networkService
        self.router = router
        self.comment = comment
    }
    
    public func setComment() {
        view?.setComment(comment: comment)
    }
    
    func pop() {
        router?.popToRoot()
    }
    
}
