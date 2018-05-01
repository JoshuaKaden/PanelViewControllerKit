//
//  DragHandleView.swift
//  PanelViewController
//
//  Created by Ruparelia, Kaushil on 3/1/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

class DragHandleView: UIView {
    
    var handleColor: UIColor? {
        get { return handleView.backgroundColor }
        set { handleView.backgroundColor = newValue }
    }
    
    private let handleView = UIView()
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        handleView.layer.cornerRadius = 3
        addSubview(handleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dragHandleWidth = CGFloat(44)
        handleView.frame = CGRect(x: (bounds.width / 2) - (dragHandleWidth / 2), y: 8, width: dragHandleWidth, height: 5)
    }
}
