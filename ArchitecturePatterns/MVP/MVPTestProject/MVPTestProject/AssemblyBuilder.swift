//
//  ModuleBuilder.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 16.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

protocol AssemblyBuilderProtocol {
    // func createMainModule() -> UIViewController
    func createNetworkModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController
}


class AssemblyBuilder: AssemblyBuilderProtocol {
//    func createMainModule() -> UIViewController {
//        let model = Person(firstName: "Anastasia", lastName: "Voskresenskaya")
//        let view = MainViewController()
//        let presenter = MainPresenter(view: view, person: model)
//
//        view.presenter = presenter
//
//        return view
//    }
    
    func createNetworkModule(router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = NetworkViewController()
        let presenter = NetworkPresenter(view: view, networkService: networkService, router: router)
        
        view.presenter = presenter
        
        return view
    }
    
    func createDetailModule(comment: Comment?, router: RouterProtocol) -> UIViewController {
        let networkService = NetworkService()
        let view = DetailViewController()
        let presenter = DetailPresenter(view: view, networkService: networkService, router: router, comment: comment)
        
        view.presenter = presenter
        
        return view
    }
}
