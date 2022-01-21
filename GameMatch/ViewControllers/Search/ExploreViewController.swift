//
//  ExploreViewController.swift
//  Game Match
//
//  Created by Luke Shi on 8/11/21.
//

import UIKit
import MapKit
import CoreLocation

class ExploreViewController: BaseViewController
{
    @IBOutlet weak var activitySearchBar: UISearchBar!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultViewPositionY: NSLayoutConstraint!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var locationTableBottom: NSLayoutConstraint!
    
    private let exploreVM = ExploreViewModel()
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var locationSearchResults = [MKLocalSearchCompletion]()
    
    private var startPosition: CGFloat = 0
    private var currentPosition: CGFloat = 0
    
    private let pinIdentifier = "pin"

    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        activitySearchBar.searchTextField.backgroundColor = .clear
        activitySearchBar.layer.cornerRadius = 5
        activitySearchBar.clipsToBounds = true
        
        locationSearchBar.searchTextField.backgroundColor = .clear
        locationSearchBar.layer.cornerRadius = 5
        locationSearchBar.clipsToBounds = true
        locationSearchBar.isHidden = true
        locationSearchBar.setImage(UIImage(systemName: "location.north"), for: .search, state: .normal)
                
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.isHidden = true
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panAction))
        resultView.addGestureRecognizer(pan)
                
        startPosition = resultViewPositionY.constant
        resultViewPositionY.constant = 800
        
        mapView.delegate = self
        setupMapView(latitude: 37.505368, longitude: -122.264192, scale: 0.3)
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(tap)
        
        setupLocationService()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showActivityLocations),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        bindViewModel(exploreVM)
    }

    override func displayData()
    {
        if exploreVM.data != nil {
            DispatchQueue.main.async {
                self.locationSearchBar.isHidden = true
                self.showSearchResult()
            }
        }
    }
        
    @objc private func keyboardWillShow(_ notification: Notification)
    {
        if let info = notification.userInfo,
           let infoValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let kbdFrame = infoValue.cgRectValue
            locationTableBottom.constant = view.bounds.height - kbdFrame.origin.y + 2
        }
    }
    
    private func setupLocationService()
    {
        LocationService.shared.setupLocationManager()
                
        searchCompleter.delegate = self
    }
    
    @objc private func mapTapped()
    {
        activitySearchBar.resignFirstResponder()
    }
    
    private func setupMapView(latitude: CLLocationDegrees,
                              longitude: CLLocationDegrees,
                              scale: CLLocationDegrees)
    {
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        mapView.centerToLocation(initialLocation)
        
        let region = MKCoordinateRegion(center: mapView.centerCoordinate,
                                        span: MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale))
        mapView.setRegion(region, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func searchActivities(location: CLLocation, name: String?)
    {
        exploreVM.getActivities(latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude,
                                name: name)
    }
        
    @objc func panAction(_ pan: UIPanGestureRecognizer)
    {
        switch pan.state {
        case .began:
            currentPosition = resultViewPositionY.constant
        case .changed:
            let translation = pan.translation(in: self.view)
            let newPosition = currentPosition + translation.y
            resultViewPositionY.constant = max(startPosition, newPosition)
        case .ended:
            let dragVelocity = pan.velocity(in: view)
            if abs(dragVelocity.y) >= 1300 {
                // Velocity fast enough to dismiss the uiview
                let translation = pan.translation(in: self.view)
                let newPosition = currentPosition + translation.y + (dragVelocity.y / 15)
                resultViewPositionY.constant = max(startPosition, newPosition)
            }
            currentPosition = 0
        default:
            break
        }
    }
    
    func showActivityDetails(activity: Activity)
    {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController,
           let activityId = activity.id
        {
            activityScreen.setup(activityId: activityId,
                                 isEditable: false)
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
    
    @objc private func showActivityLocations()
    {
        mapView.removeAnnotations(mapView.annotations)
        
        let pins = ["soccer-pin", "volleyball-pin", "golf-pin"]
        if let activities = exploreVM.data as? [Activity] {
            for activity in activities {
                if let latitude = activity.location?.latitude,
                   let longitude = activity.location?.longitude
                {
                    addAnnotation(title: "Soccer Game",
                                  name: pins.randomElement() ?? "golf-pin",
                                  latitude: latitude,
                                  longitude: longitude)
                }
            }
            
//            if let firstActivity = activities.first {
//                setupMapView(latitude: firstActivity.location.latitude,
//                             longitude: firstActivity.location.longitude, scale: 0.2)
//            }
        }
    }
    
    private func addAnnotation(title: String, name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        let annotation = GMPointAnnotation(named: name)
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title

        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
        if let annotation = pinAnnotationView.annotation {
            mapView.addAnnotation(annotation)
        }
    }
}

extension ExploreViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        
        let name = activitySearchBar.text
        
        if let address = locationSearchBar.text, !address.isEmpty {
            CLGeocoder().geocodeAddressString(address) { [weak self] placemarks, error in
                if let location = placemarks?.first?.location {
                    self?.searchActivities(location: location,
                                           name: name)
                }
            }
        } else if let location = LocationService.shared.locationManager?.location {
            searchActivities(location: location,
                             name: name)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        locationSearchBar.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchBar == locationSearchBar {
            searchCompleter.queryFragment = searchText
        }
    }
    
    private func showSearchResult()
    {
        showActivityLocations()
        
        eventsTableView.reloadData()
        
        UIView.animate(withDuration: 0.6,
                       animations: { [weak self] in
                           self?.resultViewPositionY.constant = self?.startPosition ?? 0
                           self?.view.layoutIfNeeded()
                       })
    }
}

extension ExploreViewController: MKLocalSearchCompleterDelegate
{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
    {
        // Setting our searchResults variable to the results that the searchCompleter returned
        locationSearchResults = completer.results
        locationTableView.reloadData()
        locationTableView.isHidden = false
    }

    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error)
    {
        // Error
    }
}

