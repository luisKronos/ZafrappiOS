//
//  VacanciesSavedViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 28/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class VacanciesSavedViewController: ZPMasterViewController {
    
    private enum Constants {
        enum Storyboard {
            static let searchJob = "searchJob"
        }
        enum ViewController {
            static let profile = "profileVc"
        }
        enum TableView {
            static let companiesCellIdentifier = "CompaniesTableViewCell"
            static let heightRow: CGFloat = 100
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var selectionView: UIView!
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Properties
    
    private var postulations: [Postulation]?
    private var postulastionsSaved: [Postulation]?
    private var postulationOption = 1
    private var saved = 2
    private var typeOfData = 0
    private var genericPostulations: [Postulation]?
    
    // MARK: - Computed Properties
    
    private var userId: Int {
        let getIDUser =  InformationClasify.sharedInstance.data
        let id = getIDUser?.messageResponse?.userId ?? ""
        return Int(id) ?? 0
    }
    
    
    private var emailSaved: String {
        let getEmail =  InformationClasify.sharedInstance.data
        return  getEmail?.messageResponse?.email ?? ""
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        executeService(status: 2)
        addSegmentedControled()
    }
    
}

// MARK: - Private Methods

private extension VacanciesSavedViewController {
    
    func addSegmentedControled() {
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: self.selectionView.frame.width , height: self.selectionView.frame.height), buttonTitle: ["Mis vacantes marcadas","Mis postulaciones"])
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .clear
        self.selectionView.addSubview(codeSegmented)
    }
    
    func configTable() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CompaniesTableViewCell", bundle: nil), forCellReuseIdentifier: "CompaniesTableViewCell")
    }
    
    func showDetailCompany(vacancySelected: Postulation){
        let storyboard = UIStoryboard(name: Constants.Storyboard.searchJob, bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: Constants.ViewController.profile) as? VacancyDetailViewController else {
            return
        }
        
        vc.vancancy = vacancySelected
        vc.isDataChanged = false
        vc.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func executeService(status: Int) {
        activityIndicatorBegin()
        let service = PostulationService()
        
        service.obtainPostulations(mail: emailSaved, status: status, userId: userId) { [weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if let error = error {
                let nserror = error as NSError

                if nserror.code == 0 && respService != nil {
                    if respService?.status == AppConstants.ErrorCode.bad {
                        self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                    } else {
                        if status == self.saved {
                            self.postulastionsSaved = respService?.vacants
                            self.genericPostulations = respService?.vacants
                        } else if status == self.postulationOption {
                            self.genericPostulations = respService?.vacants
                            self.postulations = respService?.vacants
                        }
                        self.tableView.reloadData()
                    }
                } else if nserror.code == AppConstants.ErrorCode.noInternetConnection {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.tryAgain, actionHandler: {action in
                        self.executeService(status: status)}), animated: true)
                }
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
}

// MARK: - Custom Segment Control Delegate

extension VacanciesSavedViewController: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        typeOfData = index
        genericPostulations = index == postulationOption ? postulations : postulastionsSaved
        self.tableView.reloadData()
        
        if index == postulationOption, postulations?.count == nil {
            executeService(status: 1)
        }
    }
}

// MARK: - TableView Delgates

extension VacanciesSavedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genericPostulations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let companiescell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.companiesCellIdentifier, for: indexPath) as? CompaniesTableViewCell ?? CompaniesTableViewCell()
        let companySel  = genericPostulations?[indexPath.row]
        companiescell.dataVacancies = companySel
        companiescell.selectionStyle = .none
        companiescell.isCheckMarked = true
        return companiescell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.heightRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = genericPostulations?[indexPath.row] ?? Postulation()
        
        if typeOfData == 0 {
            selected.isSaved = true
            selected.isPostulated = false
        } else if typeOfData == 1{
            selected.isPostulated = true
            selected.isSaved = false
        }
        
        showDetailCompany(vacancySelected: selected)
    }
}
