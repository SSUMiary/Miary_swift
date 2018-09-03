//
//  MapViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 8. 12..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SVProgressHUD

class MapViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var feeds : [FeedItem] = []
    var locationManager = CLLocationManager()
    var getLatitude : Double = 0
    var getLongitude : Double = 0
    var getTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        SVProgressHUD.show() //Dismiss Not Yet
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() == true {
            
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined
            {
                locationManager.requestWhenInUseAuthorization()
            }
            
            locationManager.desiredAccuracy = 1.0
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        else{
            print("Please turn on location services or GPS")
        }
        
    }
    
    //MARK: - CLLocationManger Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpanMake(0.2,0.2)
        //        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: span)
        // let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(getLatitude, getLongitude)
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.496453477070411, 126.95687633939087)
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
        
        
        
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = getTitle
        mapView.addAnnotation(annotation)
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error){
        
        print("Unable to access your current location")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

