//
//  ProfileTableViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 02/08/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet var contianerViews: [UIView]!
    @IBOutlet var txtInputs: [UITextField]!
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenuGestureRecognizer()
        
        
        //Mark: adding menu slide out functionality
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
      
       
        btnLogout.addCornerRadiusWithBorder(borderColor: UIColor.black.cgColor, borderWidth: 2.0, cornerRadius: 3.0)
        txtInputs[0].becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        for i in contianerViews{
            i.addBottomBorder(color: UIColor.black.cgColor)
        }
    }
   
}
