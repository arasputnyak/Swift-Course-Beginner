//
//  RouterTest.swift
//  MVPTestProjectTests
//
//  Created by Анастасия Распутняк on 16.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import XCTest
@testable import MVPTestProject

class MockNavVC: UINavigationController {
    var presentedVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        presentedVC = viewController
        super.pushViewController(viewController, animated: animated)
    }
}

class RouterTest: XCTestCase {
    
    var router: RouterProtocol!
    var navVC = MockNavVC()
    let builder = AssemblyBuilder()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        router = Router(navigationController: navVC, assemblyBuilder: builder)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        router = nil
    }

    func testRouter() {
        router.showDetail(comment: nil)
        let detailVC = navVC.presentedVC
        
        XCTAssertTrue(detailVC is DetailViewController)
    }

}
