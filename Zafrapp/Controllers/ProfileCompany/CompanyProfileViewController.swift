//
//  ProfileCompanyViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 02/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import MapKit

class CompanyProfileViewController: ZPMasterViewController {
    
    @IBOutlet private var roundImageView: UIImageView!
    @IBOutlet private var companyTitleLabel: UILabel!
    @IBOutlet private var whoLabel: UILabel!
    @IBOutlet private var whereLabel: UILabel!
    @IBOutlet private var mapView: MKMapView!
    @IBOutlet private var jobOfferLabel: UILabel!
    @IBOutlet private var offerJobLabel: UILabel!
    @IBOutlet private var lycChangeConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var locationManager: CLLocationManager!
    private var cellPhone = ""
    
    private var emailSaved: String {
        let getEmail =  InformationClasify.sharedInstance.data
        let email = getEmail?.messageResponse?.email
        return email ?? ""
    }
    
    // MARK: - Public Properties
    
    var isIngenio = false
    var hideServices = false
    var companyId = ""
    
    // MARK: - View Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundImage()
        executeService(email: emailSaved, clientId: companyId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.determineMyCurrentLocation()
    }
    
    // MARK: - IBActions
    
    @IBAction func whatsAppAction(_ sender: Any) {
        openWhatsapp(number: cellPhone)
    }
    
}

// MARK: - Private Methods

private extension CompanyProfileViewController {
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        enableLocationServices()
        
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
    
    func updateLabel(detail: CompanyDetail?) {
        roundImageView.downloaded(from: detail?.image ?? "")
        companyTitleLabel.text = detail?.contractName
        whoLabel.text = detail?.description
        whereLabel.text = "\(detail?.state ?? ""), \(detail?.suburb ?? ""), \(detail?.street ?? ""),\(detail?.stNumber ?? ""), CP. \(detail?.zip ?? "")"
        cellPhone = detail?.telephone ?? ""
        if hideServices {
            jobOfferLabel.text = ""
            offerJobLabel.text = ""
            lycChangeConstraint.constant = 0
        } else {
            jobOfferLabel.text = detail?.service
        }
        
        var otherPlace = ["19.3014924","-99.20509"]
        let placeService = detail?.map?.components(separatedBy: ",")
        if  !(detail?.map?.isEmpty ?? false){
            otherPlace = placeService ?? otherPlace
        }
        let alt = Double(otherPlace.first ?? "19.286147105572876")!
        let lat = Double(otherPlace.last ?? "-99.18195409079117")!
        let distanceSpan: CLLocationDegrees = 1000
        let bsuCSCampuesLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:alt , longitude:lat)
        
        mapView.setRegion(MKCoordinateRegion(center: bsuCSCampuesLocation, latitudinalMeters: distanceSpan, longitudinalMeters: distanceSpan), animated: true)
        let bsuClassPin = BSuanitation(title: "", subtitle: "", coordinate: bsuCSCampuesLocation)
        mapView.addAnnotation(bsuClassPin)
    }
    
    func executeService(email:String, clientId: String) {
        activityIndicatorBegin()
        let service = ProfileCompanyService()
        
        service.updateInfoProfile(mail: email, clienID: clientId, isIngenio: isIngenio) {[weak self] (response, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            
            if let error = error {
                let nserror = error as NSError
                
                if nserror.code == 0 && response != nil {
                    if response?.status == AppConstants.ErrorCode.bad {
                        self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: response?.message, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                            self.navigationController?.popViewController(animated: true)
                        } ),animated: true)
                    } else {
                        self.updateLabel(detail: response?.companyDetail)
                    }
                } else if nserror.code == AppConstants.ErrorCode.noInternetConnection {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                        self.navigationController?.popViewController(animated: true)
                    } ),animated: true)
                }
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                    self.navigationController?.popViewController(animated: true)
                } ),animated: true)
            }
        }
    }
    
    func executeServiceIngenio(idIngenio: String) {
        self.activityIndicatorBegin()
        let service = IngenioService()
        
        service.getDataIngenio(Id_Ingenio: idIngenio){[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                        self.navigationController?.popViewController(animated: true)
                    } ),animated: true)
                } else {
                    self.updateLabel(detail: respService?.companyDetail)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept,actionHandler:{ (_) in
                    self.navigationController?.popViewController(animated: true)
                } ),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                    self.navigationController?.popViewController(animated: true)
                } ),animated: true)
            }
        }
    }
    
    func openWhatsapp(number:String){
        let urlWhats = "whatsapp://send?phone=+52\(number)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    
    func roundImage() {
        roundImageView.layer.cornerRadius = roundImageView.frame.height / 2
        roundImageView.layer.borderColor = UIColor.white.cgColor
        roundImageView.layer.borderWidth = 1
    }
}

// MARK: - Location Delegates

extension CompanyProfileViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        
        let posicionnueva: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude:userLocation.coordinate.latitude , longitude:userLocation.coordinate.longitude )
        
        
        let nuevopunto = BSuanitation(title: "title", subtitle: "subtitle", coordinate: posicionnueva)
        mapView.addAnnotation(nuevopunto)
        
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    
}
