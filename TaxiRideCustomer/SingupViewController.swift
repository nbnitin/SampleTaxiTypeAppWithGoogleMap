//
//  SingupViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 17/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class SingupViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet var txtFormField: [UITextField]!
    @IBOutlet var lblFormField: [UILabel]!
    @IBOutlet weak var scroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for lbl in lblFormField{
            lbl.isHidden = true
        }
        
        for txt in txtFormField{
            txt.addBottomBorder()
            txt.delegate = self
        }
        
        scroll.addBorderAroundWithRadius(corners: .allCorners,borderCol: UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).cgColor,borderWidth: 3.0)

    }
    
    override func viewWillLayoutSubviews() {
        self.view.layoutIfNeeded()
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        var index = 0
        
        for txt in txtFormField{
            if ( txt == textField ){
                break
            }
            index = index + 1
        }
        
        let label = lblFormField[index]
        label.transform = CGAffineTransform(translationX: 0.0, y: 10.0)
        label.isHidden = false
        
        UIView.animate(withDuration: 0.4,
                                                  delay: 0,
                                   usingSpringWithDamping: CGFloat(0.20),
                                   initialSpringVelocity: CGFloat(6.0),
                                   options: UIViewAnimationOptions.allowUserInteraction,
                                   animations: {
        
                                    label.transform = CGAffineTransform.identity
                    },
                                   completion: { Void in()  }
                    )
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var index = 0
        
        for txt in txtFormField{
            if ( txt == textField ){
                break
            }
            index = index + 1
        }
        
        if ( txtFormField[index].text == "" ){
            let label = lblFormField[index]
            label.isHidden = true
        }
    }
}
