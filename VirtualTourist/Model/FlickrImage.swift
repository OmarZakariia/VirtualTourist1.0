//
//  FlickrImage.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation

// Object that contains the data URLs to create the images

struct FlickrImage{
    
    
    // MARK: - Properties
    // URL for photo
    let photoPath : String?
    
    
    // MARK: - Initializer
    init(dictionary: [String: AnyObject]) {
        photoPath = dictionary[ClientForFlickr.JSONResponseKeys.MediumURL] as? String
        
    }
    
    
    // MARK: - Results
    static func photosPathFromResults(_ results: [[String: AnyObject]])-> [FlickrImage]{
        
        // save the photos
        var photosPath = [FlickrImage]()
        
        for result in results {
            photosPath.append(FlickrImage(dictionary: result))
        }
        
        return photosPath
    }
    
    
}
