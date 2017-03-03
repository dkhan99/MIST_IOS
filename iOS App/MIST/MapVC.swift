//
//  MapVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/27/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import MapKit
import UIKit

var locations:Array<(name:String, subtitle:String, coordinate:CLLocationCoordinate2D, pin:MISTPin?, image:UIImage?)> = [
("Chapel","⛪️" ,CLLocationCoordinate2D(latitude: 33.956669, longitude: -83.375192), nil, UIImage(named: "chapel")),
    ("North Campus Green","🍔",CLLocationCoordinate2D(latitude: 33.956856, longitude:  -83.374749), nil, UIImage(named: "burger")),
    ("Herty Field","🍔",CLLocationCoordinate2D(latitude: 33.955862, longitude:  -83.375569), nil, UIImage(named: "burger")),
    ("Caldwell Hall","📝",CLLocationCoordinate2D(latitude: 33.954917, longitude: -83.375304), nil, UIImage(named: "paper")),
    ("Sanford Hall","📝",CLLocationCoordinate2D(latitude: 33.953701, longitude: -83.375024), nil, UIImage(named: "paper")),
    ("North Parking Deck","🚘",CLLocationCoordinate2D(latitude: 33.956125, longitude: -83.372546), nil, UIImage(named: "car")),
    ("East Parking Deck","🚘",CLLocationCoordinate2D(latitude: 33.938125, longitude: -83.369314), nil, UIImage(named: "car")),
    ("Classic Center","🏅",CLLocationCoordinate2D(latitude: 33.960552, longitude: -83.372337), nil, UIImage(named: "medal")),
    ("Ramsey Center","🏀",CLLocationCoordinate2D(latitude: 33.937612, longitude: -83.370851), nil, UIImage(named: "ball"))
]

var image:UIImage?
class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    let MISTlocation = CLLocationCoordinate2D(latitude: 33.957000, longitude: -83.374652)
    let distanceSpan = 800.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonItem:MKUserTrackingBarButtonItem = MKUserTrackingBarButtonItem.init(mapView: mapView)
        buttonItem.customView?.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = buttonItem
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(MISTlocation, distanceSpan, distanceSpan), animated: true)
        addPins()
        
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        } else if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            
            if let index = locations.index(where:{($0.subtitle + " " + $0.name) == (annotation as! MISTPin).title }) {
                annotationView?.image = locations[index].image
            }
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView!.annotation = annotation
            if let index = locations.index(where:{($0.subtitle + " " + $0.name) == (annotation as! MISTPin).title }) {
                annotationView?.image = locations[index].image
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let pin = view.annotation as! MISTPin
        let placeMark = MKPlacemark(coordinate: pin.coordinate)
        let destItem = MKMapItem(placemark: placeMark)
        let myLocation = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        let myItem = MKMapItem(placemark: myLocation)
        
        let alert = UIAlertController(title: pin.title, message: "Would you like to navigate to this location?", preferredStyle: .actionSheet)
        let navigateAction = UIAlertAction(title: "Navigate using Maps", style: .default, handler: { action in
            MKMapItem.openMaps(with: [myItem, destItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        })
        alert.addAction(navigateAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(MISTlocation, distanceSpan , distanceSpan), animated: true)
        } else {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 33.937612, longitude: -83.370851), 600, 600), animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segment.selectedSegmentIndex = 0
        self.segChanged(self.segment)
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        let del = UIApplication.shared.delegate
        if let delegate = del as? AppDelegate {
            if let pinName = delegate.showPin {
                if let i = locations.index(where: {$0.name == pinName && $0.pin != nil}) {
                    if locations[i].pin?.title == "Ramsey Center" || locations[i].pin?.title == "East Parking Deck" {
                        self.segment.selectedSegmentIndex = 1
                        self.segChanged(self.segment)
                    } else {
                        self.segment.selectedSegmentIndex = 0
                        self.segChanged(self.segment)
                    }
                    mapView.selectAnnotation(locations[i].pin!, animated: true)
                }
                delegate.showPin = nil
            }
        }
    }
    
    private func addPins() {
        for (index, location) in locations.enumerated() {
            let newPin = MISTPin(title: location.subtitle + " " + location.name, subtitle: "", coordinate: location.coordinate)
            locations[index].pin = newPin
            mapView.addAnnotation(newPin)
        }
    }
    
}
