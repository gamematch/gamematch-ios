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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultViewPositionY: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchViewTop: NSLayoutConstraint!
    @IBOutlet weak var searchViewLeft: NSLayoutConstraint!
        
    private let exploreVM = ExploreViewModel()
    
    private var locationManager: CLLocationManager?
    
    private var startPosition: CGFloat = 0
    private var currentPosition: CGFloat = 0
    
    private let pinIdentifier = "pin"

    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.layer.cornerRadius = 5
        searchBar.clipsToBounds = true
                
        tableView.delegate = self
        tableView.dataSource = self
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panAction))
        resultView.addGestureRecognizer(pan)
                
        startPosition = resultViewPositionY.constant
        resultViewPositionY.constant = 800
        
        mapView.delegate = self
        setupMapView()
                
        let tap = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        mapView.addGestureRecognizer(tap)
        
        setupLocationService()
    }
    
    private func setupLocationService()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    @objc private func mapTapped()
    {
        searchBar.resignFirstResponder()
    }
    
    private func setupMapView()
    {
        let initialLocation = CLLocation(latitude: 37.505368, longitude: -122.264192)
        mapView.centerToLocation(initialLocation)
        
        let region = MKCoordinateRegion(center: mapView.centerCoordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
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
    
    private func showActivityLocations()
    {
        let pins = ["soccer-pin", "volleyball-pin", "golf-pin"]
        if let activities = exploreVM.activities {
            for activity in activities {
                addAnnotation(title: "Soccer Game",
                              name: pins.randomElement() ?? "golf-pin",
                              latitude: activity.latitude,
                              longitude: activity.longitude)
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
                                         self?.showSearchResult()
                                     case .failure(let error):
                                         self?.showError(error)
                                     }
                                 })
        }
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
            if indexPath.row % 2 == 0 {
                cell.config(icon: UIImage(named: "soccerball"),
                            title: "Soccer Pickup Game - " + activity.startTime.display(),
                            details: activity.address)
            } else {
                cell.config(icon: UIImage(named: "hiking"),
                            title: "Weekend Hiking - " + activity.startTime.display(),
                            details: activity.address)
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
            print("========= \(annotation.pinImageName) ========")
            showActivityDetails()
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
