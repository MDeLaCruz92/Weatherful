//
//  Location.swift
//  MiWeather
//
//  Created by Michael De La Cruz on 11/12/16.
//  Copyright © 2016 Michael De La Cruz. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double!
    var longitude: Double!
}
