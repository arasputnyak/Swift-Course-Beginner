//
//  MainController.swift
//  Concentration
//
//  Created by Анастасия Распутняк on 21.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import CoreData

class MainController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    var scoreCount = 0
    var timerCount = 0 {
        didSet {
            timerLabel.text = "\(oldValue)"
        }
    }
    var timerStarted = false
    let context = CoreDataManager.instance.persistentContainer.viewContext
    var timer = Timer()
    var cards : [UIImage?]!
    var clicked : UIButton?
    var congratsLabel : UILabel?
    var player : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainLabel.font = UIFont(name: "PartyLetPlain", size: 50)
        countLabel.font = UIFont(name: "PartyLetPlain", size: 30)
        timerLabel.font = UIFont(name: "PartyLetPlain", size: 30)
        
        var pairs = [[UIButton]]()
        for i in 0..<(cardButtons.count / 2) {
            pairs.append([])
            while pairs[i].count < 2 {
                let random = Int(arc4random()) % cardButtons.count
                if cardButtons[random].tag == 0 {
                    cardButtons[random].tag = i + 1
                    cardButtons[random].imageView?.layer.cornerRadius = 10
                    cardButtons[random].addTarget(self, action: #selector(actionFlipCard), for: .touchUpInside)
                    pairs[i].append(cardButtons[random])
                }
            }
        }
        
        cards = [UIImage(named: "card-front-1"),
                 UIImage(named: "card-front-2"),
                 UIImage(named: "card-front-3"),
                 UIImage(named: "card-front-4"),
                 UIImage(named: "card-front-5"),
                 UIImage(named: "card-front-6"),
                 UIImage(named: "card-back")]
        
        for card in cardButtons {
            card.setImage(cards!.last!, for: .normal)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !timerStarted {
            timerStarted = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
        
    }
    
    @objc func updateTimer() {
        timerCount += 1
    }
    
    @objc func actionFlipCard(sender : UIButton) {
        
        if sender.image(for: .normal) != cards.last {
            return
        }
        
        sender.setImage(cards[sender.tag - 1], for: .normal)
        UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            if self.clicked == nil {
                self.clicked = sender
            } else {
                
                if sender.imageView?.image == self.clicked?.imageView?.image {
                    
                    self.scoreCount += 1
                    OperationQueue.main.addOperation {
                        self.countLabel.text = "\(self.scoreCount)/\(self.cards.count - 1)"
                        
                        UIView.transition(with: self.clicked!, duration: 0.5, options: .transitionCurlUp, animations: {
                            self.clicked?.alpha = 0
                        }, completion: { finished in
                            if finished {
                                self.clicked?.removeFromSuperview()
                                self.clicked = nil
                            }
                        })
                        
                        UIView.transition(with: sender, duration: 0.5, options: .transitionCurlUp, animations: {
                            sender.alpha = 0
                        }, completion: { finished in
                            if finished {
                                sender.removeFromSuperview()
                            }
                        })
                    }
                    
                    if self.scoreCount == 6 {
                        
                        self.timer.invalidate()
                        self.timerLabel.text = ""
                        self.saveResult()
                        
                        self.addLabel()
                        if self.congratsLabel != nil {
                            self.enlarge()
                        }
                    }
                    
                } else {
                    
                    sender.setImage((self.cards?.last)!, for: .normal)
                    self.clicked?.setImage((self.cards?.last)!, for: .normal)
                    
                    UIView.transition(with: sender, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    UIView.transition(with: self.clicked!, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    
                    self.clicked = nil
                }
            }
        })
    }

}


extension MainController {
    
    func addLabel() {
        congratsLabel = UILabel()
        congratsLabel!.alpha = 0
        congratsLabel!.text = "Congratulations!"
        congratsLabel!.textColor = createColor(withRed: 255, green: 149, andBlue: 49)
        congratsLabel!.font = UIFont(name: "PartyLetPlain", size: 20)
        congratsLabel!.textAlignment = .center
        congratsLabel!.sizeToFit()
        congratsLabel!.center = self.view.center
        
        self.view.addSubview(congratsLabel!)
    }
    
    func enlarge() {
        var biggerBounds = congratsLabel!.bounds
        congratsLabel!.font = congratsLabel!.font.withSize(60)
        biggerBounds.size = congratsLabel!.intrinsicContentSize
        
        congratsLabel!.transform = scaleTransform(from: biggerBounds.size, to: congratsLabel!.bounds.size)
        congratsLabel!.bounds = biggerBounds
        
        UIView.animate(withDuration: 3,
                       animations: {
                        self.congratsLabel!.alpha = 1
                        self.congratsLabel!.transform = .identity
        }) { _ in
            UIView.transition(with: self.congratsLabel!,
                              duration: 3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.congratsLabel?.text = "Take a Treat"
            }, completion: { _ in
                
                let navigController = self.storyboard?.instantiateViewController(withIdentifier: "BestScoresNavigContr")
                self.present(navigController!, animated: true, completion: nil)
            })
        }
    }
    
    private func scaleTransform(from: CGSize, to: CGSize) -> CGAffineTransform {
        let scaleX = to.width / from.width
        let scaleY = to.height / from.height
        
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    func saveResult() {
        let newResult = NSEntityDescription.entity(forEntityName: String(describing: Result.self), in: context)
        if let newResultEntity = NSManagedObject(entity: newResult!, insertInto: context) as? Result {
            newResultEntity.player = player
            newResultEntity.score = Int32(timerCount)
            newResultEntity.date = NSDate()
        }
        
        do {
            try context.save()
            print("saved!")
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}
