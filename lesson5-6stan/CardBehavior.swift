//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Анастасия Распутняк on 09.09.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior : UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        // animator.addBehavior(behavior)
        return behavior
    }()
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0  // collisions don't loose any energy
        behavior.resistance = 0
        // animator.addBehavior(behavior)
        return behavior
    }()
    var gravityBehavior : UIGravityBehavior = {
        let behavior = UIGravityBehavior()
        behavior.magnitude = 0
        return behavior
    }()
    
    private func push(_ item : UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        // push.angle = (2 * CGFloat.pi).arc4random
        if let referencedBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referencedBounds.midX, y: referencedBounds.midY)
            switch (item.center.x, item.center.y) {
            case let(x, y) where x < center.x && y < center.y:
                push.angle = (CGFloat.pi / 2).arc4random
            case let(x, y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi - (CGFloat.pi / 2).arc4random
            case let(x, y) where x < center.x && y > center.y:
                push.angle = (-CGFloat.pi / 2).arc4random
            case let(x, y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi + (CGFloat.pi / 2).arc4random
            default:
                push.angle = (CGFloat.pi * 2).arc4random
            }
        }
        
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        push.action = { [unowned push, weak self] in
            // push.dynamicAnimator?.removeBehavior(push)
            self?.removeChildBehavior(push)
        }
        
        addChildBehavior(push)
        // animator.addBehavior(push)
    }
    
    func addItem(_ item : UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
	gravityBehavior.addItem(item)
    }
    
    func removeItem(_ item : UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
	gravityBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
	addChildBehavior(gravityBehavior)
    }
    
    convenience init(in animator : UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }

}
