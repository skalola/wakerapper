//
//  LocationViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 10/19/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var transportationType: UISegmentedControl!
    
    var annotation: MKAnnotation!
    var localSearchRequest: MKLocalSearchRequest!
    var localSearch: MKLocalSearch!
    var localSearchResponse: MKLocalSearchResponse!
    var error: NSError!
    var pointAnnotation: MKPointAnnotation!
    var pinAnnotationView: MKPinAnnotationView!
    
    let locationManager = CLLocationManager()
    var etaMinutes: Double = 0.0
    var destination: MKMapItem?
    var isValidDest: Bool = false
    
    
    // TODO: CHECK FOR VALID DESTINATION!!!
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler({
            (localSearchResponse, error) -> Void in
            if localSearchResponse == nil {
                searchBar.text = ""
                let alertController = UIAlertController(title: nil, message: "Address not found", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            
            self.isValidDest = true
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude: localSearchResponse!.boundingRegion.center.longitude)
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.pointAnnotation.coordinate,
                regionRadius * 2.0, regionRadius * 2.0)
            self.mapView.setRegion(coordinateRegion, animated: true)
            
            searchBar.text = localSearchResponse?.mapItems.first?.name
            let directionsRequest = MKDirectionsRequest()
            directionsRequest.source = MKMapItem.mapItemForCurrentLocation()
            self.destination = localSearchResponse?.mapItems.first
            directionsRequest.destination = self.destination
            directionsRequest.requestsAlternateRoutes = false
            
            // Determine which transportation method to use in ETA
            if (self.transportationType.selectedSegmentIndex == 0) {
                directionsRequest.transportType = .Automobile
            } else {
                directionsRequest.transportType = .Transit
            }
            
            let direction = MKDirections(request: directionsRequest)
            direction.calculateETAWithCompletionHandler({
                (response, err) -> Void in
                if response == nil {
                    let alertController = UIAlertController(title: nil, message: "No routes found.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    self.etaMinutes = 0.0
                    return
                }
                self.etaMinutes = (response?.expectedTravelTime)! / 60.0
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        UIBarButtonItem.appearance().tintColor = UIColor.magentaColor()
    }
}
