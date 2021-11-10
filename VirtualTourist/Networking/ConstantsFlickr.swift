//
//  ConstantsFlickr.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation

// Data objects that is required for making a request

extension ClientForFlickr{
    
    struct Constants {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    
  
    
    
    // MARK: - Parameter Keys and Values
    struct ParameterKeys {
        
        static let Method  = "method"
        static let ApiKey = "api_key"
        static let Format = "format"
        static let Lat = "lat"
        static let Lon = "lon"
        static let NoJSONCallBack = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Extras = "extras"
        static let Radius = "radius"
        static let Perpage = "per_page"
        static let Page = "page"
    }
    
   
    
    struct ParameterValues {
        static let SearchMethod = "lickr.photos.search"
        static let ApiKey = "d4bdb93f99dfab1953d31060b8fb72be"
        static let ResponseFormat = "json"
        static let DisableJSONCallBack = "1" // 1 means yes
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
        static let SearchRangeKm = 10
        static let PerPageAmount = 21
    }
    
    
    // MARK: - JSON Response Keys and Values
   
    
    struct JSONResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
    }
    
    struct ResponseValues {
        static let  OkStatus = "ok"
    }
    
    
}
