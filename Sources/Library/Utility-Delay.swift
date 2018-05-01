//
//  Utility-Delay.swift
//  PanelViewController
//
//  Created by Joshua Kaden on 1/27/18.
//  Copyright © 2018 NYC DoITT. All rights reserved.
//

import Foundation

/** Waits a number of seconds, and then performs a closure on the main thread.
 Hats off to Matt Neuburg: http://stackoverflow.com/questions/24034544/dispatch-after-gcd-in-swift/24318861#24318861 */
func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
