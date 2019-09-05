//
//  ViewController.swift
//  PlayingCard
//
//  Created by Анастасия Распутняк on 31.08.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playingCardView: PlayingCardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
            swipe.direction = [.left, .right]
            
            playingCardView.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(playingCardView.adjustFaceCardScale))
            playingCardView.addGestureRecognizer(pinch)
        }
    }
    
    var deck = PlayingCardDeck()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc
    func actionSwipe(sender : UISwipeGestureRecognizer) {
        if let card = deck.draw() {
            playingCardView.rank = card.rank.order!
            playingCardView.suit = card.suit.rawValue
        }
    }

    @IBAction func actionTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCardView.isFacedUp = !playingCardView.isFacedUp
        default:
            break
        }
        
    }
    
}

