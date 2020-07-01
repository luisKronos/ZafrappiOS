//
//  GetAddress_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class GetAddress_ViewController: ZPMasterViewController , UIGestureRecognizerDelegate{
    
    @IBOutlet weak var vSelection: CustomSegmentedControl!
    @IBOutlet weak var lycViewSelection: NSLayoutConstraint!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var segmentedControllerCustom: UIView!
     @IBOutlet weak var tableAccount: UITableView!
    var titleOptionsCompany = ["Servicio","Ubicacion"]
    var titleOptionsUser = ["Ingenio","Departamento"]
    var isShowSection = false
    var arrOpciones : [String] = []
    var iSectionShow : Int?
    var typeOfCell = 0
    var arrCompanies : [company] = []
    var allUser : [clientData] = []
    var loadUser = false
    var isSerching = false
    var searchText = false
    var arrCompaniesFilter : [company] = []
    var arrUserFilter : [clientData] = []
    var bFiltered = false
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        configTable ()
        executeServiceCompany(Email: getEmailSaved())
        addSegmentedControled()
    }
    
    func getEmailSaved() -> String{
        let getEmail =  informationClasify.sharedInstance.data
        let email = getEmail?.arrMessage?.strEmail
           return email ?? ""
       }
    
    func executeServiceCompany (Email : String?, companyName : String = "", isSearch : Bool = false, section : Int = 0) {
           self.activityIndicatorBegin()
          let ws = getCompany_WS ()
        ws.updateInfoProfile(mail: Email ?? "", companyName: companyName, IsSearch: isSearch, section: section){[weak self] (respService, error) in
                guard let self = self else { return }
               self.activityIndicatorEnd()
               if (error! as NSError).code == 0 && respService != nil {
                   if respService?.strStatus == "BAD" {
                           self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                   }else {
                    if isSearch {
                        self.bFiltered = true
                        self.typeOfCell = 0
                        self.searchText = true
                        self.isSerching = false
                        self.isShowSection = false
                        self.search.searchTextField.isUserInteractionEnabled = true
                        self.arrCompaniesFilter = respService?.allCompanies ?? []
                    }else {
                        self.arrCompanies = respService?.allCompanies ?? []
                        self.loadUser = true
                    }
                    
                    self.tableAccount.reloadData()
                   }
               }else if (error! as NSError).code == -1009 {
                self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar", actionHandler: { service in
                    

                }),animated: true)
               }else {
                 self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
               }
           }
       }
    func executeServiceUser (Email : String?, userName : String = "", isSearch : Bool = false,section: Int = 0) {
           self.activityIndicatorBegin()
           let ws = getUsers_WS ()
        ws.updateInfoProfile(mail: Email ?? "", userName: userName , IsSearch: isSearch, section: section) {[weak self] (respService, error) in
                   guard let self = self else { return }
                  self.activityIndicatorEnd()
                  if (error! as NSError).code == 0 && respService != nil {
                      if respService?.strStatus == "BAD" {
                              self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                      }else {
                        if isSearch {
                            self.typeOfCell = 1
                            self.searchText = true
                            self.isSerching = false
                            self.isShowSection = false
                            self.search.searchTextField.isUserInteractionEnabled = true
                            self.arrUserFilter = respService?.arrClientsData ?? []
                        }else {
                            self.allUser = respService?.arrClientsData ?? []
                            self.loadUser = false
                        }
                        self.tableAccount.reloadData()
                      }
                  }else if (error! as NSError).code == -1009 {
                    self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
                  }else {
                    if section == 0 {
                      self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
                    }else{
                      self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
                    }
                    
                  }
              }
          }
    
    func configTable () {
        tableAccount.separatorStyle = .none
        tableAccount.delegate = self
        tableAccount.dataSource = self
        tableAccount.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
        tableAccount.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func showDetailCompany (data: company) {
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! ProfileCompanyViewController
        vc.strIdCompany = data.strId_client ?? ""
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
        animated: true)
    }
    
    func addSegmentedControled () {
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.segmentedControllerCustom.frame.width , height: self.segmentedControllerCustom.frame.height), buttonTitle: ["Empresas","Contacto"])
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .clear
        self.segmentedControllerCustom.addSubview(codeSegmented)
    }
    
    @IBAction func filterBtn(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
          if !button.isSelected {
            button.isSelected = true
             lycViewSelection.constant = 0
             search.showsCancelButton = false
             isSerching = true
             search.searchTextField.isUserInteractionEnabled = false
            bFiltered = false
             self.tableAccount.reloadData()
          }else {
            search.text = ""
            lycViewSelection.constant = 50
            isSerching = false
            searchText = false
            isShowSection = false
            self.tableAccount.reloadData()
            button.isSelected = false
            search.searchTextField.isUserInteractionEnabled = true
          }
    }
    
}

extension GetAddress_ViewController: CustomSegmentedControlDelegate{
    
    func changeToIndex(index: Int) {
        typeOfCell = index
        if loadUser && typeOfCell == 1 {
            executeServiceUser(Email: getEmailSaved())
        }
        tableAccount.reloadData()
    }
}

