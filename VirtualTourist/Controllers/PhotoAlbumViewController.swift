//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Zakaria on 07/11/2021.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController {
    
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapFragment: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newCollectionButton : UIButton!
    
    // MARK: - Properties
    var dataController : DataController!
    let regionRadius : CLLocationDistance = 1000
    let photoCell = PhotoCell()
    
    var flickrPhotos: [FlickrImage] = [FlickrImage]()
    
    var coreDataPhotos: [Photo] = []
    
    var pin: Pin! = nil
    
    var selectedCoordinate: CLLocationCoordinate2D!
    
    
    var selectedToDelete: [Int] = [] {
        didSet{
            if selectedToDelete.count > 0{
                newCollectionButton.setTitle("Remove the pictures selected", for: .normal)
            } else {
                newCollectionButton.setTitle("New Collection", for: .normal)
            }
        }
    }
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newCollectionButton.isHidden = false
        addAnnotationToMap()
        collectionViewLayout()

        photosFetchRequest()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performUIUpdatesOnMain{
            self.collectionView.reloadData()
            print("📷\(self.coreDataPhotos.count)")
            
        }
    }
    

    
    // MARK: - Functions
    
    func  photosFetchRequest(){
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        

        let newPredicate = NSPredicate(format: "pin == %@", pin)


        fetchRequest.predicate = newPredicate

        if let result = try? dataController.viewContext.fetch(fetchRequest){
            coreDataPhotos = result

            performUIUpdatesOnMain {
                if self.coreDataPhotos.count == 0 {
                    self.flickerPhotosFetchRequestFromPin()
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    
    func flickerPhotosFetchRequestFromPin() {
        ClientForFlickr.sharedInstance().getPhotosPath(lat: selectedCoordinate.latitude, lon: selectedCoordinate.longitude) { photos, error in
            
            if let photos = photos {
                
                self.flickrPhotos = photos
                
                for photo in photos {
                    let photoPath = photo.photoPath
                    
                    let photoCoreData = Photo(imageURL: photoPath, context: self.dataController.viewContext)
                    
                    photoCoreData.pin = self.pin
                    
                    self.coreDataPhotos.append(photoCoreData)
                    
                    try? self.dataController.viewContext.save()
                }
                
                performUIUpdatesOnMain {
                    self.collectionView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    func selectedToDeleteFromIndexPath(_ indexPathArray : [IndexPath])-> [Int]{
        var selected : [Int] = []
        
        for indexPath in indexPathArray {
            selected.append(indexPath.item)
        }
    
        return selected
    
        
    }
    
    // MARK: - IBAction functions
    @IBAction func deleteSelected(_ sender: Any){
        if let selected:[IndexPath] = collectionView.indexPathsForSelectedItems {
            let items  = selected.map{$0.item}.sorted().reversed()
            
            for item in items {
                
                dataController.viewContext.delete(coreDataPhotos.remove(at: item))
                
                try? dataController.viewContext.save()
            }
            
            collectionView.deleteItems(at: selected)
        }
    }
    
    @IBAction func newCollectionPhoto(_ sender: UIButton){
        if selectedToDelete.count > 0 {
            print("there is more that one selected item to delete")
        } else {
            flickerPhotosFetchRequestFromPin()
        }
    }
    
    
    // MARK: - MKMapView Functions
    func centerMapOnLocation(location : CLLocation){

        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapFragment.setRegion(coordinateRegion, animated: true)
    }
    
    func addAnnotationToMap(){
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = selectedCoordinate
        mapFragment.addAnnotation(annotation)
        mapFragment.showAnnotations([annotation], animated: true)
    }

}



// MARK: - Extension for PhotoAlbumViewController
extension PhotoAlbumViewController{
    
    func collectionViewLayout(){
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.isHidden = false
        collectionView.allowsMultipleSelection = true
    }
    
}
