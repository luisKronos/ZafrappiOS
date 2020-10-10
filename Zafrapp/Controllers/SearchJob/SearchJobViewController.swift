//
//  SearchJobViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class SearchJobViewController: ZPMasterViewController, UIGestureRecognizerDelegate {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private var emptyTableView: UIView!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var vacancies: [Postulation]? = []
    private var vacanciesFiltered: [Postulation]? = []
    private var isSearching = false
    private var isFilterSelected = false
    private var vacanciSelected: Postulation?
    private var filterOptions = ["Ingenio", "Área de interés", "Salario"]
    private var sortSalaryOptions = ["Mayor a menor", "Menor a mayor"]
    private var filterOptionsSelected: [String] = []
    private var isSectionShown = false
    private var sectionSelected = 0
    
    // MARK: - Computed Propeties
    
    var userIdSaved: String {
        let userIdSaved =  InformationClasify.sharedInstance.data
        return  userIdSaved?.messageResponse?.userId ?? ""
    }
    
    var emailSaved: String {
        let emailSaved =  InformationClasify.sharedInstance.data
        return emailSaved?.messageResponse?.email ?? ""
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        executeService()
        configureTableView()
        swipeDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveIDSaved()
    }
    
    // MARK: - IBActions
    
    @IBAction func filterAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        isSearching = false
        if !button.isSelected {
            button.isSelected = true
            isFilterSelected = true
            tableView.reloadData()
        } else {
            isSectionShown = false
            button.isSelected = false
            isFilterSelected = false
            tableView.reloadData()
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "segueDetailVacanci") {
            let vcDetail = segue.destination as? VacancyDetailViewController
            vcDetail?.modalPresentationStyle = .fullScreen
            vcDetail?.vancancy = vacanciSelected
        }
    }
    
}

// MARK :- Private Methods

private extension SearchJobViewController {
    
    func configureTableView() {
        searchBar.delegate = self
        searchBar.searchTextField.clearButtonMode = .never
        tableView.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func retriveIDSaved() {
        let placeData = UserDefaults.standard.data(forKey: "IdVacancies\(userIdSaved)")
        
        if let placeData = placeData, let placeArray = try? JSONDecoder().decode([UpdateProfile].self, from: placeData) {
            for data in placeArray {
                for dataDowloaded in vacancies ?? [] {
                    if dataDowloaded.vacant == data.strID {
                        dataDowloaded.isSaved = data.bisSaved ?? false
                        dataDowloaded.isPostulated = data.bHeApplied ?? false
                    }
                }
            }
            
        }
        tableView.reloadData()
    }
    
    func swipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        emptyTableView.addGestureRecognizer(swipeDown)
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
    
    func executeService() {
        tableView.isHidden = true
        activityIndicatorBegin()
        let service = PostulationService()
        
        service.obtainPostulations(mail: emailSaved) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: "Sin vacantes", message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.vacancies = respService?.vacants
                    if self.vacancies?.count ?? 0 > 0 {
                        self.tableView.isHidden = false
                    }
                    self.retriveIDSaved()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.tryAgain), animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
}

// MARK: - TableView Delegates

extension SearchJobViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilterSelected {
            if isSectionShown && section == sectionSelected {
                return filterOptionsSelected.count
            } else {
                return 0
            }
        } else {
            if vacancies?.count ?? 0 > 0 {
                if isSearching {
                    return vacanciesFiltered?.count ?? 0
                } else {
                    return vacancies?.count ?? 0
                }
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFilterSelected {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            let title = filterOptionsSelected[indexPath.row]
            cell.textLabel?.text = title
            return cell
        } else {
            let companiescell = tableView.dequeueReusableCell(withIdentifier: "CompaniesTableViewCell", for: indexPath) as? CompaniesTableViewCell ??  CompaniesTableViewCell()
            companiescell.selectionStyle = .none
            if vacancies?.count ?? 0 > 0 {
                var oneVacanci: Postulation?
                if isSearching {
                    oneVacanci = vacanciesFiltered?[indexPath.row]
                } else {
                    oneVacanci = vacancies?[indexPath.row]
                }
                companiescell.dataVacancies = oneVacanci
            }
            return companiescell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFilterSelected {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSectionShown {
            return 40
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UITableViewHeaderFooterView()
        customView.textLabel?.font = UIFont(name:"Poppins-Bold",size:18)
        if isFilterSelected{
            let titleData = filterOptions[section]
            customView.textLabel?.text = titleData
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            customView.tag = section
            tapRecognizer.delegate = self
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.numberOfTouchesRequired = 1
            customView.addGestureRecognizer(tapRecognizer)
        } else {
            customView.textLabel?.text = "Vacantes populares"
        }
        
        return customView
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        sectionSelected = section
        
        switch section {
        case 0:
            filterOptionsSelected = ingenioArray
        case 1:
            filterOptionsSelected = AppConstants.interestAreas
        default:
            filterOptionsSelected = sortSalaryOptions
        }
        isSectionShown = true
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isSectionShown {
            let searchText = filterOptionsSelected[indexPath.row]
            if searchText == "Mayor a menor" {
                vacanciesFiltered =  vacancies?.sorted { $0.salaryMinimum > $1.salaryMinimum }
            } else if searchText == "Menor a mayor"{
                vacanciesFiltered =  vacancies?.sorted { $0.salaryMaximum < $1.salaryMaximum }
            } else {
                vacanciesFiltered = vacancies?.filter({($0.workPlace?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.interestArea?.lowercased().contains(searchText.lowercased()) ?? false) })
            }
            isSearching = true
            isSectionShown = false
            isFilterSelected = false
            tableView.reloadData()
        } else {
            if isSearching {
                vacanciSelected = vacanciesFiltered?[indexPath.row]
            } else {
                vacanciSelected = vacancies?[indexPath.row]
            }
            performSegue(withIdentifier: "segueDetailVacanci", sender: nil)
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchJobViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSectionShown = false
        isFilterSelected = false
        vacanciesFiltered = vacancies?.filter({($0.position?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.workPlace?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.state?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.salaryRange?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.publishedDate?.lowercased().contains(searchText.lowercased()) ?? false) })
        isSearching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        isSectionShown = false
        isFilterSelected = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
