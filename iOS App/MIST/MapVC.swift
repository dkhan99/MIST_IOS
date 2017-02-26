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
    ("Chapel Field","🍔",CLLocationCoordinate2D(latitude: 33.956454, longitude:  -83.375147), nil, UIImage(named: "burger")),
    ("Caldwell","🏆",CLLocationCoordinate2D(latitude: 33.954917, longitude: -83.375304), nil, UIImage(named: "troph")),
    ("Sanford","🏆",CLLocationCoordinate2D(latitude: 33.953701, longitude: -83.375024), nil, UIImage(named: "troph")),
    ("North Parking Deck","🚘",CLLocationCoordinate2D(latitude: 33.956125, longitude: -83.372546), nil, UIImage(named: "car")),
    ("East Parking Deck","🚘",CLLocationCoordinate2D(latitude: 33.938125, longitude: -83.369314), nil, UIImage(named: "car")),
    ("Classic Center","🏅",CLLocationCoordinate2D(latitude: 33.960552, longitude: -83.372337), nil, UIImage(named: "medal")),
    ("Ramsey Student Center","🏀",CLLocationCoordinate2D(latitude: 33.937612, longitude: -83.370851), nil, UIImage(named: "ball"))
]

var image:UIImage?
class MapVC: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    let MISTlocation = CLLocationCoordinate2D(latitude: 33.957000, longitude: -83.374652)
    let distanceSpan = 2500.0
    
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
        let navigateAction = UIAlertAction(title: "Navigate in Maps", style: .default, handler: { action in
            MKMapItem.openMaps(with: [myItem, destItem], launchOptions: [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving])
        })
        alert.addAction(navigateAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction func segChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(MISTlocation, 750, 750), animated: true)
        } else {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 33.937612, longitude: -83.370851), 600, 600), animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segment.selectedSegmentIndex = 0
        self.segChanged(self.segment)
        
        let del = UIApplication.shared.delegate
        if let delegate = del as? AppDelegate {
            if let pinName = delegate.showPin {
                print(pinName)
                if let i = locations.index(where: {$0.name == pinName && $0.pin != nil}) {
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
