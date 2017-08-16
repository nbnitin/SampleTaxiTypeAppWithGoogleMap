//
//  DimLayerSwRevealView.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 08/08/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import Foundation
private let DimmingViewTag = 10001

extension UIViewController: SWRevealViewControllerDelegate {
    
    func setupMenuGestureRecognizer() {
        
        revealViewController().delegate = self
        
        view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        view.addGestureRecognizer(revealViewController().tapGestureRecognizer())
    }
    
    public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if case .right = position {
            
            let dimmingView = UIView(frame: view.frame)
            dimmingView.tag = DimmingViewTag
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            view.addSubview(dimmingView)
            view.bringSubview(toFront: dimmingView)
            dimmingView.addGestureRecognizer(revealViewController().panGestureRecognizer())
            dimmingView.addGestureRecognizer(revealViewController().tapGestureRecognizer())
            
        } else {
            view.viewWithTag(DimmingViewTag)?.removeFromSuperview()
        }
    }
    
    //MARK: - SWRevealViewControllerDelegate
    
    //    public func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
    //         if case .right = position {
    //
    //            let dimmingView = UIView(frame: view.frame)
    //            dimmingView.tag = DimmingViewTag
    //            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    //            view.addSubview(dimmingView)
    //            view.bringSubview(toFront: dimmingView)
    //           dimmingView.addGestureRecognizer(revealViewController().panGestureRecognizer())
    //            dimmingView.addGestureRecognizer(revealViewController().tapGestureRecognizer())
    //
    //        } else {
    //            view.viewWithTag(DimmingViewTag)?.removeFromSuperview()
    //        }
    //    }
    
    
}
