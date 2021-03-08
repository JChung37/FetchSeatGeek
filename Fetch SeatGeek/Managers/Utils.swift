//
//  Utils.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 3/1/21.
//

import Foundation

public class Utils {
    
    //Checks if event is in the liked events array
    class func isEventLiked(event: Event) -> Bool {
        guard let likedEvents = UserDefaults.standard.stringArray(forKey: "LikedEvents") else {
            return false
        }
        
        if(likedEvents.contains(event.id)) {
            return true
        }
        
        return false
    }
    
    //Likes an event if it isn't in liked events array, otherwise it removes it from the liked events array
    class func likeEvent(event: Event) {
        var likedEvents = UserDefaults.standard.stringArray(forKey: "LikedEvents") ?? []
        if(likedEvents.contains(event.id)) {
            likedEvents.remove(at: likedEvents.firstIndex(of: event.id)!)
        }else{
            likedEvents.append(event.id)
        }
        UserDefaults.standard.setValue(likedEvents, forKey: "LikedEvents")
    }
    
    //Removes all events from liked events array
    class func removeAllEvents() {
        UserDefaults.standard.setValue([], forKey: "LikedEvents")
    }
    
}

protocol LikeDelegate {
    func likePressed(index: Int)
}
