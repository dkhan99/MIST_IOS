//
//  MISTPin.swift
//  MIST
//
//  Created by Muhammad Doukmak on 2/23/17.
//  Copyright © 2017 Muhammad Doukmak. All rights reserved.
//

import MapKit

class MISTPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}
