//
//  SearchJob_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class SearchJob_ViewController: ZPMasterViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var vwEmptyTable: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableData: UITableView!
    var arrVacancies : [postulations]? = []
    var arrFilterVacancies : [postulations]? = []
    var isSearching = false
    var isFilterSelect = false
    var vacanciSelected : postulations?
    var optionsFilter = ["Ingenio", "Área de interes", "Salario"]
    var sortSalari = ["Mayor a menor", "Menor a mayor"]
    var arrOptionsFilter : [String] = []
    var bShowSection = false
    var iSectionShow = 0

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveIDSaved()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        executeService()
         settupTable()
        swipeDown()
    }
    
    func getIdUserSaved() -> String {
              let getIdUser =  informationClasify.sharedInstance.data
           return  getIdUser?.arrMessage?.strId_user ?? ""
       }
    
    func retriveIDSaved () {
    let placeData = UserDefaults.standard.data(forKey: "IdVacancies\(getIdUserSaved())")
          
    if let placeData = placeData {
    let placeArray = try! JSONDecoder().decode([UpdateProfile].self, from: placeData)
        for data in placeArray {
            for DataDowload in arrVacancies ?? [] {
                if DataDowload.strVacant == data.strID {
                    DataDowload.bisSaved = data.bisSaved ?? false
                    DataDowload.bIsPostulated = data.bHeApplied ?? false
                }
            }
        }
      
        }
    self.tableData.reloadData()
    }
    
    func settupTable (){
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .never
       tableData.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
        tableData.separatorStyle = .none
        tableData.delegate = self
        tableData.dataSource = self
    }
    
    func swipeDown () {
          let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
             swipeDown.direction = .down
             self.vwEmptyTable.addGestureRecognizer(swipeDown)
      }
      
      @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
      if let swipeGesture = gesture as? UISwipeGestureRecognizer {
          switch swipeGesture.direction {
          case .down:
              executeService()
          default:
              break
          }
       }
      }
    func getEmailSaved() -> String {
           let getEmail =  informationClasify.sharedInstance.data
        return  getEmail?.arrMessage?.strEmail ?? ""
             }
    
    func executeService () {
        self.tableData.isHidden = true
     self.activityIndicatorBegin()
    let ws = getPostulations_WS ()
        ws.obtainPostulations(mail: getEmailSaved()) {[weak self] (respService, error) in
          guard let self = self else { return }
            self.activityIndicatorEnd()
         if (error! as NSError).code == 0 && respService != nil {
             if respService?.strStatus == "BAD" {
                     self.present(ZPAlertGeneric.OneOption(title : "Sin vacantes", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
             }else{
                self.arrVacancies = respService?.allVacants
                if self.arrVacancies?.count ?? 0 > 0 {
                    self.tableData.isHidden = false
                }
                self.retriveIDSaved()
             }
         }else if (error! as NSError).code == -1009 {
           self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Intenta de nuevo"), animated: true)
         }else {
           self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
         }
       }
     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            super.prepare(for: segue, sender: sender)
        if (segue.identifier == "segueDetailVacanci") {
              let vcDetail = segue.destination as? detailVacanciViewController
                vcDetail?.modalPresentationStyle = .fullScreen
                vcDetail?.dataVacanci = vacanciSelected
                }
        }
    
    @IBAction func btnfilter(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        isSearching = false
        if !button.isSelected {
          button.isSelected = true
           isFilterSelect = true
           self.tableData.reloadData()
        }else {
          bShowSection = false
          button.isSelected = false
          isFilterSelect = false
          self.tableData.reloadData()
        }
    }
    
}

extension SearchJob_ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFilterSelect {
            if bShowSection && section == iSectionShow {
                return arrOptionsFilter.count
            }else {
               return 0
            }
        }else {
            if arrVacancies?.count ?? 0 > 0 {
              if isSearching {
                    return arrFilterVacancies?.count ?? 0
                }else {
                return arrVacancies?.count ?? 0
                       }
            }else {
                return 1
                }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFilterSelect {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            let title = arrOptionsFilter[indexPath.row]
            cell.textLabel?.text = title
            return cell
        }else {
            let companiescell = tableData.dequeueReusableCell(withIdentifier: "CompaniesTableViewCell", for: indexPath) as? CompaniesTableViewCell ??  CompaniesTableViewCell()
            companiescell.selectionStyle = .none
                if arrVacancies?.count ?? 0 > 0 {
                    var oneVacanci : postulations?
                    if isSearching {
                        oneVacanci = arrFilterVacancies?[indexPath.row]
                }else {
                      oneVacanci = arrVacancies?[indexPath.row]
                }
                companiescell.dataVacancies = oneVacanci
            }
        return companiescell
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilterSelect {
            return 3
        }else {
            return 1
        }
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if bShowSection {
            return 40
        }else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let customView = UITableViewHeaderFooterView()
          customView.textLabel?.font = UIFont(name:"Poppins-Bold",size:18)
        if isFilterSelect{
            let titleData = optionsFilter[section]
             customView.textLabel?.text = titleData
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
             customView.tag = section
             tapRecognizer.delegate = self
             tapRecognizer.numberOfTapsRequired = 1
             tapRecognizer.numberOfTouchesRequired = 1
             customView.addGestureRecognizer(tapRecognizer)
        }else{
             customView.textLabel?.text = "Vacantes populares"
        }
          
           return customView
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer)
    {
     guard let section = gestureRecognizer.view?.tag else { return }
        iSectionShow = section
        
        switch section {
        case 0:
            arrOptionsFilter = arrIngenio
        case 1:
             arrOptionsFilter = areaDeInteres
        default:
            arrOptionsFilter = sortSalari
        }
        bShowSection = true
        self.tableData.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if bShowSection {
            let searchText = arrOptionsFilter[indexPath.row]
            if searchText == "Mayor a menor" {
                 arrFilterVacancies =  arrVacancies?.sorted { $0.minSalari > $1.minSalari }
            }else if searchText == "Menor a mayor"{
               arrFilterVacancies =  arrVacancies?.sorted { $0.maxSalari < $1.maxSalari }
            }else {
             arrFilterVacancies = arrVacancies?.filter({($0.strWork_Place?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.strInterest_Area?.lowercased().contains(searchText.lowercased()) ?? false) })
            }
             isSearching = true
            bShowSection = false
            isFilterSelect = false
            tableData.reloadData()
        }else {
            if isSearching {
               vacanciSelected = arrFilterVacancies?[indexPath.row]
            }else {
                 vacanciSelected = arrVacancies?[indexPath.row]
                }
             performSegue(withIdentifier: "segueDetailVacanci", sender: nil)
        }
    }
}

extension SearchJob_ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        bShowSection = false
        isFilterSelect = false
        arrFilterVacancies = arrVacancies?.filter({($0.strPosition?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.strWork_Place?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.strState?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.strRange_Salary?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.strPucblishDate?.lowercased().contains(searchText.lowercased()) ?? false) })
          isSearching = true
          tableData.reloadData()
      }

      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
          isSearching = false
          bShowSection = false
          isFilterSelect = false
          self.searchBar.text = ""
          tableData.reloadData()
      }
}
