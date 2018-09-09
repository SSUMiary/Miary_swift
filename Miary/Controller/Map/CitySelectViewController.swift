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
protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}


class citySelectViewController: UIViewController, UISearchBarDelegate{
    
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    var delegate : SelectCityDelegate?
    var pinLatitude : Double? = nil
    var pinLongitude : Double? = nil
    var pinText : String? = nil


    @IBOutlet weak var mapView: MKMapView!
    
    var pinpoint = MKPointAnnotation()
    
    @IBAction func SaveButtonPressed(_ sender: Any) {


        print("pinLatitude: \(pinLatitude)")
        print("pinLongitude: \(pinLongitude)")


        let cityName = pinText
        print("City: \(cityName)")
        
        
        delegate?.userEnteredCityName(city: pinText!, latitude: pinLatitude!, longitude: pinLongitude!)
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
       
                        let annotations = self.mapView.annotations
                        self.mapView.removeAnnotations(annotations)
        
                            let annotation = MKPointAnnotation()
                        self.mapView.addAnnotation(annotation)
       
        
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
       
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}



extension citySelectViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension citySelectViewController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name

        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }

        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
      
        let dic = placemark.addressDictionary
        let latitude = placemark.coordinate.latitude
        let longitude = placemark.coordinate.longitude
        
        print(dic!["Name"] as! String)
        print(latitude)
        print(longitude)
        
        pinText = dic!["Name"] as! String
        pinLatitude = latitude
        pinLongitude = longitude
        
        print(pinText)
        print(pinLatitude)
        print(pinLongitude)
    }
    

}
