//
//  PhotoAlbumViewControllerMethods.swift
//  VirtualTourist
//
//  Created by Zakaria on 09/11/2021.
//

import Foundation
import UIKit
import MapKit


// MARK: - UICollectionViewCellDataSource Methods

extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coreDataPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let photo = coreDataPhotos[(indexPath as NSIndexPath).row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        
        if photo.imageData != nil{
            let photo = UIImage(data: photo.imageData! as Data)
            
            performUIUpdatesOnMain {
                cell.photoImageView.image = photo
                cell.activityIndicator.stopAnimating()
            }
            
        } else {
            if let photoPath = photo.imageURL {
                let _ = ClientForFlickr.sharedInstance().taskForGetImage(photoPath: photoPath) { imageData, error in
                    if let image = UIImage(data: imageData!) {
                        
                        photo.imageData = NSData.init(data: imageData!)
                        
                        try? self.dataController.viewContext.save()
                        
                        performUIUpdatesOnMain {
                            cell.photoImageView.image = image
                            cell.activityIndicator.stopAnimating()
                        }
                    } else {
                        print(error ?? "empty error")
                    }
                }
            }
        }
        
        return cell
    }
}


// MARK: - UICollectionViewCellDelegate Methods
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedToDelete = selectedToDeleteFromIndexPath(collectionView.indexPathsForSelectedItems!)
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        
        DispatchQueue.main.async {
            cell?.contentView.alpha = 0.4 
        }
        
    }
}
