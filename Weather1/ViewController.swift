//
//  ViewController.swift
//  Weather1
//
//  Created by Javeed Rezayee on 2020-05-05.
//  Copyright © 2020 Javeed Rezayee. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "71478de69f29b741e945ab4baa5eb253"
    var lat = 56.877168
    var lon = 14.806784
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 70
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=56.877168&lon=14.806784&appid=71478de69f29b741e945ab4baa5eb253&units=metric").responseJSON {
        response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["description"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                //bakgrunds färg är ljusare om det är dagtid och mörkare på kväll. 
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackground()
                }else{
                    self.setBlueGradientBackground()
                }
            }
        }
                
    }
    //bakgrundsfärg- tåv olika blandning av färger- En för dag och en för natt.(natten är mörkare) 
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 74/255.0, green: 105/255.0, blue: 165/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 207/255.0, green: 186/255.0, blue: 187/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
    }
    
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 25/255.0, green: 38/255.0, blue: 95/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 121/255.0, green: 123/255.0, blue: 138/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor,bottomColor]
        
    }

}

