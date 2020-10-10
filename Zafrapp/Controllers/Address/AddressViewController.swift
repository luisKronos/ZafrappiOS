//
//  AddressViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class AddressViewController: ZPMasterViewController , UIGestureRecognizerDelegate{
    
    @IBOutlet private var emptyView: UIView!
    @IBOutlet private var selectionSegmentedControl: CustomSegmentedControl!
    @IBOutlet private var lycSelectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var segmentedControllerCustomView: UIView!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var companyOptionsTitle = ["Servicio","Ubicación"]
    private var titleOptionsUser = ["Ingenio","Departamento"]
    private var isSectionShown = false
    private var options: [String] = []
    private var sectionShown: Int?
    private var cellType = 0
    private var companies: [Company] = []
    private var allUsers: [ClientData] = []
    private var isUserLoaded = false
    private var isSerching = false
    private var isTextSearched = false
    private var companiesFiltered: [Company] = []
    private var usersFiltered: [ClientData] = []
    private var isFiltered = false
    
    // MARK: - Computed Properties
    
    var emailSaved: String {
        let data = InformationClasify.sharedInstance.data
        let email = data?.messageResponse?.email
        return email ?? ""
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        searchBar.delegate = self
        configureTableView()
        executeServiceCompany(email: emailSaved)
        addSegmentedControled()
        swipeDown()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectionSegmentedControl.setNeedsDisplay()
    }
    // MARK: - IBActions
    
    @IBAction func filterAction(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        if !button.isSelected {
            button.isSelected = true
            lycSelectionViewConstraint.constant = 0
            searchBar.showsCancelButton = false
            isSerching = true
            searchBar.searchTextField.isUserInteractionEnabled = false
            isFiltered = false
            tableView.reloadData()
        } else {
            searchBar.text = ""
            lycSelectionViewConstraint.constant = 50
            isSerching = false
            isTextSearched = false
            isSectionShown = false
            tableView.reloadData()
            button.isSelected = false
            searchBar.searchTextField.isUserInteractionEnabled = true
        }
    }
    
}

// MARK :- Private Methods

private extension AddressViewController {
    
    func swipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.emptyView.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                if cellType == 1 {
                    executeServiceUser(email: emailSaved)
                } else {
                    executeServiceCompany(email: emailSaved)
                }
            default:
                break
            }
        }
    }
    func executeServiceCompany(email: String?, companyName: String = "", isSearch: Bool = false, section: Int = 0) {
        activityIndicatorBegin()
        let service = CompanyService()
        service.updateInfoProfile(mail: email ?? "", companyName: companyName, IsSearch: isSearch, section: section){[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: "Sin compañias", message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    if isSearch {
                        self.isFiltered = true
                        self.cellType = 0
                        self.isTextSearched = true
                        self.isSerching = false
                        self.isSectionShown = false
                        self.searchBar.searchTextField.isUserInteractionEnabled = true
                        self.companiesFiltered = respService?.allCompanies ?? []
                    } else {
                        self.companies = respService?.allCompanies ?? []
                        if !self.companies.isEmpty {
                            self.tableView.isHidden = false
                        }
                        self.isUserLoaded = true
                    }
                    
                    self.tableView.reloadData()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept, actionHandler: { service in
                    
                    
                }),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    func executeServiceUser(email: String?, userName: String = "", isSearch: Bool = false, section: Int = 0) {
        self.activityIndicatorBegin()
        let service = UserService()
        service.updateInfoProfile(mail: email ?? "", userName: userName , IsSearch: isSearch, section: section) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: "Sin usuarios", message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    if isSearch {
                        self.cellType = 1
                        self.isTextSearched = true
                        self.isSerching = false
                        self.isSectionShown = false
                        self.searchBar.searchTextField.isUserInteractionEnabled = true
                        self.usersFiltered = respService?.clientDataArray ?? []
                    } else {
                        self.allUsers = respService?.clientDataArray ?? []
                        if !self.allUsers.isEmpty {
                            self.tableView.isHidden = false
                        }
                        
                        self.isUserLoaded = false
                    }
                    self.tableView.reloadData()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                if section == 0 {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
                }
                
            }
        }
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    }
    
    func showDetailCompany(data: Company) {
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! CompanyProfileViewController
        vc.companyId = data.clientId ?? ""
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func addSegmentedControled() {
        let codeSegmented = CustomSegmentedControl(frame: .zero, buttonTitle: ["Empresas","Contacto"])
        codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .clear
        segmentedControllerCustomView.addSubview(codeSegmented)
        
        NSLayoutConstraint.activate([
            codeSegmented.topAnchor.constraint(equalTo: segmentedControllerCustomView.topAnchor),
            codeSegmented.bottomAnchor.constraint(equalTo: segmentedControllerCustomView.bottomAnchor),
            codeSegmented.leadingAnchor.constraint(equalTo: segmentedControllerCustomView.leadingAnchor),
            codeSegmented.trailingAnchor.constraint(equalTo: segmentedControllerCustomView.trailingAnchor)
        ])
    }
}

