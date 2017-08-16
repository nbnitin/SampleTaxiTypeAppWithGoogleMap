//
//  FinalizeBookingViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 27/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class FinalizeBookingViewController: UIViewController,getGooglePlacesDataDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var btnGetTotalFare: UIButton!
    @IBOutlet weak var viewMap: GMSMapView!
    var bounds = GMSCoordinateBounds()
    @IBOutlet weak var bottomPaymentOption: UIView!
    
    @IBOutlet weak var lblPickUpAddress: UILabel!
    @IBOutlet weak var lblDropAddress: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var dotView: [UIView]!
    @IBOutlet weak var dotContainer: UIView!
    @IBOutlet weak var dropAddressContainerView: UIView!
    
    @IBOutlet weak var bottomFairViewContainer: UIView!
    
    var pickUpCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D()
    var dropCoordinate : CLLocationCoordinate2D? = CLLocationCoordinate2D()
    var pickUpAddress = ""
    var dropAddress = ""
    var headtitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        addMarker(lat: pickUpCoordinate.latitude, lng: pickUpCoordinate.longitude, title: "Pick up from", icon: "dropPin")
        lblPickUpAddress.text = pickUpAddress
        lblTitle.text = headtitle
        
        if(dropCoordinate != nil){
            addMarker(lat: (dropCoordinate?.latitude)!, lng: (dropCoordinate?.longitude)!, title: "Drop at", icon: "pickUpPIn")
            lblDropAddress.text = dropAddress
            getPolylineRoute(source: pickUpCoordinate, destination: dropCoordinate!)
        } else {
            lblWarning.isHidden = false
        }

        viewMap.settings.zoomGestures = true
        self.view.backgroundColor = UIColor.white
        
        // Set Navigation bar background Image
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(),for: .default)
        
        
       
        
        dotView[0].drawCircleAtCenter(radius: 2.5, fillColor: UIColor.green.cgColor, strokeColor: UIColor.green.cgColor)
        dotView[1].drawCircleAtCenter(radius: 2.5, fillColor: UIColor.clear.cgColor, strokeColor: UIColor.red.cgColor)
        
        dropAddressContainerView.addBorderAroundWithRadius(corners: .allCorners,borderCol: UIColor.black.cgColor,borderWidth:0.5,cornerRadius:5.0)
        
        bottomFairViewContainer.addBottomBorder()
        let startPoint = CGPoint(x: self.view.frame.width/2 , y: 0  )
        let endPonint = CGPoint(x: self.view.frame.width/2, y: bottomPaymentOption.frame.height)
        bottomPaymentOption.layer.addSublayer(getStraightLineLayer(startPoint: startPoint, endPoint: endPonint, strokeColor: UIColor.black, fillColor: UIColor.clear, width: 1.0))
        
        
        
        btnGetTotalFare.addTarget(self, action: #selector(getPolylineRoute), for: .touchUpInside)
        lblDropAddress.isUserInteractionEnabled = true
        let goToGooglePlacesGesture = UITapGestureRecognizer(target: self, action: #selector(getDropAddresse))
        lblDropAddress.addGestureRecognizer(goToGooglePlacesGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
       
    override func viewDidAppear(_ animated: Bool) {
        let startPoint = CGPoint(x: dotContainer.frame.width/2 + 0.4, y: (dotView[0].frame.origin.y + dotView[1].frame.height)+0.9  )
        let endPonint = CGPoint(x: dotContainer.frame.width/2, y: dotView[1].frame.origin.y)
        self.dotContainer.layer.addSublayer( getDottedLineLayer(startPoint: startPoint, endPoint: endPonint, strokeColor: UIColor.black, fillColor: UIColor.clear, dashedPattern: [2,3]) )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: add marker to map
    func addMarker(lat:Double,lng:Double,title:String,icon:String){
      
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        marker.position = location
        marker.title = title
        marker.icon = UIImage(named: icon)
        marker.map = viewMap
        
        bounds = bounds.includingCoordinate(marker.position)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        viewMap.animate(with: update)

    
        
   }

    func getPolylineRoute(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [Any]
                        let route = routes?[0] as?[String:Any]
                        let legs = route?["legs"] as! [Any]
                        
                        let final_legs = legs[0] as? [String:Any]
                        let distance = final_legs?["distance"] as? [String:Any]
                        let duration = final_legs?["duration"] as? [String:Any]
                        
                        DispatchQueue.main.async {
                            self.calculateFair(distance: distance?["value"] as! Int32,duration: duration?["value"] as! Int32)
                        }
                        
                        let overview_polyline = route?["overview_polyline"] as? [String:Any]
                        let points = overview_polyline?["points"] as! String
                        
                        //Call this method to draw path on map
                        DispatchQueue.main.async {
                            self.showPath(polyStr: points)
                        }
                    }
                    
                }catch{
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func showPath(polyStr :String){
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 3.0
        polyline.map = viewMap // Your map view
    }
    
    func calculateFair(distance:Int32,duration:Int32){
        print(distance)
        
        let km = Int(distance / 1000)
        let timeTaken = Int(duration / 60)
        let countTime = timeTaken/30
        let price = (km * 20) + (20 * countTime)
        btnGetTotalFare.setTitle("Total Fare is \(price)", for: .normal)
    }
    
    //Mark: returns dotted line
    func getDottedLineLayer(startPoint:CGPoint,endPoint:CGPoint,strokeColor:UIColor,fillColor:UIColor,
                            dashedPattern:[NSNumber])->CAShapeLayer{
        
        let  border = CAShapeLayer();
        border.name = "DashedBorder"
        border.strokeColor = UIColor.red.cgColor
        border.fillColor = nil;
        border.lineDashPattern = dashedPattern
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        border.path = path.cgPath
        return border
    }
    
    //Mark: returns straight line
    func getStraightLineLayer(startPoint:CGPoint,endPoint:CGPoint,strokeColor:UIColor,fillColor:UIColor,width:CGFloat)->CAShapeLayer{
        
        let  border = CAShapeLayer();
        border.name = "Border"
        border.strokeColor = strokeColor.cgColor
        border.fillColor = fillColor.cgColor
        border.lineWidth = width
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        border.path = path.cgPath
        
        return border
    }

    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //Mark: get google places VC in action to get drop place
    func getDropAddresse(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "googlePlaces") as! CustomGooglePlacesViewController
        vc.delegate = self
        vc.isDrop = true
        vc.navigationItem.title = "Set drop address"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark: get drop addresse and set marker also
    func getDropData(address: String, lat: Double, lng: Double) {
        lblDropAddress.text = address
        dropCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        viewMap.clear()
        addMarker(lat: lat, lng: lng, title: "Drop Point", icon: "pickUpPIn")
        addMarker(lat: pickUpCoordinate.latitude, lng: pickUpCoordinate.longitude, title: "Pick up Point", icon: "dropPin")
        getPolylineRoute(source: pickUpCoordinate, destination: dropCoordinate!)

    }
    
    func getPickUpData(address: String, lat: Double, lng: Double) {
        //your code if want pick up data
    }

}
