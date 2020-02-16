//
//  NetworkViewController.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NetworkViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }

}


extension NetworkViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // cell.textLabel?.text = "Test"
        
        let comment = presenter.comments?[indexPath.row]
        cell.textLabel?.text = comment?.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let comment = presenter.comments?[indexPath.row]
        // let detVC = AssemblyBuilder().createDetailModule(comment: comment)
        // navigationController?.pushViewController(detVC, animated: true)
        presenter.tapOnTheComment(comment: comment)
    }
    
}


extension NetworkViewController: NetworkViewProtocol {
    func success() {
        tableView.reloadData()
    }
    
    func failure(error: Error) {
        print("error!: \(error.localizedDescription)")
    }
}
