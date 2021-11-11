//
//  PinOnMap.swift
//  VirtualTourist
//
//  Created by Zakaria on 07/11/2021.
//

import Foundation
import MapKit



class PinOnMap: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
    
    init(coordinate: CLLocationCoordinate2D) {

        self.coordinate = coordinate
        
        super.init()
    }
    
}
