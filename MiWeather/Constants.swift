//
//  Constants.swift
//  MiWeather
//
//  Created by Michael De La Cruz on 11/9/16.
//  Copyright © 2016 Michael De La Cruz. All rights reserved.
//

import Foundation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "0c478effb593bd383336c8191b18e20d"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&appid=0c478effb593bd383336c8191b18e20d"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=0c478effb593bd383336c8191b18e20d"
