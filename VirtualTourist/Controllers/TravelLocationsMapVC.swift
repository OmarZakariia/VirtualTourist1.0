//
//  TravelLocationsMapVC.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapVC: UIViewController {

   
    
    
    
    // MARK: - IBOutlets and Variables
    @IBOutlet weak  var editButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deletePinsMessage: UIView!
    
    
    // core data stack
    var dataController : DataController!
    var editMode: Bool = false
 
    
    // array of pins
    var pins : [Pin] = []
    
    var pinsOnMap : [PinOnMap] = []
    
    var pinToPass : Pin? = nil
    
    var pinCoordinate : CLLocationCoordinate2D? = nil
    
    
    var flickrPhotos : [FlickrImage] = [FlickrImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editDoneButton()
        fetchRequestForPins()
    }
    
    
    
    
    
    // MARK: - Functions
    func fetchRequestForPins(){
        
//        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
//
//        if let result = try? dataController.viewContext.fetch(fetchRequest){
//            pins = result
//        }
//
//        for pin in pins {
//            let coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
//
//            let pins = PinOnMap(coordinate: coordinate)
//            pinsOnMap.append(pins)
//        }
//        mapView.addAnnotations(pinsOnMap)
        
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        
        if let result = try? dataController.viewContext.fetch(fetchRequest){
            pins = result
        }
        
        for pin in pins {
            let coordiante  = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            let pins = PinOnMap(coordinate: coordiante)
            
            pinsOnMap.append(pins)
        }
        
        mapView.addAnnotations(pinsOnMap)
    }
    
    func addPinToCoreData(coordinate: CLLocationCoordinate2D){
        let pin = Pin(latitude: coordinate.latitude, longitude: coordinate.longitude, context: dataController.viewContext)
        pins.append(pin)
        
        try? dataController.viewContext.save()
    }
    
    func requestFlickrPhotosFromPin(coordinate: CLLocationCoordinate2D){
        ClientForFlickr.sharedInstance().getPhotosPath(lat: coordinate.latitude, lon: coordinate.longitude) { photos, error in
            if let photos = photos {
                self.flickrPhotos = photos
                
            } else {
                print(error ?? "empty error")
            }
        }
        print("\(flickrPhotos)")
    }
    
    // MARK: - Loading view functions
    func editDoneButton(){
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        deletePinsMessage.isHidden = !editing
        editMode = editing
        
    }
    
    
    // MARK: - IBFunctions
    @IBAction func addPinToMap(_ sender: UITapGestureRecognizer){
        
        if !editMode{
            let gestureTouchLocation: CGPoint = sender.location(in: mapView)
            
            let coordinateToAdd : CLLocationCoordinate2D = mapView.convert(gestureTouchLocation, toCoordinateFrom: mapView)
            
            let annotation : MKPointAnnotation = MKPointAnnotation()
            
            annotation.coordinate = coordinateToAdd
            
            mapView.addAnnotation(annotation)
        }
    }
}


// MARK: - Extension
extension TravelLocationsMapVC{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PinPhotos"{
            let photoAlbumVC = segue.destination as! PhotoAlbumViewController
            
            let coordinate = sender as! CLLocationCoordinate2D
            
            photoAlbumVC.dataController = dataController
            
            photoAlbumVC.pin = pinToPass
            
            photoAlbumVC.selectedCoordinate = coordinate
            
            photoAlbumVC.flickrPhotos = flickrPhotos
        }
    }
}
