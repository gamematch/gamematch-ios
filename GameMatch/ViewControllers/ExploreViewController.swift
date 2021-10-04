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
    @IBOutlet weak var tableView: UITableView!
        
    private let exploreVM = ExploreViewModel()
    
    private var locationManager: CLLocationManager?
    
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
                
        tableView.delegate = self
        tableView.dataSource = self
        
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
    }
    
    private func setupLocationService()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
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
    
    func showActivityDetails()
    {
        if let activityScreen = UIStoryboard(name: "Main",
                                             bundle: nil).instantiateViewController(identifier: "ActivityDetailsViewController") as? ActivityDetailsViewController {
            navigationController?.pushViewController(activityScreen, animated: true)
        }
    }
    
    @objc private func showActivityLocations()
    {
        mapView.removeAnnotations(mapView.annotations)
        
        let pins = ["soccer-pin", "volleyball-pin", "golf-pin"]
        if let activities = exploreVM.activities {
            for activity in activities {
                addAnnotation(title: "Soccer Game",
                              name: pins.randomElement() ?? "golf-pin",
                              latitude: activity.latitude,
                              longitude: activity.longitude)
            }
            
            if let firstActivity = activities.first {
                setupMapView(latitude: firstActivity.latitude, longitude: firstActivity.longitude, scale: 0.2)
            }
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
        
        if let latitude = locationManager?.location?.coordinate.latitude,
           let longitude = locationManager?.location?.coordinate.longitude
        {
            startSpinner()
            exploreVM.activities(latitude: latitude,
                                 longitude: longitude,
                                 completion: { [weak self] result in
                                     self?.stopSpinner()
                                     switch result {
                                     case .success():
                                         self?.locationSearchBar.isHidden = true
                                         self?.showSearchResult()
                                     case .failure(let error):
                                         self?.showError(error)
                                     }
                                 })
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        locationSearchBar.isHidden = false
    }
    
    private func showSearchResult()
    {
        showActivityLocations()
        
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.6,
                       animations: { [weak self] in
                           self?.resultViewPositionY.constant = self?.startPosition ?? 0
                           self?.view.layoutIfNeeded()
                       })
    }
}

extension ExploreViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return exploreVM.activities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        if let cell = cell as? ActivityTableViewCell,
           let activities = exploreVM.activities
        {
            let activity = activities[indexPath.row]
            
            let icon = indexPath.row % 2 == 0 ? UIImage(named: "soccerball") : UIImage(named: "hiking")
            let name = indexPath.row % 2 == 0 ? "Soccer Pickup Game" : "Weekend Hiking"

            cell.config(icon: icon,
                        title: name + " - " + activity.startTime.display(),
                        details: activity.address)
        }
        return cell
    }
}

extension ExploreViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        showActivityDetails()
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

extension ExploreViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        switch status {
        case .denied: // Setting option: Never
            print("LocationManager didChangeAuthorization denied")
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            locationManager?.requestLocation()
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
            locationManager?.requestLocation()
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        locations.forEach { (location) in
            print("LocationManager didUpdateLocations: \(dateFormatter.string(from: location.timestamp)); \(location.coordinate.latitude), \(location.coordinate.longitude)")
        }
    }
  
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager?.stopMonitoringSignificantLocationChanges()
        }
    }
}
