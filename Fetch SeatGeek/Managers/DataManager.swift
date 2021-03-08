//
//  DataManager.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 2/26/21.
//

import Foundation
import UIKit

public class DataManager {
    
    //Retrieves all events from a specific page from SeatGeek API (Default events per page = 10)
    public class func getEvents(page: Int, success: @escaping ([Event]?) -> ()) {
        
        let pageString = String(page)
        
        let urlString = Constants.API_ENDPOINT + "/events?client_id=" + Constants.CLIENT_ID + "&page=" + pageString
        guard let url = URL(string: urlString) else {
            success(nil)
            return
        }
        
        getRequest(url: url, success: { json in
            
            guard let json = json else {
                success(nil)
                return
            }
            
            var events: [Event] = []
            
            let eventsJson = json["events"] as! [[String: Any]]
            //print(eventsJson[0])
            for eventJson in eventsJson {
                let id = (eventJson["id"] as! NSNumber).stringValue
                let title = eventJson["short_title"] as! String
                
                let performers = eventJson["performers"] as! [[String: Any]]
                
                var imageUrl = "placeholder.png"
                if(performers.count > 0) {
                    imageUrl = performers[0]["image"] as? String ?? "placeholder.png"
                }
                
                let venue = eventJson["venue"] as! [String: Any]
                let city = venue["city"] as? String ?? "Unknown"
                let state = venue["state"] as? String ?? "Unknown"
                let location = city + ", " + state
                
                let rawDate = eventJson["datetime_utc"] as? String ?? "Unknown"
                let date = String(rawDate.split(separator: "T")[0])
                
                events.append(Event(id: id, title: title, date: date, location: location, imageUrl: imageUrl))
            }
            
            success(events)
        })
        
    }
    
    //Retrieves all events from a specific page from SeatGeek API matching a specific query (Default events per page = 10)
    public class func getEventsWith(query: String, page: Int, success: @escaping ([Event]?) -> ()) {
        
        let pageString = String(page)
        
        let q = query.replacingOccurrences(of: " ", with: "+")
        
        let urlString = Constants.API_ENDPOINT + "/events?client_id=" + Constants.CLIENT_ID + "&q=" + q
        guard let url = URL(string: urlString) else {
            success(nil)
            return
        }
        
        getRequest(url: url, success: { json in
            
            guard let json = json else {
                success(nil)
                return
            }
            
            var events: [Event] = []
            
            let eventsJson = json["events"] as! [[String: Any]]
            //print(eventsJson[0])
            for eventJson in eventsJson {
                let id = (eventJson["id"] as! NSNumber).stringValue
                let title = eventJson["short_title"] as! String
                
                let performers = eventJson["performers"] as! [[String: Any]]
                
                var imageUrl = "placeholder.png"
                if(performers.count > 0) {
                    imageUrl = performers[0]["image"] as? String ?? "placeholder.png"
                }
                
                let venue = eventJson["venue"] as! [String: Any]
                let city = venue["city"] as? String ?? "Unknown"
                let state = venue["state"] as? String ?? "Unknown"
                let location = city + ", " + state
                
                let rawDate = eventJson["datetime_utc"] as? String ?? "Unknown"
                let date = String(rawDate.split(separator: "T")[0])
                
                events.append(Event(id: id, title: title, date: date, location: location, imageUrl: imageUrl))
            }
            
            success(events)
        })
        
    }
    
    //MARK: GET Request Template
    
    private class func getRequest(url: URL, success: @escaping ([String: Any]?) -> ()) {
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                success(nil)
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                success(nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                success(json)
            } catch {
                print("An error occurred")
                success(nil)
            }
        }

        task.resume()
        
    }
    
}

//MARK:: UIImage Extension for asynchrously loading images

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
    
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
        
            if error != nil {
                print(error ?? "Error Occurred")
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data!)
                self.image = image
            }
            /*DispatchQueue.main.async(execute: { () -> Void in
                
            })*/
        
        }).resume()
    }
}
