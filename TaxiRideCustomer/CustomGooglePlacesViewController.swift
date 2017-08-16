//
//  CustomGooglePlacesViewController.swift
//  TaxiRideCustomer
//
//  Created by Umesh Chauhan on 20/07/17.
//  Copyright © 2017 Nitin Bhatia. All rights reserved.
//

import UIKit
import GooglePlaces

protocol getGooglePlacesDataDelegate {
    func getPickUpData(address : String,lat : Double,lng : Double)
    func getDropData(address : String,lat : Double,lng : Double)

}

class CustomGooglePlacesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{

    @IBOutlet weak var tblResult: UITableView!
    @IBOutlet weak var txtSearch: UISearchBar!
    var searchResults = [String]()
    var apiHandler : ApiHandler!
    var delegate : getGooglePlacesDataDelegate!
    var isDrop = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtSearch.delegate = self
        apiHandler = ApiHandler()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchResults.count <= 0){
            tblResult.isHidden = true
        } else {
            tblResult.isHidden = false
        }
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var url = "https://maps.googleapis.com/maps/api/geocode/json?address=\(searchResults[indexPath.row])&sensor=false"
        
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        print(url)
       
        apiHandler.sendGetRequest(url: url, completionHandler:  {(response,error) in
            
            if(error != nil){
                print(error?.localizedDescription)
                return
            }
            
            let temp = (response["results"] as! [AnyObject])
            
            let x = temp[0].value(forKey: "geometry") as! NSDictionary
            
            let lat = (x.value(forKey: "location") as! NSDictionary).value(forKey: "lat") as! Double
            
            let lng = (x.value(forKey: "location") as! NSDictionary).value(forKey: "lng") as! Double
            if(!self.isDrop){
                self.delegate.getPickUpData(address: self.searchResults[indexPath.row], lat: lat, lng: lng)
            } else{
                self.delegate.getDropData(address: self.searchResults[indexPath.row], lat: lat, lng: lng)
            }

            self.navigationController?.popViewController(animated: true)
            
        
    })
    
    
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String){
        
        if(searchText == ""){
            self.searchResults.removeAll()
            self.tblResult.reloadData()
        }
        
        let filter = GMSAutocompleteFilter()
        filter.country = "IN"
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(searchText, bounds: nil, filter: filter) { (results, error) -> Void in
            self.searchResults.removeAll()
            if results == nil {
                return
            }
            for result in results!{
                if let result = result as? GMSAutocompletePrediction{
                    self.searchResults.append(result.attributedFullText.string)
                }
            }
            self.tblResult.reloadData()
        }
    }
}
