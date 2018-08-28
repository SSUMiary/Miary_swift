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
    
//    var searchController: UISearchDisplayController!
//    var annotation:MKAnnotation!
//    var localSearchRequest:MKLocalSearchRequest!
//    var localSearch:MKLocalSearch!
//    var localSearchResponse:MKLocalSearchResponse!
//    var error:NSError!
//    var pointAnnotation:MKPointAnnotation!
//    var pinAnnotation:MKPointAnnotation!
//    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        SVProgressHUD.show() //Dismiss Not Yet
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
        
        let span = MKCoordinateSpanMake(0.75,0.75)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude), span: span)
      
        
        self.mapView.setRegion(region, animated: true)
        
        
        
        let annotation = MKPointAnnotation()
        
        
//        annotation.coordinate = location
//        annotation.title = "Test"
//        map.addAnnotaion(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error : Error){
        
        print("Unable to access your current location")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchLocationManager(_ manager: CLLocationManager, didUpdateLocations location : [CLLocation]){
        let location  = location[location.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude]
            
        }
    }
    
    func getLocationInfo(){
        let userId = Auth.auth().currentUser!.uid
        let DBRef = Database.database().reference().child("\(userId)/feed/")
        let STRef = Database.database().reference().child("\(userId)/feed/")
        let rootRef = Database.database().reference()
        
        
        rootRef.observe(.value) { (snapshot) in
            if snapshot.hasChildren() == false{
                SVProgressHUD.dismiss()
            }
            
        }
        
        DBRef.observe(.childAdded){ (snapshot) in
            print("Firebas DB observe!")
            let data = snapshot.value as! Dictionary<String,AnyObject>
           
            var newLocation = FeedItem()
            do{
                newLocation.key = snapshot.key
                let str = data["imageUrl"] as! String
                
                let imageUrl = URL(string: str)
                
                do{
                    let imageData = try Data(contentsOf: imageUrl!)
                    newLocation.image = UIImage(data: imageData)!
                }catch {
                    
                
                }
                
                newLocation.title = data["title"] as! String
                newLocation.date = data["data"] as! String
                newLocation.count = data["count"] as! String
                newLocation.firstMusicTitle = data["firstMusicTitle"] as! String
                self.feeds.append(newLocation)
                
               
                SVProgressHUD.dismiss()
            }
            catch{
                SVProgressHUD.dismiss()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
   

}

