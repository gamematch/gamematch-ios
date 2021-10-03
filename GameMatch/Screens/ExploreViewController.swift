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
                
        tableView.delegate = self
        tableView.dataSource = self
        
        let pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: #selector(panAction))
        resultView.addGestureRecognizer(pan)
                
        startPosition = resultViewPositionY.constant
        
        mapView.delegate = self
        setupMapView()
        
        showActivityLocations()
        
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
        let initialLocation = CLLocation(latitude: 37.734501728760144, longitude: -121.92823118854375)
        mapView.centerToLocation(initialLocation)
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
        addAnnotation(title: "Soccer Game", name: "soccer-pin", latitude: 37.750603682221815, longitude: -121.91890945029355)
        addAnnotation(title: "Soccer Pickup", name: "soccer-pin", latitude: 37.76680, longitude: -121.95440)
        addAnnotation(title: "Volleyball Game", name: "volleyball-pin", latitude: 37.753040, longitude: -121.895874)
        addAnnotation(title: "Fun Golf", name: "golf-pin", latitude: 37.77166179714824, longitude: -121.93415058834861)
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
            exploreVM.activities(latitude: latitude,
                                 longitude: longitude,
                                 completion: { [weak self] result in
                switch result {
                case .success(let activities):
                    self?.showSearchResult(activities: activities)
                case .failure(let error):
                    self?.showError(error)
                }
            })
        }
    }
    
    private func showSearchResult(activities: [Activity])
    {
        showMessage("Found \(activities.count) activities")

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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath)
        if let cell = cell as? ActivityTableViewCell {
            if indexPath.row % 2 == 0 {
                cell.config(icon: UIImage(named: "soccerball"),
                            title: "Soccer Pickup Game - Today 12:30pm",
                            details: "Rancho Sports Park, San Ramon")
            } else {
                cell.config(icon: UIImage(named: "hiking"),
                            title: "Weekend Hiking - Saturday 8/14/2021",
                            details: "Mt. Dana, Yosemite")
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
