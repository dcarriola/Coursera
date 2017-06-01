
//
//  PhotoView.swift
//  Filterer
//
//  Created by Daniel Alejandro Carriola on 01.06.17.
//  Copyright © 2017 Daniel Alejandro Carriola. All rights reserved.
//

import UIKit

class PhotoView: UIImageView {
    
    // Class variables
    var lastTouchTime: Date? = nil

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        let currentTime = Date()
        if let previousTime = lastTouchTime {
            if currentTime.timeIntervalSince(previousTime) < 0.5 {
                print("Double Tap!")
                lastTouchTime = nil
            } else {
                lastTouchTime = currentTime
            }
        } else {
            lastTouchTime = currentTime
        }
    }

}
