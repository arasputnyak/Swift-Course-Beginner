//
//  MainPresenterTest.swift
//  MVPTestProjectTests
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import XCTest
@testable import MVPTestProject

class MockView: MainViewProtocol {
    var titleTest: String?
    func setGreeting(greeting: String) {
        titleTest = greeting
    }
    
}

class MainPresenterTest: XCTestCase {
    var view: MockView!
    var person: Person!
    var presenter: MainPresenter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        view = MockView()
        person = Person(firstName: "Baz", lastName: "Bar")
        presenter = MainPresenter(view: view, person: person)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        view = nil
        person = nil
        presenter = nil
    }
    
    func testModuleIsNotNil() {
        XCTAssertNotNil(view, "view is not nil")
        XCTAssertNotNil(person, "person is not nil")
        XCTAssertNotNil(presenter, "presenter is not nil")
    }
    
    func testView() {
        presenter.showGreeting()
        XCTAssertEqual(view.titleTest, "Hello, Baz Bar!")
    }
    
    func testPersonModel() {
        XCTAssertEqual(person.firstName, "Baz")
        XCTAssertEqual(person.lastName, "Bar")
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }

}
