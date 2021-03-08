# FetchSeatGeek
FetchRewards Coding Exercise

This project is a coding exercise for FetchRewards utilizing the SeatGeek public API.

# Basic Info
-Utilizes Swift 5  
-Tested on Xcode 12.4

# Functionality
-Download and display events from the SeatGeek public API  
-Like/Dislike events that persist through each use of the application  
-Search the SeatGeek API using a SearchBar

# More
The app uses GET requests to the public SeakGeek API to retrieve and search for events. The events JSON from the SeatGeek API is converted into a local "Event" model. After this conversion, the event is added to an array and displayed on a UITableView utilizing a custom UITableViewCell. If a user gets to the end of the TableView and continues to scroll, 10 more events will be loaded from the SeatGeek API and displayed on the TableView. When a UITableViewCell is pressed, the user is brought to a detail ViewController that displays information about the selected event.\n\n

If a user uses the UISearchBar, an API request is made to the SeatGeek API utilizing the query parameter.  
  
The functions created for utilizing the SeatGeek API and the liking/disliking of events is unit tested.
