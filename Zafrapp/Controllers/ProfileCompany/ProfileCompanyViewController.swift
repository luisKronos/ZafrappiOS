//
//  ProfileCompanyViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import MapKit

class ProfileCompanyViewController: ZPMasterViewController {

    @IBOutlet weak var imageRound: UIImageView!
    @IBOutlet weak var titleCompany: UILabel!
    @IBOutlet weak var lblWho: UILabel!
    @IBOutlet weak var lblWhere: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var lblOfferJob: UILabel!
    @IBOutlet weak var lblTitleOffer: UILabel!
    @IBOutlet weak var lycChange: NSLayoutConstraint!
    @IBOutlet weak var lycChange2: NSLayoutConstraint!
    
    var strIdCompany = ""
    var locationManager:CLLocationManager!
    var isIngenio = false
    var hideServices = false

    override func viewDidLoad() {
        super.viewDidLoad()
         roundImage()
          executeService(email: getEmailSaved(), idClient: strIdCompany)
        }
    
    override func viewWillAppear(_ animated: Bool) {
          self.determineMyCurrentLocation()
      }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.enableLocationServices()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            break
            
        case .authorizedWhenInUse:
               locationManager.startUpdatingLocation()
            break
            
        case .authorizedAlways:
               locationManager.startUpdatingLocation()
            break
        @unknown default:
            return
        }
    }
    func updateLabel (detail : detailCompany?) {
          imageRound.downloaded(from: detail?.strImage ?? "")
        titleCompany.text = detail?.strName_Contact
        lblWho.text = detail?.strDescription
        lblWhere.text = "\(detail?.strState ?? ""), \(detail?.strMunicipio ?? ""), \(detail?.strStreet ?? ""),\(detail?.strNumber_ST ?? ""), CP. \(detail?.strCP ?? "")"
        if hideServices {
         lblOfferJob.text = ""
         lblTitleOffer.text = ""
            lycChange.constant = 0
            lycChange2.constant = 0
        }else {
         lblOfferJob.text = detail?.strService
        }
       
        var otherPlace = ["19.3014924","-99.20509"]
        let placeService = detail?.strMaps?.components(separatedBy: ",")
        if  !(detail?.strMaps?.isEmpty ?? false){
            otherPlace = placeService ?? otherPlace
        }
        let alt = Double(otherPlace.first ?? "19.286147105572876")!
        let lat = Double(otherPlace.last ?? "-99.18195409079117")!
        let distanceSpan : CLLocationDegrees = 1000
        let bsuCSCampuesLocation : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:alt , longitude:lat)
             
       map.setRegion(MKCoordinateRegion(center: bsuCSCampuesLocation, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan), animated: true)
        let bsuClassPin = BSuanitation(title: "", subtitle: "", coordinate: bsuCSCampuesLocation)
         map.addAnnotation(bsuClassPin)
    }
    
    func getEmailSaved() -> String{
       let getEmail =  informationClasify.sharedInstance.data
        let email = getEmail?.arrMessage?.strEmail
        return email ?? ""
    }
    
    func executeService (email:String, idClient : String) {
        self.activityIndicatorBegin()
       let ws = ProfileCompany_WS ()
        ws.updateInfoProfile(mail: email, clienID: idClient, isIngenio: isIngenio) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.updateLabel(detail: respService?.detailCompany)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    func executeServiceIngenio(idIngenio : String) {
        self.activityIndicatorBegin()
       let ws = getIngenio_WS ()
        ws.getDataIngenio(Id_Ingenio: idIngenio){[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.updateLabel(detail: respService?.detailCompany)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }

    func roundImage () {
        imageRound.layer.cornerRadius = imageRound.frame.height / 2
        imageRound.layer.borderColor = UIColor.white.cgColor
        imageRound.layer.borderWidth = 1
    }
}

extension ProfileCompanyViewController : MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           let userLocation:CLLocation = locations[0] as CLLocation
           
           // Call stopUpdatingLocation() to stop listening for location updates,
           // other wise this function will be called every time when user location changes.
           
           // manager.stopUpdatingLocation()
           
           print("user latitude = \(userLocation.coordinate.latitude)")
           print("user longitude = \(userLocation.coordinate.longitude)")
         
           
           let posicionnueva : CLLocationCoordinate2D = CLLocationCoordinate2D (latitude:userLocation.coordinate.latitude , longitude:userLocation.coordinate.longitude )
           
           
           let nuevopunto = BSuanitation(title: "title", subtitle: "subtitle", coordinate: posicionnueva)
           map.addAnnotation(nuevopunto)
           
           
       }
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
 
class BSuanitation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, subtitle : String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }

    
}