extension GetAddress_ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSerching {
            if isShowSection{
                if section == iSectionShow {
                      return arrOpciones.count
                }else{
                     return 0
                  }
            }else {
                return 0
            }
        }else{
            if typeOfCell == 1 {
                if searchText {
                    return arrUserFilter.count
                }else {
                     return allUser.count
                }
            }else {
                if searchText {
                    return arrCompaniesFilter.count
                }else {
                     return arrCompanies.count
                }
                
                }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if  isSerching && typeOfCell == 0 {
            return titleOptionsCompany.count
        }else if isSerching && typeOfCell == 1 {
            return titleOptionsUser.count
        }else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSerching{
            if typeOfCell == 1 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                if isShowSection {
                    let options = arrOpciones[indexPath.row]
                     cell.textLabel?.text = options
                }else {
                     let options = titleOptionsUser[indexPath.row]
                     cell.textLabel?.text = options
                }
                 return cell
            }else {
                let cell = UITableViewCell(style: .value1,reuseIdentifier: "Cell")
                if isShowSection {
                    let options = arrOpciones[indexPath.row]
                     cell.textLabel?.text = options
                }else {
                    let options = titleOptionsCompany[indexPath.row]
                    cell.textLabel?.text = options
                }
                return cell
            }
        }else {
            if typeOfCell == 1 {
                     let Usercell = tableAccount.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
                let userSelection : clientData?
                if searchText {
                    userSelection = arrUserFilter[indexPath.row]
                 }else {
                    userSelection = allUser[indexPath.row]
                 }
                    if let url = URL(string: userSelection?.strImage ?? "") {
                    Usercell.imgUser.downloaded(from: url, contentMode: .scaleAspectFit)
                    }else {
                        
                    }
                     Usercell.client = userSelection
                     Usercell.selectionStyle = .none
                     return Usercell
                 }else {
                     let companiescell = tableAccount.dequeueReusableCell(withIdentifier: "CompaniesTableViewCell", for: indexPath) as? CompaniesTableViewCell ?? CompaniesTableViewCell()
                     let companySel : company?
                    if searchText {
                        companySel = arrCompaniesFilter[indexPath.row]
                    }else {
                         companySel = arrCompanies[indexPath.row]
                    }
                     companiescell.dataCompany = companySel
                     companiescell.selectionStyle = .none
                     return companiescell
                 }
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSerching || isShowSection {
            return 30
        }else{
            if typeOfCell == 1 {
                return 145
            }else {
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if typeOfCell == 0 && !isShowSection {
            if isSerching || bFiltered {
                let companySelected = arrCompaniesFilter[indexPath.row]
                self.showDetailCompany(data: companySelected)
            }else {
                let companySelected = arrCompanies[indexPath.row]
                self.showDetailCompany(data: companySelected)
            }
        }
        if isShowSection {
            let selection = arrOpciones[indexPath.row]
            search.text = selection
            if typeOfCell == 1 {
                if indexPath.section == 0 {
                   executeServiceUser(Email: getEmailSaved(), userName: selection, isSearch: true, section: 1)
                }else {
                   executeServiceUser(Email: getEmailSaved(), userName: selection, isSearch: true, section: 3)
                }
            }else {
                if indexPath.section == 0 {
                   executeServiceCompany(Email: getEmailSaved(), companyName: selection , isSearch: true, section: 3)
                }else {
                    executeServiceCompany(Email: getEmailSaved(), companyName: selection , isSearch: true, section: 1)
                }
               
            }
         }
        }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            var titleforSection = ""
                   if isSerching && typeOfCell == 0 {
                        titleforSection = titleOptionsCompany[section]
                   }else if isSerching && typeOfCell == 1{
                       titleforSection = titleOptionsUser[section]
                   }

                   let v = UITableViewHeaderFooterView()
                      v.textLabel?.text = titleforSection
                      let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                      v.tag = section
                      tapRecognizer.delegate = self
                      tapRecognizer.numberOfTapsRequired = 1
                      tapRecognizer.numberOfTouchesRequired = 1
                      v.addGestureRecognizer(tapRecognizer)
                      return v
       }

    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
       {
        guard let section = gestureRecognizer.view?.tag else { return }
        iSectionShow = section
         isShowSection = true
        if typeOfCell == 0 {
            let titleSelected = titleOptionsCompany[section]
            if titleSelected == "Ubicacion" {
                arrOpciones = ArrEstados
            }else if titleSelected == "Servicio" {
                arrOpciones = arrServicios
            }
        }else {
            let titleSelected = titleOptionsUser[section]
            if titleSelected == "Ingenio" {
                arrOpciones = arrIngenio
            }else if titleSelected == "Departamento" {
                arrOpciones = arrDepartamento
            }
        }
        tableAccount.reloadData()
       }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSerching {
            return 20
        }else {
            return 0
        }
    }
}

extension GetAddress_ViewController : UISearchBarDelegate {
       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         bFiltered = false
         lycViewSelection.constant = 50
         searchBar.showsCancelButton = false
         isSerching = false
         searchText = false
         isShowSection = false
         searchBar.text = ""
         self.tableAccount.reloadData()
    }
    
      func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         lycViewSelection.constant = 0
         searchBar.showsCancelButton = true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = true
        let textToSearch = searchBar.text ?? ""
        if typeOfCell == 1 {
           executeServiceUser(Email: getEmailSaved(), userName: textToSearch, isSearch: true)
        }else {
          executeServiceCompany(Email: getEmailSaved(), companyName: textToSearch , isSearch: true)
        }
    }
}