// MARK: - CustomSegmentedControlDelegate

extension AddressViewController: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        cellType = index
        if isUserLoaded && cellType == 1 {
            executeServiceUser(email: emailSaved)
        }
        if companies.isEmpty && cellType == 2 {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
        if allUsers.isEmpty && cellType == 1 {
            self.tableView.isHidden = true
        } else {
            self.tableView.isHidden = false
        }
        tableView.reloadData()
    }
}

// MARK: - TableView Delgates

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSerching {
            if isSectionShown{
                if section == sectionShown {
                    return options.count
                } else {
                    return 0
                }
            } else {
                return 0
            }
        } else {
            if cellType == 1 {
                if isTextSearched {
                    return usersFiltered.count
                } else {
                    return allUsers.count
                }
            } else {
                if isTextSearched {
                    return companiesFiltered.count
                } else {
                    return companies.count
                }
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if  isSerching && cellType == 0 {
            return companyOptionsTitle.count
        } else if isSerching && cellType == 1 {
            return titleOptionsUser.count
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isSerching{
            if cellType == 1 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                if isSectionShown {
                    let option = self.options[indexPath.row]
                    cell.textLabel?.text = option
                } else {
                    let options = titleOptionsUser[indexPath.row]
                    cell.textLabel?.text = options
                }
                return cell
            } else {
                let cell = UITableViewCell(style: .value1,reuseIdentifier: "Cell")
                if isSectionShown {
                    let option = options[indexPath.row]
                    cell.textLabel?.text = option
                } else {
                    let options = companyOptionsTitle[indexPath.row]
                    cell.textLabel?.text = options
                }
                return cell
            }
        } else {
            if cellType == 1 {
                let Usercell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as? UserTableViewCell ?? UserTableViewCell()
                let userSelection: ClientData?
                if isTextSearched {
                    userSelection = usersFiltered[indexPath.row]
                } else {
                    userSelection = allUsers[indexPath.row]
                }
                
                Usercell.client = userSelection
                Usercell.selectionStyle = .none
                return Usercell
            } else {
                let companiescell = tableView.dequeueReusableCell(withIdentifier: "CompaniesTableViewCell", for: indexPath) as? CompaniesTableViewCell ?? CompaniesTableViewCell()
                let companySel: Company?
                if isTextSearched {
                    companySel = companiesFiltered[indexPath.row]
                } else {
                    companySel = companies[indexPath.row]
                }
                companiescell.dataCompany = companySel
                companiescell.selectionStyle = .none
                return companiescell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSerching || isSectionShown {
            return 30
        } else {
            if cellType == 1 {
                return 110
            } else {
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellType == 0 && !isSectionShown {
            if isSerching || isFiltered {
                let companySelected = companiesFiltered[indexPath.row]
                self.showDetailCompany(data: companySelected)
            } else {
                let companySelected = companies[indexPath.row]
                self.showDetailCompany(data: companySelected)
            }
        }
        if isSectionShown {
            let selection = options[indexPath.row]
            searchBar.text = selection
            if cellType == 1 {
                if indexPath.section == 0 {
                    executeServiceUser(email: emailSaved, userName: selection, isSearch: true, section: 1)
                } else {
                    executeServiceUser(email: emailSaved, userName: selection, isSearch: true, section: 3)
                }
            } else {
                if indexPath.section == 0 {
                    executeServiceCompany(email: emailSaved, companyName: selection , isSearch: true, section: 3)
                } else {
                    executeServiceCompany(email: emailSaved, companyName: selection , isSearch: true, section: 1)
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var titleforSection = ""
        if isSerching && cellType == 0 {
            titleforSection = companyOptionsTitle[section]
        } else if isSerching && cellType == 1{
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
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let section = gestureRecognizer.view?.tag else { return }
        sectionShown = section
        isSectionShown = true
        if cellType == 0 {
            let titleSelected = companyOptionsTitle[section]
            if titleSelected == "Ubicacion" {
                options = statesArray
            } else if titleSelected == "Servicio" {
                options = AppConstants.services
            }
        } else {
            let titleSelected = titleOptionsUser[section]
            if titleSelected == "Ingenio" {
                options = ingenioArray
            } else if titleSelected == "Departamento" {
                options = departamentoArray
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSerching {
            return 20
        } else {
            return 0
        }
    }
}

// MARK: - Search Bar Delegate

extension AddressViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltered = false
        lycSelectionViewConstraint.constant = 50
        searchBar.showsCancelButton = false
        isSerching = false
        isTextSearched = false
        isSectionShown = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        lycSelectionViewConstraint.constant = 0
        searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isTextSearched = true
        let textToSearch = searchBar.text ?? ""
        if cellType == 1 {
            executeServiceUser(email: emailSaved, userName: textToSearch, isSearch: true)
        } else {
            executeServiceCompany(email: emailSaved, companyName: textToSearch , isSearch: true)
        }
    }
}

