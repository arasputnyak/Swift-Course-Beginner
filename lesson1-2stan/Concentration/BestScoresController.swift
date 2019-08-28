//
//  ScoresController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 22.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class BestScoresController: UIViewController {
    
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    let context = CoreDataManager.instance.persistentContainer.viewContext
    var users : [User]!
    var bestScores : [Int32]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scoresLabel.font = UIFont(name: "PartyLetPlain", size: 50)
        backButton.titleLabel?.font = UIFont(name: "PartyLetPlain", size: 30)
        
        users = getUsers(context: context)
        bestScores = getBestScores()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func actionToStart(_ sender: UIButton) {
        if let navigation = self.navigationController {
            
            var controller = navigation.presentingViewController
            
            while controller!.presentingViewController != nil {
                controller = controller?.presentingViewController
            }
            
            controller?.dismiss(animated: true, completion: nil)
        }
        
    }
}


extension BestScoresController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "scoreCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! ScoreCell
        
        let user = users[indexPath.row]
        
        if let photo = user.photo as Data? {
            cell.userPicImageView.image = UIImage(data: photo)
        }
        
        cell.userNameLabel.text = user.name
        cell.bestScoreLabel.text = String(bestScores[indexPath.row]) + "s"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let currentUser = users[indexPath.row]
        let results = Array(currentUser.results!)
        
        if let allScoresController = self.storyboard?.instantiateViewController(withIdentifier: "AllScoresController") as? AllScoresController {
            if let results = results as? [Result] {
                allScoresController.results = results
                
                self.navigationController?.pushViewController(allScoresController, animated: true)
            }
        }
        
        
    }
    
}


extension BestScoresController {
    func getBestScores() -> [Int32] {
        var best = [Int32]()
        
        for user in users {
            let scores = user.results?.sorted(by: { res1, res2 -> Bool in
                if let res1 = res1 as? Result, let res2 = res2 as? Result {
                    return res1.score < res2.score
                }
                
                return false
            })
            
            let bestScore = scores?.first
            if let bestScore = bestScore as? Result {
                best.append(bestScore.score)
            }
        }
        
        return best
    }
    
}
