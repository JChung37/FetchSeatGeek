//
//  EventTableViewController.swift
//  Fetch SeatGeek
//
//  Created by Joey Chung on 2/26/21.
//

import UIKit

class EventTableViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    private var loadingView: LoadingView!
    
    var selectedEvent: Event!
    var events: [Event] = []
    var filteredEvents: [Event] = []
    
    //Offset that determines when new events will be loaded from scrolling down the TableView
    private let LOAD_OFFSET: CGFloat = 10.0
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLoadingView()
        getEvents(page: currentPage)
    }

    //Initialize the loading indicator
    private func createLoadingView() {
        
        let x = (UIScreen.main.bounds.width / 2) - 25
        let y = (UIScreen.main.bounds.height / 2) - 25
        
        loadingView = LoadingView(frame: CGRect(x: x, y: y, width: 50, height: 50))
        loadingView.isHidden = true
        self.view.addSubview(loadingView)
    }
    
    //Retrieves events from a specified page of the API and refreshes the TableView
    private func getEvents(page: Int) {
        loadingView.isHidden = false
        DataManager.getEvents(page: page, success: { [weak self] events in
            
            guard let events = events else {
                DispatchQueue.main.async {
                    self?.loadingView.isHidden = true
                }
                return
            }
            
            self?.events.append(contentsOf: events)
            self?.filteredEvents.append(contentsOf: events)
            
            DispatchQueue.main.async {
                self?.loadingView.isHidden = true
                self?.tableView.reloadData()
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "fromTableToDetail") {
            
            guard let selectedEvent = selectedEvent else {
                return
            }
            
            let detailViewController: EventDetailViewController = segue.destination as! EventDetailViewController
            detailViewController.selectedEvent = selectedEvent
        }
    }
    
}

//MARK: UITableView Methods

extension EventTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EventTableViewCell
        
        if(indexPath.row < filteredEvents.count) {
            let event = filteredEvents[indexPath.row]
            
            cell.tag = indexPath.row
            cell.likeDelegate = self
            
            cell.titleLabel.text = event.title
            cell.locationLabel.text = event.location
            cell.dateLabel.text = event.date
            cell.eventImageView.imageFromServerURL(urlString: event.imageUrl)
            
            if(Utils.isEventLiked(event: event)) {
                cell.heartImageView.image = UIImage(systemName: "heart.fill")
            }else{
                cell.heartImageView.image = UIImage(systemName: "heart")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = filteredEvents[indexPath.row]
        self.performSegue(withIdentifier: "fromTableToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //Function to check if user has gotten to end of current data set
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= LOAD_OFFSET {
            currentPage += 1
            getEvents(page: currentPage)
        }
        
    }
    
}

//MARK: UISearchBar Methods

extension EventTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredEvents.removeAll()
        if let searchText = searchBar.text, !searchText.isEmpty {
            DataManager.getEventsWith(query: searchText, page: 0, success: { [weak self] events in
                guard let events = events else {
                    return
                }
                self?.filteredEvents = events
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        } else {
            DataManager.getEvents(page: 0, success: { [weak self] events in
                guard let events = events else {
                    return
                }
                self?.filteredEvents = events
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
}

//MARK: LikeDelegate called when a TableView cell's "Heart" button is pressed

extension EventTableViewController: LikeDelegate {
    
    func likePressed(index: Int) {
        let event = filteredEvents[index]
        Utils.likeEvent(event: event)
        print("----------")
        print(event.id)
        print(event.title)
        print(event.location)
        print(event.date)
        print("----------")
        print("Like Pressed at Index: " + String(index))
    }
    
}
