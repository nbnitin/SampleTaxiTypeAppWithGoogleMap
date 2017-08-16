//
//  YourRidesTableViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 08/08/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit

class YourRidesTableViewController: UITableViewController {

    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mark: adding menu slide out functionality
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YourRidesTableViewCell
        cell.imgIcon.image = #imageLiteral(resourceName: "menuCarIcon")
        cell.imgDriver.image = #imageLiteral(resourceName: "driver")
        cell.lblRate.text = indexPath.row % 2 == 0 ? "\u{20B9}306" : ""
        cell.lblDateTime.text = "Thu, Jul 27, 12:46 PM"
        cell.lblRideInfo.text = "Mini, CRN 907341148"
        
        
        cell.imgCancel.isHidden = indexPath.row % 2 == 0 ? true : false
        
        
        cell.imgDriver.layer.cornerRadius = cell.imgDriver.frame.width / 2
        cell.imgDriver.layer.borderWidth = 0.5
        cell.imgDriver.layer.borderColor = UIColor.gray.cgColor
        cell.imgDriver.layer.masksToBounds = true
        cell.imgDriver.clipsToBounds = true
        
        cell.pickUpDot.drawCircleAtCenter(radius: cell.pickUpDot.frame.width/2 , fillColor: UIColor.green.cgColor, strokeColor: UIColor.green.cgColor)
        cell.dropAtDot.drawCircleAtCenter(radius: cell.dropAtDot.frame.width/2, fillColor: UIColor.red.cgColor, strokeColor: UIColor.red.cgColor)
        
        let startPoint = CGPoint(x: cell.pickUpDot.frame.width/2 + cell.pickUpDot.frame.origin.x, y: (cell.pickUpDot.frame.origin.y + cell.pickUpDot.frame.height)+0.9)
        let endPoint = CGPoint(x: cell.dropAtDot.frame.width/2 + cell.dropAtDot.frame.origin.x, y:cell.dropAtDot.frame.origin.y)
        
        cell.layer.addSublayer(getDottedLineLayer(startPoint: startPoint, endPoint: endPoint, strokeColor: UIColor.black, fillColor: UIColor.black, dashedPattern: [2,3]))

        cell.lblDropAtAdd.text = "H.Nizzamuddin,Railway St."
        cell.lblPickUpAdd.text = "Moti Nagar, New Delhi"
        return cell
    }
    
    //Mark: returns dotted line
    func getDottedLineLayer(startPoint:CGPoint,endPoint:CGPoint,strokeColor:UIColor,fillColor:UIColor,
                            dashedPattern:[NSNumber])->CAShapeLayer{
        
        let  border = CAShapeLayer()
        border.name = "DashedBorder"
        border.strokeColor = strokeColor.cgColor
        border.fillColor = fillColor.cgColor
        border.lineDashPattern = dashedPattern
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        border.path = path.cgPath
        return border
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
