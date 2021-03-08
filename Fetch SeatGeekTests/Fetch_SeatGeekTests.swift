//
//  Fetch_SeatGeekTests.swift
//  Fetch SeatGeekTests
//
//  Created by Joey Chung on 2/26/21.
//

import XCTest
@testable import Fetch_SeatGeek

class Fetch_SeatGeekTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testApiRequests() {
        
        DataManager.getEvents(page: 1, success: { events in
            XCTAssert(events != nil && events!.count > 0)
            for event in events! {
                XCTAssert(event.id.count > 0 && event.title.count > 0 && event.location.count > 0 && event.date.count > 0 && event.imageUrl.count > 0)
            }
        })
        
    }
    
    func testBasicLikeMechanism() throws {
        
        Utils.removeAllEvents()
        
        let e1 = Event(id: "0", title: "Title", date: "Date", location: "Location", imageUrl: "image.png")
        XCTAssert(Utils.isEventLiked(event: e1) == false)
        
        //Event should show as liked after calling "likeEvent" a single time
        Utils.likeEvent(event: e1)
        XCTAssert(Utils.isEventLiked(event: e1))
        
        //Calling "likeEvent" a second time unlikes the event so it should return false
        Utils.likeEvent(event: e1)
        XCTAssert(Utils.isEventLiked(event: e1) == false)
        
    }
    
    func testAdvancedLikeMechanism() throws {
        
        let e1 = Event(id: "0", title: "Title 1", date: "Date", location: "Location", imageUrl: "image.png")
        let e2 = Event(id: "1", title: "Title 2", date: "Date", location: "Location", imageUrl: "image.png")
        let e3 = Event(id: "2", title: "Title 3", date: "Date", location: "Location", imageUrl: "image.png")
        let e4 = Event(id: "3", title: "Title 4", date: "Date", location: "Location", imageUrl: "image.png")
        let e5 = Event(id: "4", title: "Title 5", date: "Date", location: "Location", imageUrl: "image.png")
        
        Utils.removeAllEvents()
        
        XCTAssert(Utils.isEventLiked(event: e1) == false && Utils.isEventLiked(event: e2) == false && Utils.isEventLiked(event: e3) == false && Utils.isEventLiked(event: e4) == false && Utils.isEventLiked(event: e5) == false)
        
        Utils.likeEvent(event: e1)
        Utils.likeEvent(event: e2)
        Utils.likeEvent(event: e3)
        Utils.likeEvent(event: e4)
        Utils.likeEvent(event: e5)
        
        XCTAssert(Utils.isEventLiked(event: e1) && Utils.isEventLiked(event: e2) && Utils.isEventLiked(event: e3) && Utils.isEventLiked(event: e4) && Utils.isEventLiked(event: e5))
        
        Utils.likeEvent(event: e3)
        
        XCTAssert(Utils.isEventLiked(event: e1) && Utils.isEventLiked(event: e2) && Utils.isEventLiked(event: e3) == false && Utils.isEventLiked(event: e4) && Utils.isEventLiked(event: e5))
        
        Utils.likeEvent(event: e5)
        
        XCTAssert(Utils.isEventLiked(event: e1) && Utils.isEventLiked(event: e2) && Utils.isEventLiked(event: e3) == false && Utils.isEventLiked(event: e4) && Utils.isEventLiked(event: e5) == false)
        
        Utils.likeEvent(event: e3)
        Utils.likeEvent(event: e5)
        
        XCTAssert(Utils.isEventLiked(event: e1) && Utils.isEventLiked(event: e2) && Utils.isEventLiked(event: e3) && Utils.isEventLiked(event: e4) && Utils.isEventLiked(event: e5))
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
