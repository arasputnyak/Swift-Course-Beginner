//
//  DetailViewController.swift
//  MVPTestProject
//
//  Created by Анастасия Распутняк on 11.02.2020.
//  Copyright © 2020 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var commentLabel: UILabel!
    
    var presenter: DetailViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.setComment()
    }

    @IBAction func actionPop(_ sender: UIButton) {
        presenter.pop()
    }
}


extension DetailViewController: DetailViewProtocol {
    func setComment(comment: Comment?) {
        commentLabel.text = comment?.body
    }
}
