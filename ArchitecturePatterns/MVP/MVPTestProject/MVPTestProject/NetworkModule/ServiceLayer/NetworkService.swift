//
//  NetworkService.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getComments(completion: @escaping ([Comment]?, Error?) -> Void)
}


class NetworkService: NetworkServiceProtocol {
    func getComments(completion: @escaping ([Comment]?, Error?) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/comments"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            do {
                let obj = try JSONDecoder().decode([Comment].self, from: data!)
                completion(obj, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    
}
