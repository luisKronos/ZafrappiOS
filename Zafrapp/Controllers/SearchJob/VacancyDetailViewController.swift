//
//  VacancyDetailViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import CoreData

class VacancyDetailViewController: ZPMasterViewController {
    
    private enum Constants {
        enum Segue {
            static let job = "segueGetTheJob"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var positionLabel: UILabel!
    @IBOutlet private var placeAndSalaryLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var activityLabel: UILabel!
    @IBOutlet private var requirementLabel: UILabel!
    @IBOutlet private var timeForJobLabel: UILabel!
    @IBOutlet private var saveVacancyButton: UIButton!
    @IBOutlet private var mondayLabel: UILabel!
    @IBOutlet private var tuesdayLabel: UILabel!
    @IBOutlet private var wednesdayLabel: UILabel!
    @IBOutlet private var thursdayLabel: UILabel!
    @IBOutlet private var fridayLabel: UILabel!
    @IBOutlet private var saturdayLabel: UILabel!
    @IBOutlet private var sundayLabel: UILabel!
    @IBOutlet private var checkButton: UIButton!
    @IBOutlet private var companyImageView: UIImageView!
    @IBOutlet private var companyNameLabel: UILabel!
    @IBOutlet private var postulatedButton: ZPDesignableUIButton!
    
    // MARK: - Private Properties
    
    private var isSaved = false
    private var idsSaved = [UpdateProfile]()
    private var isPostulated = false
    private var isJobSaved = false
    
    // MARK: - Public Properties
    
    var vancancy: Postulation?
    var isDataChanged = true
    
    // MARK: - Computed Properties
    
    private var userIdSaved: String {
        let userIdSaved = InformationClasify.sharedInstance.data
        return userIdSaved?.messageResponse?.userId ?? ""
    }
    
    private var cvSaved: String {
        let userIdSaved = InformationClasify.sharedInstance.data
        return userIdSaved?.messageResponse?.cv ?? ""
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupInformation()
        createDays()
        if isDataChanged {
            retriveIDSaved()
        } else {
            changeColor()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        savePlaces()
    }
    
    // MARK: - IBActions
    
    @IBAction func postulationAction(_ sender: Any) {
        let cv = cvSaved
        if cv.isEmpty {
            performSegue(withIdentifier: Constants.Segue.job, sender: nil)
        } else {
            servicePostulation(Vacante: vancancy?.vacant ?? "", IdUser: userIdSaved, idIngenio: vancancy?.ingenioId ?? "")
        }
    }
    
    @IBAction func saveVacancyAction(_ sender: Any) {
        serviceSave(vacancy: vancancy?.vacant ?? "", userId: userIdSaved)
    }
    
}

// MARK :- Private Methods

private extension VacancyDetailViewController {
    
