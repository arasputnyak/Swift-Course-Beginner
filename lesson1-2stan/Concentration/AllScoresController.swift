//
//  AllScoresController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 25.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class AllScoresController: UIViewController {
    
    @IBOutlet weak var scoresLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var results : [Result]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        scoresLabel.font = UIFont(name: "PartyLetPlain", size: 50)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        results = results.sorted(by: { res1, res2 -> Bool in
            if let date1 = res1.date, let date2 = res2.date {
                if date1.isEqual(to: date2 as Date) {
                    return res1.score < res2.score
                }
                
                return date1.isLessThanDate(dateToCompare: date2)
            }
            
            return false
        })
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }

}


extension AllScoresController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "scoreCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        
        cell?.textLabel?.textColor = UIColor.orange
        cell?.detailTextLabel?.textColor = UIColor.orange
        cell?.tintColor = UIColor.orange
        cell?.backgroundColor = tableView.backgroundColor
        
        let result = results[indexPath.row]
        
        cell?.textLabel?.text = String(result.score) + " seconds"
        
        if let date = result.date {
            cell?.detailTextLabel?.text = convertDate(date)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


extension AllScoresController {
    func convertDate(_ date : NSDate) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM HH:mm:ss"
        
        let stringDate = formatter.string(from: date as Date)
        return stringDate
    }
    
    @objc func actionSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension NSDate {
    
    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        var isGreater = false
        
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        var isLess = false
        
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        return isLess
    }
    
    func equalToDate(dateToCompare: NSDate) -> Bool {
        var isEqualTo = false
        
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        return isEqualTo
    }
}

