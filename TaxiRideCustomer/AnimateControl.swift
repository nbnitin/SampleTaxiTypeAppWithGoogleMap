//
//  AnimateControl.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 24/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit
import Foundation

let anim = Anim()

class Anim{
   //Mark: enum for animation keypath
    enum AnimationKeyPath : String{
        case translateX = "position.x"
        case translateY = "position.y"
        case scaleX = "transform.scale.x"
        case scaleY = "transform.scale.y"
        case strokEnd = "strokeEnd"
        case strokStart = "strokeStart"
        case backgroundColor = "backgroundColor"
    }
    //Mark: anim function
    func addAnim(key:AnimationKeyPath,from:CGFloat,to:CGFloat,duration:CFTimeInterval)->CABasicAnimation{
        let anim = CABasicAnimation(keyPath: key.rawValue)
        anim.fromValue = from
        anim.toValue = to
        anim.duration = duration
        return anim
    }
    
    func backgroundColorAnimate(from:CGColor,to:CGColor,duration:CFTimeInterval)->CABasicAnimation{
        let anim = CABasicAnimation(keyPath: AnimationKeyPath.backgroundColor.rawValue)
        anim.fromValue = from
        anim.toValue = to
        anim.duration = duration
        anim.repeatCount = 3
        return anim
    }

}
