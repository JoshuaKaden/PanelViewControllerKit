//
//  DraggableView.swift
//  PanelViewController
//
//  Created by Kaden, Joshua on 1/24/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate: class {
    func draggingBegan(view: DraggableView)
    func draggingEnded(view: DraggableView, velocity: CGPoint)
    func shouldDrag(view: DraggableView, location: CGPoint) -> Bool
}

class DraggableView: UIView {
    weak var delegate: DraggableViewDelegate?
    
    var floatingHeaderView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            if let newValue = floatingHeaderView {
                addSubview(newValue)
                sendSubview(toBack: newValue)
            }
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        guard let _ = newWindow else { return }
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        addGestureRecognizer(recognizer)
    }
    
    @objc func didPan(_ recognizer: UIPanGestureRecognizer) {
        guard let targetView = superview else { return }
        
        let point = recognizer.translation(in: targetView)

        var frame = self.frame
        frame.size.height = targetView.bounds.height - frame.minY
        self.frame = frame
        
        center = CGPoint(x: center.x, y: center.y + point.y)
        
        recognizer.setTranslation(CGPoint.zero, in: targetView)
        switch recognizer.state {
        case .began, .changed:
            if !(delegate?.shouldDrag(view: self, location: point) ?? true) {
                // Delegate says we should not drag.
                recognizer.isEnabled = false
                return
            }
            if recognizer.state == .began {
                delegate?.draggingBegan(view: self)
            }
        case .cancelled, .ended:
            recognizer.isEnabled = true
            let velocity = recognizer.velocity(in: targetView)
            delegate?.draggingEnded(view: self, velocity: CGPoint(x: 0, y: velocity.y))
        default:
            // no op
            break
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let floatingHeaderView = floatingHeaderView {
            // If the floating header view accepts this touch, then return true.
            if floatingHeaderView.point(inside: convert(point, to: floatingHeaderView), with: event) {
                return true
            }
            // Some areas of the floating header view may want to be pass-through.
            // That is, some touches may want to be handled by the BackViewController.
            // In this case, the view will return "false" for point(inside:).
            // If we return "false", however, then our own gestures (e.g. pan) will not work.
            // So, let's check by hand to see if the point is inside the floating header view.
            // If it is, then return false.
            if point.x > 0 && point.x < floatingHeaderView.bounds.width && point.y > 0 && point.y < floatingHeaderView.bounds.height {
                return false
            }
        }
        // The default path; return super's value.
        return super.point(inside: point, with: event)
    }
}

