//
//  Place.swift
//  QueroConhecer
//
//  Created by Fernanda Brum on 29/04/19.
//  Copyright © 2019 Fernanda Brum. All rights reserved.
//

import Foundation
import CoreLocation

// representa um local retornado pela Apple baseado na pesquisa do user
struct Place : Codable
{
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let address: String
    
    // propriedade computada
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func getFormattedAddress(with placemark: CLPlacemark) -> String
    {
        var address = ""
        
        if let street = placemark.thoroughfare {
            address += street
        }
        
        if let number = placemark.subThoroughfare {
            address += " \(number)"
        }
        
        if let subLocality = placemark.subLocality {
            address += ", \(subLocality)"
        }
        
        if let city = placemark.locality {
            address += "\n\(city)"
        }
        
        if let state = placemark.administrativeArea {
            address += " - \(state)"
        }
        
        if let postalCode = placemark.postalCode {
            address += "\nCEP: \(postalCode)"
        }
        
        if let country = placemark.country {
            address += "\n\(country)"
        }
        
        return address
    }
}

extension Place: Equatable // equatable explica para o swift qual será a regra a ser utilizada para a comparação dos meus objetos
{
    static func ==(lhs: Place, rhs: Place) -> Bool
    {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
