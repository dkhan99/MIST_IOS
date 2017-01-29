//
//  MapVC.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/27/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import GoogleMaps
let kMapStyle = "[" +
    "  {" +
    "    \"featureType\": \"poi\"," +
    "    \"stylers\": [" +
    "      {" +
    "        \"visibility\": \"off\"" +
    "      }" +
    "    ]" +
    "  }" +
"]"
class MapVC: UIViewController {
    var mapView: GMSMapView!
    @IBOutlet weak var sub: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        let camera = GMSCameraPosition.camera(withLatitude: 33.95536, longitude: -83.37410, zoom: 17.0)
        let position = CLLocationCoordinate2D(latitude: 33.956669, longitude: -83.375192)
        let chapel = GMSMarker(position: position)
        chapel.title = "Chapel"
        mapView = GMSMapView.map(withFrame: sub.bounds, camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(17.0, maxZoom: 20.0)
        mapView.settings.myLocationButton = true
        sub.addSubview(mapView)
        chapel.map = mapView
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 33.953483, longitude: -83.375382))
        path.add(CLLocationCoordinate2D(latitude: 33.956597, longitude: -83.376227))
        path.add(CLLocationCoordinate2D(latitude: 33.957399, longitude: -83.372573))
        path.add(CLLocationCoordinate2D(latitude: 33.953884, longitude: -83.371395))
        path.add(CLLocationCoordinate2D(latitude: 33.953483, longitude: -83.375382))
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeColor = UIColor.red
        rectangle.map=mapView
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("Cannot load style")
        }
        // Do any additional setup after loading the view.
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
