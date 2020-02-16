//
//  Comment.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation


struct Comment: Decodable {
    let postId: Int?
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
}
