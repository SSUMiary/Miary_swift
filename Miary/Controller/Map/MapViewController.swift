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

class MapViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var feeds : [FeedItem] = []
    var locationManager = CLLocationManager()
    var getLatitude : Double = 0
    var getLongitude : Double = 0
    var getTitle : String = ""
    var setCurrentMap : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        SVProgressHUD.show() //Dismiss Not Yet
        
        prepare()
        getFeeds()
        
    }
    func updateUI(){
        var pinArr : [MKAnnotation] = []
        for i in 0..<feeds.count{
            if feeds[i].city != ""{
                let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.feeds[i].latitude)!, Double(self.feeds[i].longitude)!)
                let newPin = MKPointAnnotation()
                newPin.title = feeds[i].title
                newPin.coordinate = location
                pinArr.append(newPin)
                
            }
        }
        mapView.showAnnotations(pinArr, animated: true)
        locationManager.startUpdatingLocation()
    }
    func getFeeds(){
        
        if feeds.count == 0 {
            DispatchQueue.main.async {
                
                FeedManager.instance.getAllFeedFromServer(completion: { (list) in
                    self.feeds = list
                    self.updateUI()
                })
            }
        }else{
            feeds = FeedManager.instance.getFeeds()
        }
        
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(#function)
        print("pin selected")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyBoard.instantiateViewController(withIdentifier: "feedDetailView") as! UINavigationController
        let nextVC = navVC.topViewController as! FeedDetailViewController
        //let nextVC = storyBoard.instantiateViewController(withIdentifier: "feedDetailView") as! FeedDetailViewController
        for i in 0..<feeds.count {
            if feeds[i].title == view.annotation?.title{
                nextVC.key = feeds[i].key
                nextVC.feedIndex = i

                self.navigationController?.show(nextVC, sender: self)
//                self.present(nextVC, animated: true, completion: nil)
                break
            }
        }
    }
    
    func prepare(){
        mapView.showsUserLocation = true
        mapView.delegate = self
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
            let alertController = UIAlertController(title: "Please turn on location services or GPS", message: "", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            alertController.addAction(alertAction)
            self.present(alertController, animated: true) {
                print("Please turn on location services or GPS")
            }
            
        }
    }
    
    //MARK: - CLLocationManger Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if setCurrentMap {
            
            let span = MKCoordinateSpanMake(0.2,0.2)
            
            let location: CLLocationCoordinate2D = manager.location!.coordinate
            
            let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            self.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            annotation.title = getTitle
            
            mapView.addAnnotation(annotation)
            setCurrentMap = false
        }
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error){
        
        let alertController = UIAlertController(title: "Location permission required", message: "Unable to access your current location", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

