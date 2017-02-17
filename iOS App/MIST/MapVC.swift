//
//  MapVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/27/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import GoogleMaps
//let kMapStyle = "[" +
//    "  {" +
//    "    \"featureType\": \"poi\"," +
//    "    \"stylers\": [" +
//    "      {" +
//    "        \"visibility\": \"off\"" +
//    "      }" +
//    "    ]" +
//    "  }" +
//"]"
class MapVC: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        let camera = GMSCameraPosition.camera(withLatitude: 33.95536, longitude: -83.37410, zoom: 17.0)
        
        
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        addLocations()
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 33.953483, longitude: -83.375382))
        path.add(CLLocationCoordinate2D(latitude: 33.956597, longitude: -83.376227))
        path.add(CLLocationCoordinate2D(latitude: 33.957399, longitude: -83.372573))
        path.add(CLLocationCoordinate2D(latitude: 33.955504, longitude: -83.371899))
        path.add(CLLocationCoordinate2D(latitude: 33.955439, longitude: -83.372497))
        path.add(CLLocationCoordinate2D(latitude: 33.955913, longitude: -83.373452))
        path.add(CLLocationCoordinate2D(latitude: 33.955488, longitude: -83.375131))
        path.add(CLLocationCoordinate2D(latitude: 33.953626, longitude: -83.374462))
        path.add(CLLocationCoordinate2D(latitude: 33.953468, longitude: -83.375287))
        
        path.add(CLLocationCoordinate2D(latitude: 33.953483, longitude: -83.375382))
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = UIColor.red
        rectangle.strokeWidth = 5
        rectangle.map=mapView
//        do {
//            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
//        } catch {
//            NSLog("Cannot load style")
//        }
        // Do any additional setup after loading the view.
    }
    func addLocations() {
        let chapel = GMSMarker(position: CLLocationCoordinate2D(latitude: 33.956669, longitude: -83.375192))
        chapel.title = "Chapel"
        chapel.map = mapView
        let herty = GMSMarker(position: CLLocationCoordinate2D(latitude: 33.955942, longitude:  -83.375590))
        herty.title = "Herty Field"
        herty.map = mapView
        let caldwell = GMSMarker(position: CLLocationCoordinate2D(latitude: 33.954917, longitude: -83.375304))
        caldwell.title = "Caldwell"
        caldwell.map = mapView
        let sanford = GMSMarker(position: CLLocationCoordinate2D(latitude: 33.953701, longitude: -83.375024))
        sanford.title = "Sanford"
        sanford.map = mapView
        let northDeck = GMSMarker(position: CLLocationCoordinate2D(latitude: 33.956125, longitude: -83.372546))
        northDeck.title = "North Campus Parking Deck"
        northDeck.map = mapView
    }
    func update() {
        let camera = GMSCameraPosition.camera(withLatitude: 33.95536, longitude: -83.37410, zoom: 17.0)
        mapView.animate(to: camera)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func loadView() {
//        // Create a GMSCameraPosition that tells the map to display the
//        // coordinate -33.86,151.20 at zoom level 6.
//        let camera = GMSCameraPosition.camera(withLatitude: 33.95536, longitude: -83.37410, zoom: 17.0)
//        let mapView = GMSMapView.map(withFrame: sub.frame, camera: camera)
//        print(UIScreen.main.bounds.size.height)
//        print(self.tabBarController?.tabBar.frame.size.height)
//        
//        mapView.isMyLocationEnabled = true
//        mapView.setMinZoom(17.0, maxZoom: 20.0)
//        mapView.settings.myLocationButton = true
//        sub = mapView
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
