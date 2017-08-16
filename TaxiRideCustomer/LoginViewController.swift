//
//  LoginViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 14/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var loginContainer: UIView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    var lblUserName_OldPosition : CGFloat = 0.0
    var lblPassword_OldPosition : CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserName.delegate = self
        txtPassword.delegate = self
    }
   
    //Mark: Set views and text fields
    override func viewDidLayoutSubviews() {
        loginContainer.addBorderAroundWithRadius(corners: .allCorners,borderCol: UIColor(red: 219/255, green: 219/255, blue: 219/255, alpha: 1.0).cgColor,borderWidth: 3.0)
        txtUserName.addBottomBorder()
        txtPassword.addBottomBorder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == txtUserName){
            lblUserName.transform = CGAffineTransform(translationX: 0.0, y: 10.0)
            self.lblUserName.isHidden = false
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            
                            self.lblUserName.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )
        } else if(textField == txtPassword){
            lblPassword.transform = CGAffineTransform(translationX: 0.0, y: 10.0)
            self.lblPassword.isHidden = false
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            
                            self.lblPassword.transform = CGAffineTransform.identity
            },
                           completion: { Void in()  }
            )

        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtUserName {
            if txtUserName.text == ""{
                lblUserName.isHidden = true
            }

        }
        if textField == txtPassword {
            if txtPassword.text == ""{
                lblPassword.isHidden = true
            }
            
        }

        
        
    }

}
