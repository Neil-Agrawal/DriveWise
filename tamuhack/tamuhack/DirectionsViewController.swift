//
//  DirectionsViewController.swift
//  tamuhack
//
//  Created by Yesh N on 1/29/23.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController {
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    private let cellIdentifier = "DirectionsCell"
    private let distanceFormatter = MKDistanceFormatter()
    
    private let route: Route
    
    private var mapRoutes: [MKRoute] = []
    private var totalTravelTime: TimeInterval = 0
    private var totalDistance: CLLocationDistance = 0
    
    private var groupedRoutes: [(startItem: MKMapItem, endItem: MKMapItem)] = []
    
    
    @IBOutlet weak var suggest1: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var city1: UILabel!
    @IBOutlet weak var rc1: UILabel!
    @IBOutlet weak var v1: UILabel!
    @IBOutlet weak var line2: UILabel!
    @IBOutlet weak var city2: UILabel!
    @IBOutlet weak var rc2: UILabel!
    @IBOutlet weak var v2: UILabel!
    @IBOutlet weak var line3: UILabel!
    
    @IBOutlet weak var FElabel: UILabel!
    @IBOutlet weak var civicimg: UIImageView!
    @IBOutlet weak var porscheimg: UIImageView!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var feimg: UIImageView!
    
    
    init(route: Route) {
    self.route = route
    
    super.init(nibName: String(describing: DirectionsViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()

      groupAndRequestDirections()

      headerLabel.text = route.label



      mapView.delegate = self
      mapView.showAnnotations(route.annotations, animated: false)
        
    let session = URLSession.shared
    let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Centerville?key=92UWRG63DDMRXS8CNDXKDP56C")!

    let weatherTask = session.dataTask(with: url) { [self] (data, response, error) in
        guard let data = data else { return }
        let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
        
        print("Weather forecast for: weather.resolvedAddress")
        if(weather.days[0].description.contains("sun")){
            rc2.text = "Road Conditions: Dry"
            v2.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
        else if(weather.days[0].description.contains("cloud")){
            rc2.text = "Road Conditions: Dry"
            v2.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
        else if(weather.days[0].description.contains("rain")){
            rc2.text = "Road Conditions: Wet"
            v2.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
    }
    weatherTask.resume()
        
    let session2 = URLSession.shared
    let url2 = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/Ennis?key=92UWRG63DDMRXS8CNDXKDP56C")!

    let weatherTask2 = session2.dataTask(with: url2) { [self] (data, response, error) in
        guard let data = data else { return }
        let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
        
        print("Weather forecast for: weather.resolvedAddress")
        if(weather.days[0].description.contains("sun")){
            rc1.text = "Road Conditions: Dry"
            v1.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
        else if(weather.days[0].description.contains("cloud")){
            rc1.text = "Road Conditions: Dry"
            v1.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
        else if(weather.days[0].description.contains("rain")){
            rc1.text = "Road Conditions: Wet"
            v1.text = "Visibility: " + String(weather.days[0].visibility) + " miles"
        }
    }
    weatherTask2.resume()
        
    

    }
    
    private func groupAndRequestDirections() {
      guard let firstStop = route.stops.first else {
        return
      }

      groupedRoutes.append((route.origin, firstStop))

      if route.stops.count == 2 {
        let secondStop = route.stops[1]

        groupedRoutes.append((firstStop, secondStop))
        groupedRoutes.append((secondStop, route.origin))
      }

      fetchNextRoute()
        DispatchQueue.main.asyncAfter(deadline:
              .now() + 4) {
                  self.line1.isHidden = false
                  self.line2.isHidden = false
                  self.city1.isHidden = false
                  self.line3.isHidden = false
                  self.city2.isHidden = false
                  self.rc1.isHidden = false
                  self.rc2.isHidden = false
                  self.v1.isHidden = false
                  self.v2.isHidden = false
                  self.suggest1.isHidden = false
                  
                  self.FElabel.isHidden = false
                  self.civicimg.isHidden = false
                  self.porscheimg.isHidden = false
                  self.score1.isHidden = false
                  self.score2.isHidden = false
                  self.feimg.isHidden = false
            
        }
    }
    
    private func fetchNextRoute() {
      guard !groupedRoutes.isEmpty else {
        activityIndicatorView.stopAnimating()
        return
      }

      let nextGroup = groupedRoutes.removeFirst()
      let request = MKDirections.Request()

      request.source = nextGroup.startItem
      request.destination = nextGroup.endItem

      let directions = MKDirections(request: request)

      directions.calculate { response, error in
        guard let mapRoute = response?.routes.first else {
          self.infoLabel.text = error?.localizedDescription
          self.activityIndicatorView.stopAnimating()
              
          return
        }

        self.updateView(with: mapRoute)
        self.fetchNextRoute()
      }
    }
    
    private func updateView(with mapRoute: MKRoute) {
      let padding: CGFloat = 8
      mapView.addOverlay(mapRoute.polyline)
      mapView.setVisibleMapRect(
        mapView.visibleMapRect.union(
          mapRoute.polyline.boundingMapRect
        ),
        edgePadding: UIEdgeInsets(
          top: 0,
          left: padding,
          bottom: padding,
          right: padding
        ),
        animated: true
      )

      totalDistance += mapRoute.distance
      totalTravelTime += mapRoute.expectedTravelTime

      let informationComponents = [
        totalTravelTime.formatted,
        "• \(distanceFormatter.string(fromDistance: totalDistance))"
      ]
      infoLabel.text = informationComponents.joined(separator: " ")

      mapRoutes.append(mapRoute)
    }
    
    
    @IBAction func dismissScreen(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}

extension DirectionsViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)

    renderer.strokeColor = .systemBlue
    renderer.lineWidth = 3

    return renderer
  }
}
