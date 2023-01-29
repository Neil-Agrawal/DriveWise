//
//  HomePageViewController.swift
//  tamuhack
//
//  Created by Yesh N on 1/28/23.
//

import UIKit
import MapKit
import CoreLocation

struct WeatherData: Decodable {
         let resolvedAddress: String
         let days: [WeatherDays]
}

struct WeatherDays: Decodable {
        let datetime: String
        let tempmax: Double
        let tempmin: Double
        let description: String
        let visibility: Double
}

class HomePageViewController: UIViewController {

    @IBOutlet var profilePic: UIImageView!
    var name = ""
    @IBOutlet var nameField: UILabel!
    
    
    @IBOutlet weak var car1: UIButton!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var status1: UIImageView!
    
    @IBOutlet weak var car2: UIButton!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var status2: UIImageView!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var road: UILabel!
    @IBOutlet weak var visibikity: UILabel!
    
    let colorvar = UIColor(red: 67/255.0, green: 70/255.0, blue: 75/255.0, alpha: 1)
    
    @IBOutlet private var originTextField: UITextField!
    @IBOutlet private var stopTextField: UITextField!
    @IBOutlet private var calculateButton: UIButton!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    private var editingTextField: UITextField?
    private var currentRegion: MKCoordinateRegion?
    private var currentPlace: CLPlacemark?

    private let locationManager = CLLocationManager()
    private let completer = MKLocalSearchCompleter()

    private let defaultAnimationDuration: TimeInterval = 0.25
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculateButton.stylize()

        completer.delegate = self

        beginObserving()
        configureGestures()
//        configureTextFields()
        attemptLocationAccess()
        hideSuggestionView(animated: false)
        
        //profile pic
        profilePic.image = UIImage(named: "guest1")
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        profilePic.layer.masksToBounds = true
        profilePic.layer.borderWidth = 1.5
        profilePic.layer.borderColor = UIColor.black.cgColor
        
        //name
        nameField.text = "Welcome, \(name)!"
        
        //button1
        car1.layer.borderWidth = 1
        car1.layer.borderColor = UIColor.darkGray.cgColor
        car1.layer.cornerCurve = .continuous
        car1.clipsToBounds = true
        car1.layer.cornerRadius = 10
        car1.layer.backgroundColor = colorvar.cgColor
        
        car2.layer.borderWidth = 1
        car2.layer.borderColor = UIColor.darkGray.cgColor
        car2.layer.cornerCurve = .continuous
        car2.clipsToBounds = true
        car2.layer.cornerRadius = 10
        car2.layer.backgroundColor = colorvar.cgColor
        
        img1.image = UIImage(named: "civic2")
        img1.layer.cornerRadius = 5
        img1.clipsToBounds = true
        img1.layer.masksToBounds = true
        
        
        img2.image = UIImage(named: "porsche")
        img2.layer.cornerRadius = 5
        img2.clipsToBounds = true
        img2.layer.masksToBounds = true


        status1.image = UIImage(named: "yes")
        status2.image = UIImage(named: "no")
        
        let session = URLSession.shared
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/CollegeStation?key=92UWRG63DDMRXS8CNDXKDP56C")!

        let weatherTask = session.dataTask(with: url) { [self] (data, response, error) in
            guard let data = data else { return }
            let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
            
            print("Weather forecast for: weather.resolvedAddress")
            if(weather.days[0].description.contains("sun")){
//                weatherImage.image = UIImage(named: "sun")
                weatherImage.image = UIImage(systemName: "sun")?.withTintColor(.yellow, renderingMode: .alwaysOriginal)
                road.text = "Dry"
                visibikity.text = String(weather.days[0].visibility) + " miles"
            }
            else if(weather.days[0].description.contains("cloud")){
//                weatherImage.image = UIImage(named: "cloud")
                weatherImage.image = UIImage(systemName: "cloud.fill")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                road.text = "Dry"
                visibikity.text = String(weather.days[0].visibility) + " miles"
            }
            else if(weather.days[0].description.contains("rain")){
                weatherImage.image = UIImage(named: "rain")
                road.text = "Wet"
                visibikity.text = String(weather.days[0].visibility) + " miles"
            }
        }
        weatherTask.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "honda"{
            let vc = segue.destination as? CarDetailsViewController
            vc?.carnum = 1
            
            vc?.carBat = "yes"
            vc?.carOil = "yes"
            vc?.carFluid = "yes"
            vc?.carTire = "yes"
            
        }
        
        if segue.identifier == "porsche"{
            let vc = segue.destination as? CarDetailsViewController
            vc?.carnum = 2
            
            vc?.carBat = "yes"
            vc?.carFluid = "warning"
            vc?.carTire = "yes"
            vc?.carOil = "no"
        }
    }
    
    private func configureGestures() {
      view.addGestureRecognizer(
        UITapGestureRecognizer(
          target: self,
          action: #selector(handleTap(_:))
        )
      )
      
    }
    
