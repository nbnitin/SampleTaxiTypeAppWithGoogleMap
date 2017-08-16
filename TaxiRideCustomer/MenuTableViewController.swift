//
//  MenuTableViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 04/08/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    var overlayView: UIView = UIView()
    private let DimmingViewTag = 10001

    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
        imgProfile.layer.borderWidth = 0.5
        imgProfile.layer.borderColor = UIColor.gray.cgColor
        imgProfile.layer.masksToBounds = true
        imgProfile.clipsToBounds = true
       
//        overlayView = UIView(frame: self.view.frame)
//        overlayView.backgroundColor = UIColor.black
//        overlayView.alpha = 0.5
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //overlayView.isUserInteractionEnabled = true
//        let closeGesture = UITapGestureRecognizer(target: self.revealViewController(), action: #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void))
//        
//        self.revealViewController().delegate = self
        

        
        
    }
    
//    public func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
//        
//        if case .right = position {
//            
//            let dimmingView = UIView(frame: view.frame)
//            dimmingView.tag = DimmingViewTag
//            
//            view.addSubview(dimmingView)
//            view.bringSubview(toFront: dimmingView)
//            
//        } else {
//            view.viewWithTag(DimmingViewTag)?.removeFromSuperview()
//        }
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        //super.viewDidAppear(animated)
//        
//        self.revealViewController().frontViewController.view.addSubview(overlayView)
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//      //  super.viewDidDisappear(animated)
//        
//        overlayView.removeFromSuperview()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "profileSegue"){
            let nvc : UINavigationController = segue.destination as! UINavigationController
            let _ = nvc.childViewControllers.first as! ProfileViewController
           // vc.title = "hey"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section != 0){
            return 1.0
        }
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 1.0))
        view.backgroundColor = UIColor.black
        
        if (section != 0){
            return view
        }
        
        return nil
    }
    
    func revealControllerPanGestureBegan(_ revealController: SWRevealViewController!) {
        self.overlayView.removeFromSuperview()
    }
    
    
    
    
    
//    func revealControllerPanGestureEnded(_ revealController: SWRevealViewController!) {
//        self.revealViewController().revealToggle(animated: true)
//        
//       // overlayView.removeFromSuperview()
//
//    }
    
//    var alpha = 0.5
//    
//        func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
//            if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
//                
//    
//                let translation = gestureRecognizer.translation(in: self.revealViewController().frontViewController.view)
//                print(translation.x)
//
//                // note: 'view' is optional and need to be unwrapped
//                var proportion: CGFloat = translation.x / self.view.bounds.size.width
//                var alphaDifference: CGFloat = proportion * (1 - self.view.bounds.size.width)
//                overlayView.alpha = 1 - alphaDifference
//            }
//        }
//        
    
}
