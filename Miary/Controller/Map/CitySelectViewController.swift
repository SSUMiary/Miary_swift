//
//  CitySelectViewController.swift
//  Miary
//
//  Created by 조병관 on 2018. 8. 29..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol SelectCityDelegate {
    func userEnteredCityName(city : String, latitude: Double , longitude: Double)
}

struct CityInfo {
    
}

class citySelectViewController: UIViewController, UISearchBarDelegate{
    
    var delegate : SelectCityDelegate?
    var pinLatitude : Double? = nil
    var pinLongitude : Double? = nil
    var pinText : String? = nil

    
   
    
    @IBAction func SearchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    @IBOutlet weak var mapView: MKMapView!
    
    var pinpoint = MKPointAnnotation()
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil{
                print("ERROR")
            }
            else{
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
             
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.mapView.addAnnotation(annotation)
                
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.02, 0.02)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
                print("latitude: \(latitude)")
                print("longitude: \(longitude)")
                print("text: \(searchBar.text)")
                
                self.pinLatitude = latitude
                self.pinLongitude = longitude
                self.pinText = searchBar.text
                
            }
        }
    }
    @IBAction func SaveButtonPressed(_ sender: Any) {
       
        
        print("pinLatitude: \(pinLatitude)")
        print("pinLongitude: \(pinLongitude)")

        
        let cityName = pinText
        print("City: \(cityName)")
        
        
        delegate?.userEnteredCityName(city: pinText!, latitude: pinLatitude!, longitude: pinLongitude!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


