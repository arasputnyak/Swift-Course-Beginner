//
//  MainPresenter.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


protocol MainViewProtocol: class {
    func setGreeting(greeting: String)
}

protocol MainViewPresenterProtocol: class {
    init(view: MainViewProtocol, person: Person)
    func showGreeting()
}


class MainPresenter: MainViewPresenterProtocol {
    let view: MainViewProtocol  // D <- SOLID
    let person: Person
    
    required init(view: MainViewProtocol, person: Person) {
        self.view = view
        self.person = person
    }
    
    func showGreeting() {
        let greeting = "Hello, \(self.person.firstName) \(self.person.lastName)!"
        self.view.setGreeting(greeting: greeting)
    }
}
