//
//  MapViewInFeedViewController.swift
//  Miary
//
//  Created by Euijoon Jung on 2018. 9. 9..
//  Copyright © 2018년 Euijoon Jung. All rights reserved.
//

import UIKit
import MapKit

class MapViewInFeedViewController: UIViewController {

    @IBOutlet var mapView : MKMapView!
    var feedItem : FeedItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        showPin()
        // Do any additional setup after loading the view.
    }
    func showPin(){
        if let title : String = feedItem.city {
            self.title = title
        }
        let span = MKCoordinateSpanMake(0.01,0.01)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(feedItem.latitude)!, longitude: Double(feedItem.longitude)!)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = location
        annotation.title = feedItem.city
        
        mapView.addAnnotation(annotation)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
