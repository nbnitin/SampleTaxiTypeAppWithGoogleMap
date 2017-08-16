//
//  SplashViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 17/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController,CAAnimationDelegate {

    @IBOutlet weak var imgMarker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let origin:CGPoint = imgMarker.center
        let target:CGPoint = CGPoint(x:imgMarker.center.x, y:imgMarker.center.y+20)
        let bounce = CABasicAnimation(keyPath: "position.y")
        bounce.duration = 1.0
        bounce.fromValue = origin.y
        bounce.toValue = target.y
        bounce.repeatCount = 4
        bounce.autoreverses = true
        bounce.delegate = self
        imgMarker.layer.add(bounce, forKey: "position")
       
       // Do any additional setup after loading the view.
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NVBookTaxi")
        self.present(vc!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
