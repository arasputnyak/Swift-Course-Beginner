//
//  NetworkPresenterTest.swift
//  MVPTestProjectTests
//
//  Created by Анастасия Распутняк on 16.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import XCTest
@testable import MVPTestProject

class MockNetworkView: NetworkViewProtocol {
    func success() {
        
    }
    
    func failure(error: Error) {
        
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var comments: [Comment]?
    
    init() {
    }
    
    convenience init(comments: [Comment]?) {
        self.init()
        self.comments = comments
    }
    
    func getComments(completion: @escaping ([Comment]?, Error?) -> Void) {
        if let comments = comments {
            completion(comments, nil)
        } else {
            let error = NSError(domain: "", code: 0, userInfo: nil)
            completion(nil, error)
        }
    }
}

class NetworkPresenterTest: XCTestCase {
    
    var view: NetworkViewProtocol!
    var presenter: NetworkPresenter!
    var networkService: NetworkServiceProtocol!
    var router: RouterProtocol!
    var comments = [Comment]()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let navVC = UINavigationController()
        let builder = AssemblyBuilder()
        router = Router(navigationController: navVC, assemblyBuilder: builder)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        view = nil
        networkService = nil
        presenter = nil
    }

    func testGetSuccessComments() {
        let comment = Comment(postId: 2, id: 1, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockNetworkView()
        networkService = MockNetworkService(comments: comments)
        presenter = NetworkPresenter(view: view, networkService: networkService, router: router)
        
        var catchedComments: [Comment]?
        
        networkService.getComments { (comments, error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                catchedComments = comments
            }
        }
        
        XCTAssertNotEqual(catchedComments?.count, 0)
        XCTAssertEqual(catchedComments?.count, comments.count)
    }
    
    func testGetFailureComments() {
        let comment = Comment(postId: 2, id: 1, name: "Bar", email: "Baz", body: "Foo")
        comments.append(comment)
        
        view = MockNetworkView()
        networkService = MockNetworkService()
        presenter = NetworkPresenter(view: view, networkService: networkService, router: router)
        
        var catchedError: Error?
        
        networkService.getComments { (comments, error) in
            if let error = error {
                catchedError = error
            } else {
                print("Ok")
            }
        }
        
        XCTAssertNotNil(catchedError)
    }

}
