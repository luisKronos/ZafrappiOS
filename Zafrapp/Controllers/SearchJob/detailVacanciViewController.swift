//
//  detailVacanciViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import CoreData

class detailVacanciViewController: ZPMasterViewController {

    @IBOutlet weak var lblPosition: UILabel!
    @IBOutlet weak var lblPlaceAndSalary: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblActivities: UILabel!
    @IBOutlet weak var lblRequirments: UILabel!
    @IBOutlet weak var lblTimeforJob: UILabel!
    @IBOutlet weak var btnVancanciSaved: UIButton!
    @IBOutlet weak var lblMonday: UILabel!
    @IBOutlet weak var lblThursday: UILabel!
    @IBOutlet weak var lblWednesday: UILabel!
    @IBOutlet weak var lblthusday: UILabel!
    @IBOutlet weak var lblFriday: UILabel!
    @IBOutlet weak var lblSaturday: UILabel!
    @IBOutlet weak var lblSunday: UILabel!
    @IBOutlet weak var btnCheck: UIButton!
    
    @IBOutlet weak var imgCompany: UIImageView!
    @IBOutlet weak var lblNameCompany: UILabel!
    @IBOutlet weak var btnPostulated: ZPDesignableUIButton!
    
    var dataVacanci : postulations?
    var bIsSaved = false
    var arrIdSaved = [UpdateProfile]()
    var isHePostulated = false
    var heSavedtheJob = false
    var changeData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
      settupInformation()
      createDays()
        if changeData {
         retriveIDSaved()
        }else {
          changeColor()
        }
     
    }
    
    func changeColor () {
        if dataVacanci?.bisSaved ?? false {
            self.btnCheck.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            self.btnCheck.isEnabled = false
            heSavedtheJob = true
        }
        if dataVacanci?.bIsPostulated ?? false {
            self.btnPostulated.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
             self.btnPostulated.isEnabled = false
             isHePostulated = true
             btnPostulated.setTitle("POSTULADO", for: .normal)
        }
    }
    
    func retriveIDSaved () {
    let placeData = UserDefaults.standard.data(forKey: "IdVacancies\(getIdUserSaved())")
          
    if let placeData = placeData {
      let placeArray = try! JSONDecoder().decode([UpdateProfile].self, from: placeData)
        arrIdSaved = placeArray
        let results = placeArray.filter {$0.strID == dataVacanci?.strVacant}
        if results.count > 0  {
            if results.first?.bisSaved ?? false  {
                self.btnCheck.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                self.btnCheck.isEnabled = false
                heSavedtheJob = true
            }
            if results.first?.bHeApplied ?? false {
                self.btnPostulated.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                self.btnPostulated.isEnabled = false
                isHePostulated = true
                btnPostulated.setTitle("POSTULADO", for: .normal)
            }
            bIsSaved = true
        } else {
           bIsSaved = false
         }
        }
    }
    
    func createDays () {
        let days = dataVacanci?.strSchedule_work
        let monday = checkDay(day: "L", bcheck: false)
        let thursday = checkDay(day: "M", bcheck: false)
        let wednesday = checkDay(day: "W", bcheck: false)
         let thusday = checkDay(day: "J", bcheck: false)
        let friday = checkDay(day: "V", bcheck: false)
        let saturday = checkDay(day: "S", bcheck: false)
        let sunday = checkDay(day: "D", bcheck: false)
        
        let daysReturn = [monday,thursday,wednesday,thusday,friday,saturday,sunday]
        for basedDays in daysReturn {
            if days?.contains(basedDays.strDay ?? "") ?? false{
                basedDays.bCheck = true
            }
        }
        changeColorLabel(label: lblMonday, changeColor: daysReturn.first?.bCheck ?? false)
        changeColorLabel(label: lblThursday, changeColor: daysReturn[1].bCheck ?? false)
        changeColorLabel(label: lblWednesday, changeColor: daysReturn[2].bCheck ?? false)
        changeColorLabel(label: lblthusday, changeColor: daysReturn[3].bCheck ?? false)
        changeColorLabel(label: lblFriday, changeColor: daysReturn[4].bCheck ?? false)
        changeColorLabel(label: lblSaturday, changeColor: daysReturn[5].bCheck ?? false)
         changeColorLabel(label: lblSunday, changeColor: daysReturn.last?.bCheck ?? false)
    }
    
    func changeColorLabel (label : UILabel , changeColor : Bool){
        label.layer.borderWidth = 0.5
        label.layer.borderColor = changeColor ? UIColor.white.cgColor : UIColor.gray.cgColor
        if !changeColor {
          label.backgroundColor =  UIColor.white
        }
        label.textColor = changeColor ? UIColor.white : UIColor.black
       }
    
    func settupInformation () {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        lblPosition.isUserInteractionEnabled = true
        lblPosition.addGestureRecognizer(tap)
        imgCompany.downloaded(from: dataVacanci?.strImage ?? "", contentMode: .scaleToFill)
        lblNameCompany.text = dataVacanci?.strName
        lblDescription.text = dataVacanci?.strDescription
        lblPosition.text = dataVacanci?.strPosition
        lblPlaceAndSalary.text = "\(dataVacanci?.strState ?? "")\n \(dataVacanci?.strRange_Salary ?? "")"
        lblDate.text = dataVacanci?.strPucblishDate
        lblActivities.text = dataVacanci?.strActivities
        lblRequirments.text = dataVacanci?.strRequirements
        lblTimeforJob.text = dataVacanci?.strWorking_time
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        showDetailCompany(data: dataVacanci?.strId_Ingenio ?? "1")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savePlaces()
    }
    
     func showDetailCompany (data: String) {
           let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! ProfileCompanyViewController
           vc.strIdCompany = data
           vc.isIngenio = true
           vc.hideServices = true
           vc.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(vc,
           animated: true)
       }
    
    @IBAction func btnPostulation(_ sender: Any) {
        let cv = getCVSaved()
        if cv.isEmpty {
          performSegue(withIdentifier: "segueGetTheJob", sender: nil)
        }else {
            servicePostulation(Vacante: dataVacanci?.strVacant ?? "", IdUser: getIdUserSaved(), idIngenio: dataVacanci?.strId_Ingenio ?? "")
        }
        
    }
    func ServiceSave (Vacante : String, IdUser : String) {
        self.activityIndicatorBegin()
       let ws = savePosition_WS ()
        ws.savePosition(idVacant: Vacante, idUser : IdUser) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                    self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.btnCheck.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    self.btnCheck.isEnabled = false
                    self.heSavedtheJob = true
                    self.present(ZPAlertGeneric.OneOption(title : "Vacante guardada", message:respService?.strMessage , actionTitle: "Aceptar"),animated: true)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    
    func getIdUserSaved() -> String {
           let getIdUser =  informationClasify.sharedInstance.data
        return  getIdUser?.arrMessage?.strId_user ?? ""
    }

    func getCVSaved() -> String {
            let getIdUser =  informationClasify.sharedInstance.data
           return  getIdUser?.arrMessage?.strCv ?? ""
       }
    
    func servicePostulation (Vacante : String, IdUser : String, idIngenio : String) {
        self.activityIndicatorBegin()
       let ws = jobChoosed_WS ()
        ws.obtainPostulations(idVacante: Int (Vacante) ?? 0, id_user: Int(IdUser) ?? 0, id_ingenio: Int(idIngenio) ?? 0) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                    self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.btnPostulated.setTitle("POSTULADO", for: .normal)
                    self.btnPostulated.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                    self.btnPostulated.isEnabled = false
                    self.isHePostulated = true
                    self.present(ZPAlertGeneric.OneOption(title : "Postulacion Exitosa", message:respService?.strMessage , actionTitle: "Aceptar"),animated: true)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    @IBAction func btnSaveVacancie(_ sender: Any) {
        ServiceSave(Vacante: dataVacanci?.strVacant ?? "", IdUser: getIdUserSaved())
    }
    
    func savePlaces(){
        let newId = UpdateProfile()
        newId.strID = dataVacanci?.strVacant
        newId.bisSaved = heSavedtheJob
        newId.bHeApplied = isHePostulated
        
        if !bIsSaved {
            arrIdSaved.append(newId)
        }else {
            for mov in arrIdSaved {
                if mov.strID == dataVacanci?.strVacant {
                    mov.bisSaved =  heSavedtheJob
                    mov.bHeApplied = isHePostulated
                }
            }
        }
        
        let placesData = try! JSONEncoder().encode(arrIdSaved)
         UserDefaults.standard.set(placesData, forKey: "IdVacancies\(getIdUserSaved())")
     }
}

