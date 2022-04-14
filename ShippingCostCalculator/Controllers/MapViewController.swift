//
//  MapViewController.swift
//  ShippingCostCalculator
//
//  Created by Максим Беседин on 16.03.2022.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController {
    
    var routeDistance : Double?
    
    @IBOutlet weak var MapViewOutlet: MKMapView!

    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    @objc let addAdressButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addAdress"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resetButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "resetButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let routeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "routeButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    let stepBack : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stepBack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stepNext : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "stepNext"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var annotationsArray = [MKPointAnnotation]()
    
    let locationManager = CLLocationManager()
    
    func checkAuthorizationStatus() {
      switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse: break
        case .denied: break
        case .notDetermined: break
        case .restricted: break
        case .authorizedAlways: break
      }
    }
    
    
    func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        
      }
    }
    func checkLocationAuthorization() {
      switch CLLocationManager.authorizationStatus() {
      case .authorizedWhenInUse:
        mapView.showsUserLocation = true
       case .denied: // Show alert telling users how to turn on permissions
       break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
      case .restricted: // Show an alert letting them know what’s up
       break
      case .authorizedAlways:
       break
      }
    }
    func checkLocationPermission(){
      
        if CLLocationManager.locationServicesEnabled() {
           // continue to implement here
        } else {
           // Do something to let users know why they need to turn it on.
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        checkLocationServices()
        
        setConstraints()

        addAdressButton.addTarget(self, action: #selector(addAdresButtonTaped), for: .touchUpInside)
    
        routeButton.addTarget(self, action: #selector(routeButtonTaped), for: .touchUpInside)
    
        resetButton.addTarget(self, action: #selector(resetButtonTaped), for: .touchUpInside)
        
        stepBack.addTarget(self, action: #selector(stepBackButtonTaped), for: .touchUpInside)

        stepNext.addTarget(self, action: #selector(stepNexButtonTaped), for: .touchUpInside)
    }
    
    @objc func addAdresButtonTaped(){
        alertAddAdress(title: "Добавить", placeholder: "Введите адрес") { [self] (text) in
            self.setupPlacemark(adressPlace: text)
        }
    }
    
    @objc func routeButtonTaped(){
        createDirectionRequest(startCoordinate: annotationsArray.first?.coordinate, destinationCoordinate: annotationsArray.last?.coordinate)
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    @objc func resetButtonTaped(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
    
    @objc func stepBackButtonTaped(){
        print(routeDistance)
    }
    
    @objc func stepNexButtonTaped(sender: UIButton){
        let calculateController = storyboard?.instantiateViewController(withIdentifier: "CalculatingViewController")
        let newControler = calculateController as! CalculatingViewController
        if self.routeDistance != nil {
            newControler.distance = self.routeDistance
            self.navigationController?.pushViewController(calculateController!, animated: true)
        }
        else
        {
            alertError(title: "Ошибка", message: "Попробуйте еще раз")
        }
        
       
    }
    
    private func setupPlacemark(adressPlace: String){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(adressPlace) { [self] placemarks, error in
            if let error = error {
                print(error)
                alertError(title: "Ошибка", message: "Попробуйте добавить адрес еще раз")
            }
            
            guard let placemarks = placemarks else {return}
            let placemark = placemarks.first
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(adressPlace)"
            guard let plcemarkLocation = placemark?.location else {return}
            annotation.coordinate = plcemarkLocation.coordinate
            annotationsArray.append(annotation)
            
            if annotationsArray.count > 1 {
                routeButton.isHidden = false
                resetButton.isHidden = false
            }
            mapView.showAnnotations(annotationsArray, animated: true)
            }
        
        }
    
    private func createDirectionRequest(startCoordinate: CLLocationCoordinate2D?, destinationCoordinate: CLLocationCoordinate2D?){
        
        if(startCoordinate != nil && destinationCoordinate != nil) {
        let startLocation = MKPlacemark(coordinate: startCoordinate!)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordinate!)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType =  .any
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { responce, error in
            if let error = error {
                print(error)
                return
            }
            guard let responce = responce else {
                self.alertError(title: "Ошибка", message:  "Маршрут недоступен")
                return
                }
            var minRoute = responce.routes[0]
            for route in responce.routes{
                minRoute = (route.distance < minRoute.distance) ? route: minRoute
                }
            self.routeDistance = minRoute.distance
            self.mapView.addOverlay(minRoute.polyline)
            }
        }
        else{
        
          
        }
    }
    
    }

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
}

extension MapViewController {
    
    func setConstraints(){
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])

        mapView.addSubview(addAdressButton)
        NSLayoutConstraint.activate([
            addAdressButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            addAdressButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            addAdressButton.heightAnchor.constraint(equalToConstant:  70),
            addAdressButton.widthAnchor.constraint(equalToConstant: 70)
        ])

        mapView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            resetButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            resetButton.heightAnchor.constraint(equalToConstant:  70),
            resetButton.widthAnchor.constraint(equalToConstant: 70)
        ])

        mapView.addSubview(routeButton)
        NSLayoutConstraint.activate([
            routeButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            routeButton.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 175),
            routeButton.heightAnchor.constraint(equalToConstant:  70),
            routeButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        mapView.addSubview(stepBack)
        NSLayoutConstraint.activate([
            stepBack.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            stepBack.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 20),
            stepBack.heightAnchor.constraint(equalToConstant:  60),
            stepBack.widthAnchor.constraint(equalToConstant: 60)
        ])

        mapView.addSubview(stepNext)
        NSLayoutConstraint.activate([
            stepNext.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -30),
            stepNext.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -20),
            stepNext.heightAnchor.constraint(equalToConstant:  60),
            stepNext.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
}