    func showDetailCompany(data: String) {
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! CompanyProfileViewController
        vc.companyId = data
        vc.isIngenio = true
        vc.hideServices = true
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeColor() {
        if vancancy?.isSaved ?? false {
            self.checkButton.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            self.checkButton.isEnabled = false
            isJobSaved = true
        }
        if vancancy?.isPostulated ?? false {
            self.postulatedButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
            self.postulatedButton.isEnabled = false
            isPostulated = true
            postulatedButton.setTitle("POSTULADO", for: .normal)
        }
    }
    
    func retriveIDSaved() {
        let placeData = UserDefaults.standard.data(forKey: "IdVacancies\(userIdSaved)")
        
        if let placeData = placeData {
            let placeArray = try! JSONDecoder().decode([UpdateProfile].self, from: placeData)
            idsSaved = placeArray
            let results = placeArray.filter {$0.strID == vancancy?.vacant}
            if !results.isEmpty  {
                if results.first?.bisSaved ?? false  {
                    self.checkButton.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    self.checkButton.isEnabled = false
                    isJobSaved = true
                }
                if results.first?.bHeApplied ?? false {
                    self.postulatedButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                    self.postulatedButton.isEnabled = false
                    isPostulated = true
                    postulatedButton.setTitle("POSTULADO", for: .normal)
                }
                isSaved = true
            } else {
                isSaved = false
            }
        }
    }
    
    func createDays() {
        let days = vancancy?.scheduleWork
        let monday = checkDay(day: "L", bcheck: false)
        let tuesday = checkDay(day: "M", bcheck: false)
        let wednesday = checkDay(day: "W", bcheck: false)
        let thursday = checkDay(day: "J", bcheck: false)
        let friday = checkDay(day: "V", bcheck: false)
        let saturday = checkDay(day: "S", bcheck: false)
        let sunday = checkDay(day: "D", bcheck: false)
        
        let daysReturn = [monday,tuesday,wednesday,thursday,friday,saturday,sunday]
        for basedDays in daysReturn {
            if days?.contains(basedDays.strDay ?? "") ?? false{
                basedDays.bCheck = true
            }
        }
        changeColorLabel(label: mondayLabel, changeColor: daysReturn.first?.bCheck ?? false)
        changeColorLabel(label: tuesdayLabel, changeColor: daysReturn[1].bCheck ?? false)
        changeColorLabel(label: wednesdayLabel, changeColor: daysReturn[2].bCheck ?? false)
        changeColorLabel(label: tuesdayLabel, changeColor: daysReturn[3].bCheck ?? false)
        changeColorLabel(label: fridayLabel, changeColor: daysReturn[4].bCheck ?? false)
        changeColorLabel(label: saturdayLabel, changeColor: daysReturn[5].bCheck ?? false)
        changeColorLabel(label: sundayLabel, changeColor: daysReturn.last?.bCheck ?? false)
    }
    
    func changeColorLabel(label: UILabel , changeColor: Bool){
        label.layer.borderWidth = 0.5
        label.layer.borderColor = changeColor ? UIColor.white.cgColor: UIColor.gray.cgColor
        if !changeColor {
            label.backgroundColor =  .white
        }
        label.textColor = changeColor ? .white: .black
    }
    
    func settupInformation() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        positionLabel.isUserInteractionEnabled = true
        positionLabel.addGestureRecognizer(tap)
        companyImageView.downloaded(from: vancancy?.image ?? "", contentMode: .scaleToFill)
        companyNameLabel.text = vancancy?.name
        descriptionLabel.text = vancancy?.description
        positionLabel.text = vancancy?.position
        placeAndSalaryLabel.text = "\(vancancy?.state ?? "")\n \(vancancy?.salaryRange ?? "")"
        dateLabel.text = vancancy?.publishedDate
        activityLabel.text = vancancy?.activities
        requirementLabel.text = vancancy?.requirements
        timeForJobLabel.text = vancancy?.workingTime
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        showDetailCompany(data: vancancy?.ingenioId ?? "1")
    }
    
    func savePlaces() {
        let newId = UpdateProfile()
        newId.strID = vancancy?.vacant
        newId.bisSaved = isJobSaved
        newId.bHeApplied = isPostulated
        
        if !isSaved {
            idsSaved.append(newId)
        } else {
            for mov in idsSaved {
                if mov.strID == vancancy?.vacant {
                    mov.bisSaved =  isJobSaved
                    mov.bHeApplied = isPostulated
                }
            }
        }
        
        let placesData = try! JSONEncoder().encode(idsSaved)
        UserDefaults.standard.set(placesData, forKey: "IdVacancies\(userIdSaved)")
    }
    
    func serviceSave(vacancy: String, userId: String) {
        activityIndicatorBegin()
        let service = PositionService()
        service.savePosition(idVacant: vacancy, idUser: userId) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.checkButton.backgroundColor = UIColor.white.withAlphaComponent(0.6)
                    self.checkButton.isEnabled = false
                    self.isJobSaved = true
                    self.present(ZPAlertGeneric.oneOption(title: "Vacante guardada", message:respService?.message , actionTitle: AppConstants.String.accept),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func servicePostulation(Vacante: String, IdUser: String, idIngenio: String) {
        self.activityIndicatorBegin()
        let service = JobChoosedService()
        service.obtainPostulations(idVacante: Int (Vacante) ?? 0, id_user: Int(IdUser) ?? 0, id_ingenio: Int(idIngenio) ?? 0) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.postulatedButton.setTitle("POSTULADO", for: .normal)
                    self.postulatedButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                    self.postulatedButton.isEnabled = false
                    self.isPostulated = true
                    self.present(ZPAlertGeneric.oneOption(title: "Postulacion Exitosa", message:respService?.message , actionTitle: AppConstants.String.accept),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
}
