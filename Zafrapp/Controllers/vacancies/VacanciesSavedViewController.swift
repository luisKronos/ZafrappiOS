//
//  VacanciesSavedViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 28/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class VacanciesSavedViewController: ZPMasterViewController {

    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var tableView: UITableView!
    var arrPostulations : [postulations]?
    var arrSaved : [postulations]?
    var postulationsOption = 1
    var saved = 2
    var typeOfData = 0
    var genericArr : [postulations]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        executeService(Status: 2)
        addSegmentedControled()
    }
    
    func addSegmentedControled () {
           let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.viewSelection.frame.width , height: self.viewSelection.frame.height), buttonTitle: ["Mis vacantes marcadas","Mis postulaciones"])
           codeSegmented.delegate = self
           codeSegmented.backgroundColor = .clear
           self.viewSelection.addSubview(codeSegmented)
       }
    
    func configTable () {
           tableView.separatorStyle = .none
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
       }
    
    func getEmailSaved() -> String {
           let getEmail =  informationClasify.sharedInstance.data
        return  getEmail?.arrMessage?.strEmail ?? ""
             }
    
    func getIDUser() -> Int {
        let getIDUser =  informationClasify.sharedInstance.data
        let id = getIDUser?.arrMessage?.strId_user ?? ""
        return Int(id) ?? 0
            }
    
    func showDetailCompany(vacanciSelected : postulations){
           let storyboard = UIStoryboard(name: "searchJob", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! detailVacanciViewController
           vc.dataVacanci = vacanciSelected
           vc.changeData = false
           vc.modalPresentationStyle = .fullScreen
           navigationController?.pushViewController(vc,
           animated: true)
       }
       
    
    func executeService (Status : Int) {
     self.activityIndicatorBegin()
    let ws = getPostulations_WS ()
        ws.obtainPostulations(mail: getEmailSaved(), status:Status, id_user:getIDUser()  ) {[weak self] (respService, error) in
          guard let self = self else { return }
            self.activityIndicatorEnd()
         if (error! as NSError).code == 0 && respService != nil {
             if respService?.strStatus == "BAD" {
                     self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
             }else{
                if  Status == self.saved {
                    self.arrSaved = respService?.allVacants
                    self.genericArr = respService?.allVacants
                }else if Status == self.postulationsOption {
                    self.genericArr = respService?.allVacants
                    self.arrPostulations = respService?.allVacants
                }
            self.tableView.reloadData()
             }
         }else if (error! as NSError).code == -1009 {
           self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Intenta de nuevo", actionHandler: {action in
            self.executeService(Status: Status)}), animated: true)
         }else {
           self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
         }
       }
     }
}

extension VacanciesSavedViewController : CustomSegmentedControlDelegate{
    
    func changeToIndex(index: Int) {
        typeOfData = index
        if index == postulationsOption {
            genericArr = arrPostulations
            self.tableView.reloadData()
        }else {
            genericArr = arrSaved
            self.tableView.reloadData()
        }
        
        if index == postulationsOption && arrPostulations?.count == nil{
           executeService(Status: 1)
        }
    }
}

extension VacanciesSavedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genericArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let companiescell = tableView.dequeueReusableCell(withIdentifier: "CompaniesTableViewCell", for: indexPath) as? CompaniesTableViewCell ?? CompaniesTableViewCell()
        let companySel  = genericArr?[indexPath.row]
        companiescell.dataVacancies = companySel
         companiescell.selectionStyle = .none
        companiescell.imageChecK = true
         return companiescell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = genericArr?[indexPath.row] ?? postulations()
        if typeOfData == 0 {
            selected.bisSaved = true
            selected.bIsPostulated = false
        }else if typeOfData == 1{
            selected.bIsPostulated = true
            selected.bisSaved = false
        }
        
        showDetailCompany(vacanciSelected: selected)
    }
}
