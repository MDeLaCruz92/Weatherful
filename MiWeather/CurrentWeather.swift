//
//  CurrentWeather.swift
//  MiWeather
//
//  Created by Michael De La Cruz on 11/9/16.
//  Copyright © 2016 Michael De La Cruz. All rights reserved.
//
import UIKit
import Alamofire
import CoreLocation

struct URLs {
  var coordinates:CLLocationCoordinate2D?
  init(withCoordinate coordinate:CLLocationCoordinate2D){
    self.coordinates = coordinate
  }
  
  var getWeatherUrl:String {
    guard let cord = self.coordinates else { fatalError() }
    return  "http://api.openweathermap.org/data/2.5/weather?lat=\(cord.latitude)&lon=\(cord.longitude)&appid=0c478effb593bd383336c8191b18e20d"
  }
  
  var getForcastUrl:String   {
    guard let cord = self.coordinates else { fatalError() }
    return "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(cord.latitude)&lon=\(cord.longitude)&cnt=10&mode=json&appid=0c478effb593bd383336c8191b18e20d"
  }
}

class CurrentWeather {
  var _cityName: String!
  var _date: String!
  var _weatherType: String!
  var _currentTemp: Double!
  
  var cityName: String {
    if _cityName == nil {
      _cityName = ""
    }
    return _cityName
  }
  
  var date: String {
    if _date == nil {
      _date = ""
    }
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .none
    let currentDate = dateFormatter.string(from: Date())
    self._date = "Today, \(currentDate)"
    return _date
  }
  
  var weatherType: String {
    if _weatherType == nil {
      _weatherType = ""
    }
    return _weatherType
  }
  
  var currentTemp: Double {
    if _currentTemp == nil {
      _currentTemp = 52.0
    }
    return _currentTemp
  }
  
  func downloadWeatherDetails(weatherUrl:String,completed: @escaping DownloadComplete) {
    //Alamore fire download
    Alamofire.request(weatherUrl).responseJSON { response in
      let result = response.result
      
      if let dict = result.value as? Dictionary<String, AnyObject> {
        if let name = dict["name"] as? String {
          self._cityName = name.capitalized
          print(self._cityName)
        }
        if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
          if let main = weather[0]["main"] as? String {
            self._weatherType = main.capitalized
            print(self._weatherType)
          }
        }
        if let main = dict["main"] as? Dictionary<String, AnyObject> {
          if let currentTemperature = main["temp"] as? Double {
            let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
            let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
            self._currentTemp = kelvinToFarenheit
            print(self._currentTemp)
          }
        }
      }
      completed()
    }
  }
}
