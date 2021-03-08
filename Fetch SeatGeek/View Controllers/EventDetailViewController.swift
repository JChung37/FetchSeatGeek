//
//  EventDetailViewController.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 2/26/21.
//

import UIKit

class EventDetailViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var heartImageView: UIImageView!
    
    var selectedEvent: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceSetup()
    }
    
    //Populates UI with the selected event's information
    private func interfaceSetup() {
        headerImageView.imageFromServerURL(urlString: selectedEvent.imageUrl)
        titleLabel.text = selectedEvent.title
        locationLabel.text = selectedEvent.location
        dateLabel.text = selectedEvent.date
        
        if(Utils.isEventLiked(event: selectedEvent)) {
            heartImageView.image = UIImage(systemName: "heart.fill")
        }else{
            heartImageView.image = UIImage(systemName: "heart")
        }
        
    }
    
    @IBAction func heartPressed(_ sender: Any) {
        if(heartImageView.image == UIImage(systemName: "heart")) {
            heartImageView.image = UIImage(systemName: "heart.fill")
        }else{
            heartImageView.image = UIImage(systemName: "heart")
        }
        
        Utils.likeEvent(event: selectedEvent)
    }
    
}