extension ExploreViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView == eventsTableView,
           let activities = exploreVM.data as? [Activity]
        {
            return activities.count
        }
        return locationSearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == eventsTableView {
            return activityCell(indexPath: indexPath)
        }
        return locationCell(indexPath: indexPath)
    }
    
    private func locationCell(indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
        cell.imageView?.image = UIImage(systemName: "location")
        let location = locationSearchResults[indexPath.row]
        cell.textLabel?.text = location.title
        cell.detailTextLabel?.text = location.subtitle
        return cell
    }
    
    private func activityCell(indexPath: IndexPath) -> UITableViewCell
    {
        let cell = eventsTableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        if let cell = cell as? ActivityTableViewCell,
           let activities = exploreVM.data as? [Activity]
        {
            let activity = activities[indexPath.row]
            let icon = indexPath.row % 2 == 0 ? UIImage(named: "soccerball") : UIImage(named: "hiking")

            if let name = activity.name,
               let eventStartTime = activity.eventStartTime,
               let locationName = activity.location?.name
            {
                cell.config(icon: icon,
                            title: name + " - " + eventStartTime.display(),
                            details: locationName)
            }
        }
        return cell
    }
}

extension ExploreViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView == eventsTableView,
           let activities = exploreVM.data as? [Activity]
        {
            let activity = activities[indexPath.row]
            showActivityDetails(activity: activity)
        } else {
            let location = locationSearchResults[indexPath.row]
            locationSearchBar.text = location.title + ", " + location.subtitle
            locationTableView.isHidden = true
        }
    }
}

extension ExploreViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard annotation is MKPointAnnotation else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let annotation = annotation as? GMPointAnnotation {
            annotationView?.image = UIImage(named: annotation.pinImageName)
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotation = view.annotation as? GMPointAnnotation {
            showDirection(name: annotation.title ?? "",
                          latitude: annotation.coordinate.latitude,
                          longitude: annotation.coordinate.longitude)
        }
    }
    
    private func showDirection(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    {
        if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(url)
        {
            UIApplication.shared.open(url, options: [:])
        }
        else {
            let coordinate = CLLocationCoordinate2DMake(latitude,longitude)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
