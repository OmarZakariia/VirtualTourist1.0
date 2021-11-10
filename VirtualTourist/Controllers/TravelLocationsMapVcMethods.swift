//
//  TravelLocationsMapVcMethods.swift
//  VirtualTourist
//
//  Created by Zakaria on 09/11/2021.
//

import Foundation
import MapKit
import CoreData
import UIKit

extension TravelLocationsMapVC: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        let coordinateSelected = view.annotation?.coordinate
        let latitude = coordinateSelected?.latitude
        let longitude = coordinateSelected?.longitude
        
        if !editMode {
            for pin in pin {
                if pin.latitude == latitude && pin.longitude ==  longitude {
                    self.pinToPass = pin
                    self.pinCoordinate = coordinateSelected
                }
            }
            performSegue(withIdentifier: "PinPhotos", sender: coordinateSelected)
            mapView.deselectAnnotation(view.annotation, animated: false)
        } else {
            for pin in pin{
                if pin.latitude == latitude && pin.longitude == longitude {
                    let pinToDelete = pin
                    dataController.viewContext.delete(pinToDelete)
                    try? dataController.viewContext.save()
                }
            }
            mapView.removeAnnotation(view.annotation!)
        }
    }
}
