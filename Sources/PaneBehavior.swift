//
//  PaneBehavior.swift
//  PanelViewController
//
//  Created by Kaden, Joshua on 1/24/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

final class PaneBehavior: UIDynamicBehavior {
    var targetPoint = CGPoint.zero {
        didSet {
            attachmentBehavior.anchorPoint = targetPoint
        }
    }
    
    var velocity = CGPoint.zero {
        didSet {
            let current = itemBehavior.linearVelocity(for: item)
            let delta = CGPoint(x: 0, y: velocity.y - current.y)
            itemBehavior.addLinearVelocity(delta, for: item)
        }
    }
    
    private let attachmentBehavior: UIAttachmentBehavior
    private let item: UIDynamicItem
    private let itemBehavior: UIDynamicItemBehavior
    
    init(item: UIDynamicItem) {
        self.item = item
        
        let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: CGPoint.zero)
        attachmentBehavior.damping = 0.6
        attachmentBehavior.frequency = 3.5
        attachmentBehavior.length = 0
        self.attachmentBehavior = attachmentBehavior
        
        let itemBehavior = UIDynamicItemBehavior(items: [item])
        itemBehavior.density = 100
        itemBehavior.resistance = 10
        self.itemBehavior = itemBehavior
        
        super.init()
        
        self.addChildBehavior(attachmentBehavior)
        self.addChildBehavior(itemBehavior)
    }
}
