//
//  ClientForFlickr.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation
// Object to fetch Flickr images that takes the pin coordinates as an input


class ClientForFlickr: NSObject{
    
    
    // MARK: - Properties
    
    // the shared session
    var session = URLSession.shared
    
    // array to store downloaded photos URLs from Flickr
    var photosPath : [FlickrImage] = [FlickrImage]()
    
    
    // MARK: - Initializer
    override init() {
        super.init()
    }
    
    /* If the request is successful, it gets an array of dictionaries [FlickrImage] Each value of the array dictionary contains a URL to construct a photo
     
      lat : latitude of coordinate taped by the user
      lon : longitude of coordinate taped by the user
     completionHandlerForGetPhotosPath: handles the result of the request, if error occurs it shows it else it stores the request
     */
    
    func getPhotosPath(lat: Double, lon: Double, completionHandlerForGetPhotosPath:@escaping(_ result: [FlickrImage]?, _ error : NSError?)-> Void){
        
        
        // parameters for the web request
        let methodParams: [String: Any] = [
            ClientForFlickr.ParameterKeys.Method : ClientForFlickr.ParameterValues.SearchMethod,
            ClientForFlickr.ParameterKeys.ApiKey : ClientForFlickr.ParameterValues.ApiKey,
            ClientForFlickr.ParameterKeys.Format : ClientForFlickr.ParameterValues.ResponseFormat,
            ClientForFlickr.ParameterKeys.Lat: lat,
            ClientForFlickr.ParameterKeys.Lon: lon,
            ClientForFlickr.ParameterKeys.NoJSONCallBack : ClientForFlickr.ParameterValues.DisableJSONCallBack,
            ClientForFlickr.ParameterKeys.SafeSearch : ClientForFlickr.ParameterValues.UseSafeSearch,
            ClientForFlickr.ParameterKeys.Extras : ClientForFlickr.ParameterValues.MediumURL,
            ClientForFlickr.ParameterKeys.Radius : ClientForFlickr.ParameterValues.SearchRangeKm,
            ClientForFlickr.ParameterKeys.Perpage : ClientForFlickr.ParameterValues.PerPageAmount,
            ClientForFlickr.ParameterKeys.Page: Int(arc4random_uniform(6))
        
        ]
        
        // pass the parameter 'taskForGetMethod'
        let _ = taskForGetMethod(methodParameters: methodParams as [String: AnyObject]) { results, error in
            // send the values
            if let error = error {
                 completionHandlerForGetPhotosPath(nil, error)
            } else {
                if  let photos = results?[ClientForFlickr.JSONResponseKeys.Photo] as? [String: AnyObject],
                    let photo = photos [ClientForFlickr.JSONResponseKeys.Photo] as? [[String: AnyObject]]{
                    
                    let flickerImages = FlickrImage.photosPathFromResults(photo)
                    completionHandlerForGetPhotosPath(flickerImages, nil)
                } else {
                    completionHandlerForGetPhotosPath(nil, NSError(domain: "getPhotosPath", code: 0, userInfo: [NSLocalizedDescriptionKey : "There was an error parsing getPhotosPath"]))
                }
            }
        }
    }
    
    func taskForGetMethod(methodParameters: [String: AnyObject], completionHandlerForGet: @escaping (_ result: AnyObject?, _ error: NSError?)-> Void)->URLSessionDataTask{
        // store the previous set parameters
        let parametersReceived = methodParameters
        
        // build the URL and configure the request
        let request  = NSMutableURLRequest(url: flickrURLsFromParameters(parametersReceived))
        
        
        let task = session.dataTask(with: request as URLRequest) { data , response , error  in
            
            // if the request fails, send an error message
            func sendError(_ error : String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            // gaurd the error
            guard error == nil else {
                sendError("An error occurred during the request:\(error!)")
                return
            }
            
            // 2XX response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                sendError("Request returned a status code other than 2XX")
                return
            }
            
            // Data
            guard let data = data  else {
                sendError("No data returned by the request")
                return
            }
            
            // parse and use the data
            self.dataConverstionWithCompletionHandler(data, completionHandlerForDataConverted: completionHandlerForGet)
            
        }
        
        task.resume()
        return task
        
    }
    
    func taskForGetImage(photoPath: String, completionHandlerForImage: @escaping(_ imageData: Data?, _ error : NSError?)-> Void) -> URLSessionTask{
        
        let url = URL(string: photoPath)!
        let request  = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data , response , error in
            // send and show error if there is any
            
            func sendError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForImage(nil, NSError(domain: "taskForGetImages", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200, statusCode <= 299 else{
                sendError("The request returned an error other than 2XX")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request")
                return
            }
            completionHandlerForImage(data,nil)
        }
        task.resume()
        
        return task
        
    }
    
    
    
    // MARK: - Private functions
    private func flickrURLsFromParameters(_ parameters: [String: AnyObject])-> URL{
        var componenets = URLComponents()
        componenets.scheme = ClientForFlickr.Constants.ApiScheme
        componenets.host = ClientForFlickr.Constants.ApiHost
        componenets.path = ClientForFlickr.Constants.ApiPath
        componenets.queryItems = [URLQueryItem]()
        
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            componenets.queryItems!.append(queryItem)
        }
        return componenets.url!
    }
    
    
    private func  dataConverstionWithCompletionHandler(_ data : Data, completionHandlerForDataConverted: (_ result: AnyObject?, _ error: NSError?)-> Void){
        
        
        var resultsParsed : AnyObject! = nil
        
        // check for errors while JSON serialization
        do{
            resultsParsed = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse data as JSON: \(data)"]
            completionHandlerForDataConverted(nil, NSError(domain: "dataConverstionWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        // pass the data converted
        completionHandlerForDataConverted(resultsParsed, nil)
    }
    
    
    
    class func sharedInstance() ->  ClientForFlickr{
        struct Singleton {
            static var sharedIstance = ClientForFlickr()
        }
        
        return Singleton.sharedIstance
        
    }
}

