//
//  ViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 11/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgCar: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var constraintBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        imgCar.center.x -= self.view.frame.width
        imgBackground.center.x += self.view.frame.width
        constraintBottom.constant -= 72
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.5, animations: {
            self.imgCar.center.x += self.view.frame.width
            self.imgBackground.center.x -= self.view.frame.width
        },completion:{ finished in
            UIView.animate(withDuration: 2.0, animations: {
                self.constraintBottom.constant += 72
            })
        })
        
    }

}

