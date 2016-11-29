//
//  Destination.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/18/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation
import MapKit

class Destination {
    private(set) var name: String
    private(set) var lat: Double
    private(set) var long: Double
    
    /* CONSTRUCTORS */
    
    init () {
        self.name = ""
        self.lat = 0.0
        self.long = 0.0
    }
    
    init (name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
    
    init (mapItem: MKMapItem) {
        self.lat = mapItem.placemark.coordinate.latitude
        self.long = mapItem.placemark.coordinate.longitude
        self.name = mapItem.name!
    }
    
    init (destToCopy: Destination) {
        self.name = destToCopy.name
        self.lat = destToCopy.lat
        self.long = destToCopy.long
    }
    
    /* METHODS */
    
    func copy() -> Destination {
        return Destination(destToCopy: self)
    }
    
    func toMKMapItem () -> MKMapItem {
        let point = MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.lat, self.long), addressDictionary: nil)
        let mapItem = MKMapItem(placemark: point)
        mapItem.name = self.name
        return mapItem
    }
    
    /* SERIALIZATION */
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "name": self.name,
            "lat": self.lat,
            "long": self.long
        ]
        return dict
    }
    
    func fromDictionary (dict: NSDictionary) {
        self.name = dict.value(forKey: "name") as! String
        self.lat = dict.value(forKey: "lat") as! Double
        self.long = dict.value(forKey: "long") as! Double
    }


}
