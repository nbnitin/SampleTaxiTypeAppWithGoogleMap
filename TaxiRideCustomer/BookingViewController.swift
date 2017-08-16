//
//  SampleViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 21/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class BookingViewController: UIViewController,GMSMapViewDelegate,getGooglePlacesDataDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var btnMenu: UIBarButtonItem!
   
    @IBOutlet var rideSelectionView: [UIView]!
    @IBOutlet weak var naivgationBarCustom: UIView!
    @IBOutlet var lblAddressTitle: [UILabel]!
    @IBOutlet weak var btnMyLocation: UIButton!
    @IBOutlet var dotView: [UIView]!
    @IBOutlet weak var bottomButtonView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var pickUpView: UIView!
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var lblDropAddress: UILabel!
    @IBOutlet weak var lblPickUpAddress: UILabel!
    var pickUpCoordinates : CLLocationCoordinate2D!
    var dropCoordinates : CLLocationCoordinate2D!
    var isDrop = false
    
    var locationManager: CLLocationManager!
    var lat : Double = Double()
    var lng : Double = Double()
    let geocoder = GMSGeocoder()
    let tags = [1000,2000,3000]
    let rides = ["Micro","Mini","Shuttle"]
    var selectedRide = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        viewMap.delegate = self
        
        //Mark: adding menu slide out functionality
        btnMenu.target = self.revealViewController()
        btnMenu.action = #selector((SWRevealViewController.revealToggle) as (SWRevealViewController) -> (Void) -> Void) // Swift 3 fix
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        
        let pickTap = UITapGestureRecognizer(target: self, action: #selector(showPickUp))
        pickUpView.addGestureRecognizer(pickTap)
        
        let dropTap = UITapGestureRecognizer(target: self, action: #selector(showDrop))
        dropView.addGestureRecognizer(dropTap)
        
        //Mark: map setting
        viewMap.settings.myLocationButton = false

        dropView.transform = CGAffineTransform(scaleX: 0.8, y: 1.0)
        lblDropAddress.transform = CGAffineTransform(scaleX: 0.6, y: 1.0)
        dropView.backgroundColor = UIColor.white
        dropView.alpha = 0.5
        lblDropAddress.transform = CGAffineTransform(translationX: 14.0, y: 10.0)
        dotView[0].transform = CGAffineTransform(translationX: 0.0, y: 30.0)
        self.lblAddressTitle[1].isHidden = true
        lblDropAddress.text = "Where to"
        lblDropAddress.font = UIFont.boldSystemFont(ofSize: 11.0)
        lblDropAddress.textColor = UIColor.gray
        lblDropAddress.alpha = 0.9
        lblDropAddress.isUserInteractionEnabled = false
  
        //Mark: Adds padding to google map to bring google controls and google logo towards upside
        let mapInsets = UIEdgeInsets(top: bottomViewHeight.constant, left: 0.0, bottom: bottomViewHeight.constant, right: 0.0)
        viewMap.padding = mapInsets
    
        //Marke: Add straight line between button in bottom button view
        //let _ = self.bottomButtonView.layer.sublayers?.filter({$0.name == "Border"}).map({$0.removeFromSuperlayer()})
        
        let start1 = CGPoint(x: self.view.frame.width/2, y: 0)
        let end1 = CGPoint(x: self.view.frame.width/2, y: self.bottomView.frame.height)
        
        bottomButtonView.layer.addSublayer(getStraightLineLayer(startPoint: start1, endPoint: end1, strokeColor: UIColor.white, fillColor:UIColor.clear, width: 1.0))
        
        
        //Mark: adds tap gesture to label to get google places in working
        
        //Mark: add gesture to pickup label
        let pickUpTap = UITapGestureRecognizer(target: self, action: #selector(getPickUpAddresse))
        lblPickUpAddress.isUserInteractionEnabled = true
        lblPickUpAddress.addGestureRecognizer(pickUpTap)
        
        //Mark: add gesture to drop label
        let dropTapLbl = UITapGestureRecognizer(target: self, action: #selector(getDropAddresse))
        lblDropAddress.addGestureRecognizer(dropTapLbl)
        
        //Mark: call get my location function
        getCurrentLocation()
        
        dotView[0].drawCircleAtCenter(radius:2.5, fillColor: UIColor.clear.cgColor, strokeColor: UIColor.red.cgColor)
        
       dotView[1].drawCircleAtCenter(radius:2.5, fillColor: UIColor.init(red: 84/255, green: 166/255, blue: 36/255, alpha: 1.0).cgColor, strokeColor: UIColor.clear.cgColor)
        
        //Mark: setting gesture to my custom location button
        btnMyLocation.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
       
        img.frame.origin.y = (self.view.frame.height / 2 ) - (img.frame.height)
        img.frame.origin.x = img.frame.origin.x + 1
        
        let logo = UIImage(named: "ola_logo_white")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        setRideSelectionView()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController!.navigationBar.setBackgroundImage(nil,for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        setupMenuGestureRecognizer()

        //Mark: Add animation to marker image
        let animate = anim.addAnim(key: .translateY, from: pickUpView.frame.height, to: img.layer.position.y, duration: 0.4)
        img.layer.add(animate, forKey: animate.keyPath)
        
        
//        let balloon = UIView(frame: pickUpView.frame)
//        balloon.backgroundColor = UIColor.clear
//        
//        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: pickUpView.frame.width, y: 0))
//        path.addLine(to: CGPoint(x: pickUpView.frame.width, y: pickUpView.frame.height))
//       //Arrow
//        path.addLine(to: CGPoint(x:pickUpView.frame.width / 2 + 10,y:pickUpView.frame.height))
//        path.addLine(to: CGPoint(x:pickUpView.frame.width / 2,y:pickUpView.frame.height + 5))
//        path.addLine(to: CGPoint(x:pickUpView.frame.width / 2 - 10,y:pickUpView.frame.height))
//        path.addLine(to: CGPoint(x:0,y:pickUpView.frame.height))
//
//
//            path.close()
//        
//        let shape = CAShapeLayer()
//        //shape.backgroundColor = UIColor.blue.cgColor
//        shape.fillColor = UIColor.clear.cgColor
//        shape.strokeColor = UIColor.black.cgColor
//        shape.path = path.cgPath
//        shape.allowsEdgeAntialiasing = true
//        pickUpView.layer.insertSublayer(shape, at: 0)
//        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   //Mark: get google places VC in action to get pickup place
    func getPickUpAddresse(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "googlePlaces") as! CustomGooglePlacesViewController
        vc.delegate = self
        vc.isDrop = false
        vc.navigationItem.title = "Set pick up address"
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Mark: get google places VC in action to get drop place
    func getDropAddresse(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "googlePlaces") as! CustomGooglePlacesViewController
        vc.delegate = self
        vc.isDrop = true
        vc.navigationItem.title = "Set drop address"
        self.navigationItem.title = ""
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        bottomView.isHidden = true
        btnMyLocation.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let mapInsets = UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 0.0)
        viewMap.padding = mapInsets
        
        //Mark: remove dashed border
        let _ = self.viewMap.layer.sublayers?.filter({$0.name == "DashedBorder"}).map({$0.isHidden=true})
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        if(isDrop){
            pickUpView.isHidden = true
           // showDrop()
            lblDropAddress.text = "Getting address..."
        } else{
            dropView.isHidden = true
           // showPickUp()
            lblPickUpAddress.text = "Getting address..."
        }
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
        btnMyLocation.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
        let mapInsets = UIEdgeInsets(top: bottomViewHeight.constant, left: 0.0, bottom: bottomViewHeight.constant, right: 0.0)
        viewMap.padding = mapInsets
        addMarker(lat: cameraPosition.target.latitude, lng: cameraPosition.target.longitude, title: "", icon: "dropPin")
        pickUpView.isHidden = false
        dropView.isHidden = false
        bottomView.isHidden = false
        //img.frame.origin.y = ((self.view.frame.height / 2 ) - (img.frame.height))-20
        
        //Mark: adds dashed border
        if(isDrop){
            
            dropCoordinates = cameraPosition.target
            
            if(dropCoordinates != nil){
//                let start = CGPoint(x: self.viewMap.frame.width/2, y: (self.dropView.frame.height + self.pickUpView.frame.origin.y))
//                let end = CGPoint(x: self.viewMap.frame.width/2, y: self.viewMap.frame.height/2)
//                let dottedBorder = getDottedLineLayer(startPoint: start, endPoint: end, strokeColor: UIColor.red, fillColor: UIColor.clear, dashedPattern: [2,3])
//                let animate = anim.addAnim(key: .strokEnd, from: 0.0, to: 1.0, duration: 0.4)
//                dottedBorder.add(animate, forKey: animate.keyPath)
//                self.viewMap.layer.addSublayer(dottedBorder)
                let _ = self.viewMap.layer.sublayers?.filter({$0.name == "DashedBorder"}).map({$0.isHidden=false})

            }
        } else{
            let start = CGPoint(x: self.viewMap.frame.width/2, y: (self.pickUpView.frame.height + self.pickUpView.frame.origin.y))
            let end = CGPoint(x: self.viewMap.frame.width/2, y: self.img.frame.origin.y)
            let dottedBorder = getDottedLineLayer(startPoint: start, endPoint: end, strokeColor: UIColor.red, fillColor: UIColor.clear, dashedPattern: [2,3])
            let animate = anim.addAnim(key: .strokEnd, from: 0.0, to: 1.0, duration: 0.4)
            dottedBorder.add(animate, forKey: animate.keyPath)
            self.viewMap.layer.addSublayer(dottedBorder)
        }
        
        //Mark:- This below code helps to take marker to its old position  when someone stop moving  google map/camera or release mouse
       // img.frame.origin.y = (self.view.frame.height / 2 ) - (img.frame.height)
        returnPostionOfMapView(mapView: mapView)
        print("i m image idle camera \(img.frame.origin.y)")

    }
    
   //Mark: shows pickup view
    func showPickUp(){
        
        isDrop = false
        viewMap.delegate = nil
        
        
        if(pickUpCoordinates != nil){
            self.viewMap.animate(toLocation: pickUpCoordinates)
        }

            UIView.animate(withDuration: 0.3, animations: { () in
                self.view.bringSubview(toFront: self.pickUpView)
                //Mark: hides drop view and configure it
                self.dropView.transform = CGAffineTransform(scaleX: 0.8, y: 1.0)
                self.lblDropAddress.transform = CGAffineTransform(scaleX: 0.6, y: 1.0)
                self.dropView.backgroundColor = UIColor.white
                self.dropView.alpha = 0.5
                self.lblDropAddress.transform = CGAffineTransform(translationX: 14.0, y: 10.0)
                self.dotView[0].transform = CGAffineTransform(translationX: 0.0, y: 30.0)

                //self.lblDropAddress.text = "Where to"
                self.lblDropAddress.font = UIFont.boldSystemFont(ofSize: 11.0)
                self.lblDropAddress.textColor = UIColor.gray
                self.lblDropAddress.alpha = 0.9
                self.lblDropAddress.isUserInteractionEnabled = false
                self.lblAddressTitle[1].isHidden = true
                
                //Mark: shows pickup view and configure it
                self.pickUpView.transform = CGAffineTransform.identity
                self.lblPickUpAddress.transform = CGAffineTransform.identity
                self.pickUpView.backgroundColor = UIColor.white
                self.pickUpView.alpha = 1.0
                self.lblPickUpAddress.transform = CGAffineTransform.identity
                //self.lblPickUp.text = "Where to"
                self.lblPickUpAddress.font = UIFont.boldSystemFont(ofSize: 15.0)
                self.lblPickUpAddress.textColor = UIColor.black
                self.lblPickUpAddress.alpha = 1.0
                self.lblPickUpAddress.isUserInteractionEnabled = true
                self.lblAddressTitle[0].isHidden = false
               // self.dotView[1].transform = CGAffineTransform.identity
                
               
            },completion:{(finished) in
                if(self.pickUpCoordinates != nil){
//                    self.img.frame.origin.y = (self.view.frame.height / 2 ) - (self.img.frame.height)
//                    self.img.isHidden = false
//                    
                    let _ = self.viewMap.layer.sublayers?.filter({$0.name == "DashedBorder"}).map({$0.removeFromSuperlayer()})
                    
                    let start = CGPoint(x: self.viewMap.frame.width/2, y: (self.pickUpView.frame.height + self.pickUpView.frame.origin.y))
                    let end = CGPoint(x: self.viewMap.frame.width/2, y: self.viewMap.frame.height/2)
                    let dottedBorder = self.getDottedLineLayer(startPoint: start, endPoint: end, strokeColor: UIColor.red, fillColor: UIColor.clear, dashedPattern: [2,3])
                    let animate = anim.addAnim(key: .strokEnd, from: 0.0, to: 1.0, duration: 0.4)
                    dottedBorder.add(animate, forKey: animate.keyPath)
                    self.viewMap.layer.addSublayer(dottedBorder)
                    
                    self.viewMap.animate(toLocation: self.pickUpCoordinates)
                }
                self.viewMap.delegate = self
            })
    }
    
    //Mark: shows drop view
    func showDrop(){
        
        isDrop = true
        
        self.viewMap.delegate = nil
         let _ = self.viewMap.layer.sublayers?.filter({$0.name == "DashedBorder"}).map({$0.removeFromSuperlayer()})
        
        if(dropCoordinates != nil){
            self.viewMap.animate(toLocation: dropCoordinates)
        }

        UIView.animate(withDuration:0.3, animations: { () in
            self.view.bringSubview(toFront: self.dropView)

            //Mark: shows drop view and configures it
            self.dropView.transform = CGAffineTransform.identity
            self.lblDropAddress.transform = CGAffineTransform.identity
            self.dropView.backgroundColor = UIColor.white
            self.dropView.alpha = 1.0
            self.lblDropAddress.transform = CGAffineTransform.identity
            //self.lblDropAddress.text = "Where to"
            self.lblDropAddress.font = UIFont.boldSystemFont(ofSize: 15.0)
            self.lblDropAddress.textColor = UIColor.black
            self.lblDropAddress.alpha = 1.0
            self.lblDropAddress.isUserInteractionEnabled = true
            self.dotView[0].transform = CGAffineTransform.identity
            self.lblAddressTitle[1].isHidden = false

            //Mark: hides pick up view and configures it
            self.pickUpView.transform = CGAffineTransform(scaleX: 0.8, y: 1.0)
            self.pickUpView.backgroundColor = UIColor.white
            self.pickUpView.alpha = 0.5
            self.lblPickUpAddress.transform = CGAffineTransform(translationX: 10.0, y: -20.0)
            self.lblAddressTitle[0].isHidden = true
            //self.lblPickUp.text = "Where to"
          //  self.lblPickUpAddress.font = UIFont.boldSystemFont(ofSize: 11.0)
            self.lblPickUpAddress.textColor = UIColor.gray
            self.lblPickUpAddress.alpha = 0.9
            self.lblPickUpAddress.isUserInteractionEnabled = false
            
            
            
        },completion:{(finished)in
            if(self.dropCoordinates != nil){
//                self.img.frame.origin.y = (self.view.frame.height / 2 ) - (self.img.frame.height)
//                self.img.isHidden = false
                
               
                
                let start = CGPoint(x: self.viewMap.frame.width/2, y: (self.dropView.frame.height + self.dropView.frame.origin.y))
                let end = CGPoint(x: self.viewMap.frame.width/2, y: self.viewMap.frame.height/2)
                let dottedBorder = self.getDottedLineLayer(startPoint: start, endPoint: end, strokeColor: UIColor.red, fillColor: UIColor.clear, dashedPattern: [2,3])
                let animate = anim.addAnim(key: .strokEnd, from: 0.0, to: 1.0, duration: 0.4)
                dottedBorder.add(animate, forKey: animate.keyPath)
                self.viewMap.layer.addSublayer(dottedBorder)
                self.viewMap.animate(toLocation: self.dropCoordinates)
            }
                self.viewMap.delegate = self
        })
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
    
    //Mark:google places delegate functions
    
    //Mark: get pick up addresse and set marker also
    func getPickUpData(address: String, lat: Double, lng: Double) {
        lblPickUpAddress.text = address
        pickUpCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        addMarker(lat: lat, lng: lng, title: "Pick Up Point", icon: "pickUpPIn")
    }

    //Mark: get drop addresse and set marker also
    func getDropData(address: String, lat: Double, lng: Double) {
        lblDropAddress.text = address
        dropCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        addMarker(lat: lat, lng: lng, title: "Drop Point", icon: "dropPin")
    }
    
   //Mark: add marker to map
    func addMarker(lat:Double,lng:Double,title:String,icon:String){
        
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lng))
        marker.position = location
        marker.title = title
        marker.icon = UIImage(named: icon)
        marker.map = viewMap
        
        let camera = GMSCameraPosition.camera(withTarget: location, zoom: 18.0)
        viewMap.camera = camera
        
        //  imgCenterMarker.isHidden = true
    }
    
    //Mark: location manager delegate methods
    //Convert the location position to address
    func returnPostionOfMapView(mapView:GMSMapView){
        let geocoder = GMSGeocoder()
        let latitute = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position = CLLocationCoordinate2DMake(latitute, longitude)
        geocoder.reverseGeocodeCoordinate(position) { response , error in
            
            if error != nil {
                print("GMSReverseGeocode Error: \(String(describing: error?.localizedDescription))")
            } else {
                let result = response?.results()?.first
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                
                if(!self.isDrop){
                    self.lblPickUpAddress.text = address
                } else {
                    self.lblDropAddress.text = address
                }
                //self.img.frame.origin.y = (self.view.frame.height / 2 ) - (self.img.frame.height)
                self.addMarker(lat: latitute, lng: longitude, title: "", icon: "dropPin")
                print("i m image get adresse \(self.img.frame.origin.y)")

            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLoction: CLLocation = locations[0]
        let latitude = userLoction.coordinate.latitude
        let longitude = userLoction.coordinate.longitude
        locationManager.stopUpdatingLocation()
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 16.0)
        viewMap.camera = camera
        viewMap.animate(to: camera)
        viewMap.isMyLocationEnabled = true
        self.pickUpCoordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        returnPostionOfMapView(mapView: viewMap)
     }
    
    func getCurrentLocation(){
        //Mark: get current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    
//    @IBAction func btnRideNow(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "finalizeBook") as! FinalizeBookingViewController
//        vc.pickUpCoordinate = self.pickUpCoordinates
//        vc.dropCoordinate = self.dropCoordinates == nil ? nil : self.dropCoordinates
//        vc.pickUpAddress = self.lblPickUpAddress.text!
//        vc.dropAddress = self.lblDropAddress.text!
//        vc.headtitle = "Micro, 1 min away"
//        self.navigationController?.present(vc, animated: false, completion: nil)
//
//    }
    
    //send value with segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "getBill"){
            let vc = segue.destination as! FinalizeBookingViewController
            vc.pickUpCoordinate = self.pickUpCoordinates
            vc.dropCoordinate = self.dropCoordinates == nil ? nil : self.dropCoordinates
            vc.pickUpAddress = self.lblPickUpAddress.text!
            vc.dropAddress = self.lblDropAddress.text!
            vc.headtitle = "\(rides[selectedRide]), 1 min away"
        }
    }
    
    func setRideSelectionView(){
        
        for i in rideSelectionView{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(setRideSelectedDeselected(sender:)))
            i.addGestureRecognizer(tapGesture)
            i.isUserInteractionEnabled = true
        }
    }
    
    func setRideSelectedDeselected(sender : UITapGestureRecognizer){
        
        let v = sender.view!
        selectedRide = v.tag - 1
        for i in rideSelectionView{
            if (i == v){
                let imgView = i.viewWithTag(2000) as! UIImageView
                imgView.image = UIImage(named: "rideSelected")
                let lblView = i.viewWithTag(3000) as! UILabel
                lblView.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightBold)
            } else {
                let imgView = i.viewWithTag(2000) as! UIImageView
                imgView.image = UIImage(named: "microCar")
                let lblView = i.viewWithTag(3000) as! UILabel
                lblView.font = UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular)
            }
        }
   }
    
}



