//
//  Event.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 2/26/21.
//

import Foundation

public class Event {
    
    var id: String
    var title: String
    var date: String
    var location: String
    var imageUrl: String
    
    init(id: String, title: String, date: String, location: String, imageUrl: String) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.imageUrl = imageUrl
    }
    
}