//    private func configureTextFields() {
//      originTextField.delegate = self
//      stopTextField.delegate = self
//
//      originTextField.addTarget(
//        self,
//        action: #selector(textFieldDidChange(_:)),
//        for: .editingChanged
//      )
//      stopTextField.addTarget(
//        self,
//        action: #selector(textFieldDidChange(_:)),
//        for: .editingChanged
//      )
//
//    }
    
    private func attemptLocationAccess() {
      guard CLLocationManager.locationServicesEnabled() else {
        return
      }

      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      locationManager.delegate = self

      if CLLocationManager.authorizationStatus() == .notDetermined {
        locationManager.requestWhenInUseAuthorization()
      } else {
        locationManager.requestLocation()
      }
    }
    
    private func hideSuggestionView(animated: Bool) {


      guard animated else {
        view.layoutIfNeeded()
        return
      }

      UIView.animate(withDuration: defaultAnimationDuration) {
        self.view.layoutIfNeeded()
      }
    }
    
    private func showSuggestion(_ suggestion: String) {


      UIView.animate(withDuration: defaultAnimationDuration) {
        self.view.layoutIfNeeded()
      }
    }

    private func presentAlert(message: String) {
      let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

      present(alertController, animated: true)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
      let gestureView = gesture.view
      let point = gesture.location(in: gestureView)

      guard
        let hitView = gestureView?.hitTest(point, with: nil),
        hitView == gestureView
        else {
          return
      }

      view.endEditing(true)
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        view.endEditing(true)

        calculateButton.isEnabled = false
        activityIndicatorView.startAnimating()

        let segment: RouteBuilder.Segment?
        if let currentLocation = currentPlace?.location {
          segment = .location(currentLocation)
        } else if let originValue = originTextField.contents {
          segment = .text(originValue)
        } else {
          segment = nil
        }

        let stopSegments: [RouteBuilder.Segment] = [
          stopTextField.contents,
        ]
        .compactMap { contents in
          if let value = contents {
            return .text(value)
          } else {
            return nil
          }
        }

        guard
          let originSegment = segment,
          !stopSegments.isEmpty
          else {
            presentAlert(message: "Please select an origin and at least 1 stop.")
            activityIndicatorView.stopAnimating()
            calculateButton.isEnabled = true
            return
        }

        RouteBuilder.buildRoute(
          origin: originSegment,
          stops: stopSegments,
          within: currentRegion
        ) { result in
          self.calculateButton.isEnabled = true
          self.activityIndicatorView.stopAnimating()

          switch result {
          case .success(let route):
//            performSegue(withIdentifier: "mapSegue", sender: <#T##Any?#>)
            let viewController = DirectionsViewController(route: route)
            self.present(viewController, animated: true)

          case .failure(let error):
            let errorMessage: String

            switch error {
            case .invalidSegment(let reason):
              errorMessage = "There was an error with: \(reason)."
            }

            self.presentAlert(message: errorMessage)
          }
        }
    }
    
    private func beginObserving() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(handleKeyboardFrameChange(_:)),
        name: UIResponder.keyboardWillChangeFrameNotification,
        object: nil
      )
    }

    @objc private func handleKeyboardFrameChange(_ notification: Notification) {
      guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
        return
      }

      let viewHeight = view.bounds.height - view.safeAreaInsets.bottom
      let visibleHeight = viewHeight - frame.origin.y
      

      UIView.animate(withDuration: defaultAnimationDuration) {
        self.view.layoutIfNeeded()
      }
    }
    
    @IBAction func unwindToHome(unwindSegue: UIStoryboardSegue){
        
    }
}

extension HomePageViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    hideSuggestionView(animated: true)

    if completer.isSearching {
      completer.cancel()
    }

    editingTextField = textField
  }
}

// MARK: - CLLocationManagerDelegate

extension HomePageViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    guard status == .authorizedWhenInUse else {
      return
    }

    manager.requestLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let firstLocation = locations.first else {
      return
    }

    let commonDelta: CLLocationDegrees = 25 / 111 // 1/111 = 1 latitude km
    let span = MKCoordinateSpan(latitudeDelta: commonDelta, longitudeDelta: commonDelta)
    let region = MKCoordinateRegion(center: firstLocation.coordinate, span: span)

    currentRegion = region
    completer.region = region

    CLGeocoder().reverseGeocodeLocation(firstLocation) { places, _ in
      guard let firstPlace = places?.first, self.originTextField.contents == nil else {
        return
      }

      self.currentPlace = firstPlace
      self.originTextField.text = firstPlace.abbreviation
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Error requesting location: \(error.localizedDescription)")
  }
}

// MARK: - MKLocalSearchCompleterDelegate

extension HomePageViewController: MKLocalSearchCompleterDelegate {
  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
    guard let firstResult = completer.results.first else {
      return
    }

    showSuggestion(firstResult.title)
  }

  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
    print("Error suggesting a location: \(error.localizedDescription)")
  }
}

