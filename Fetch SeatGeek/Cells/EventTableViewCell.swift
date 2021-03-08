//
//  EventTableViewCell.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 2/26/21.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet var eventImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var heartImageView: UIImageView!
    
    var likeDelegate: LikeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func heartButtonPressed(_ sender: Any) {
        if(heartImageView.image == UIImage(systemName: "heart")) {
            heartImageView.image = UIImage(systemName: "heart.fill")
        }else{
            heartImageView.image = UIImage(systemName: "heart")
        }
        
        likeDelegate!.likePressed(index: self.tag)
    }
    
}
