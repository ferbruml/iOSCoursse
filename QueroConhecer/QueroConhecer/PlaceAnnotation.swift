//
//  PlaceAnnotation.swift
//  QueroConhecer
//
//  Created by Fernanda Brum on 29/04/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation
import MapKit

class PlaceAnnotation: NSObject, MKAnnotation
{
    enum PlaceType
    {
        case place
        case poi // point of intereset perto do place
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var type: PlaceType
    var address: String?
    
    init(coordinate: CLLocationCoordinate2D, type: PlaceType)
    {
        self.coordinate = coordinate
        self.type = type
    }
}
