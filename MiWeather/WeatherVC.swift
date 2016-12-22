//
//  WeatherVC.swift
//  MiWeather
//
//  Created by Michael De La Cruz on 11/2/16.
//  Copyright © 2016 Michael De La Cruz. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather = CurrentWeather()
    var forecast: Forecast!
    var forecasts = [Forecast]()
    var urls :URLs!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        
     //   currentWeather = CurrentWeather()
    //    currentWeather.downloadWeatherDetails {
     //       self.downloadForecastData {
      //          self.updateMainUI()
      //      }
      //  }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // locationAuthStatus()
    }
    
    func locationAuthStatus(location:CLLocation) {
            if (location != nil ) {
                urls = URLs(withCoordinate: location.coordinate)
                self.forecasts.removeAll()
                currentWeather.downloadWeatherDetails(weatherUrl:urls.getWeatherUrl) {
                    self.downloadForecastData(forcastUrl:self.urls.getForcastUrl) {
                        self.updateMainUI()
                    }
                }
            } else {
                print("location : \(location) is nil ")
        }
  
}
    
/*
     func locationAuthStatus() {
     //  print(locationManager.location?.coordinate)
     // if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
     if (locationManager.location != nil ) {
     print("here")
     currentLocation = locationManager.location
     Location.sharedInstance.latitude = currentLocation.coordinate.latitude
     Location.sharedInstance.longitude = currentLocation.coordinate.longitude
     currentWeather.downloadWeatherDetails {
     self.downloadForecastData {
     self.updateMainUI()
     }
     }
     } else {
     print("location manager: \(locationManager.location)")
     }
     // } else {
     //   locationManager.requestWhenInUseAuthorization()
     //    locationAuthStatus()
     //}
     }
     */
    func downloadForecastData(forcastUrl:String,completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        let forecastURL = URL(string: forcastUrl)!
        Alamofire.request(forecastURL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    //self.forecasts.remove(at: 0)
                    //Data was blank so we had to reload data
                   // self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = manager.location else {
            return
        }
        print("lat: \(userLocation.coordinate.latitude) , lon:\(userLocation.coordinate.longitude)")
        locationAuthStatus(location: userLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            print(status.rawValue)
        if status == .denied || status == .restricted {
            showAlert(title: "Go to your settings to enable location authorization for this app ;D")
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
          //yay we have location
           print("access")
            locationManager.startUpdatingLocation()
           // locationAuthStatus()
        }
    }

    // Should memorizes these delegates for tableview use
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell
        
        if forecasts.count > indexPath.row + 1 {
            let forecast = forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
        }
     
        return cell
    }
    
    /*
     if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherCell {
     
     let forecast = forecasts[indexPath.row]
     cell.configureCell(forecast: forecast)
     return cell
     } else {
     return WeatherCell()
     }
     */
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)"
        currentWeatherTypeLabel.text = currentWeather.weatherType
        locationLabel.text = currentWeather.cityName
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: dismissAlert)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    // Dimisses the alert
    func dismissAlert(sender: UIAlertAction) {
    }
}

