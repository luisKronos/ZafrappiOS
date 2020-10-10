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
        enum String {
            static let noVacancies = NSLocalizedString("No hay vacantes marcadas.", comment: "")
            static let noPostulation = NSLocalizedString("No sea ha postulado a ninguna vacante.", comment: "")
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var selectionView: UIView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyMessageLabel: UILabel!
    
    // MARK: - Properties
    
    private var postulations: [Postulation]?
    private var postulastionsSaved: [Postulation]?
    private var postulationOption = 1
    private var saved = 2
    private var selectedSegmentIndex = 0
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
        configureLabel()
        configureTableView()
        executeService(status: 2)
        configureSegmentedControl()
    }
    
}

// MARK: - Private Methods

private extension VacanciesSavedViewController {
    
    func configureLabel() {
        emptyMessageLabel.numberOfLines = 0
        emptyMessageLabel.textColor = ZafrappTheme.Color.gray
        emptyMessageLabel.font = ZafrappTheme.Font.Profile.emptyMessage
        emptyMessageLabel.text = Constants.String.noVacancies
        toggleEmptyMessage()
    }
    
    func configureSegmentedControl() {
        let codeSegmented = CustomSegmentedControl(frame: .zero, buttonTitle: ["Mis vacantes marcadas", "Mis postulaciones"])
        codeSegmented.translatesAutoresizingMaskIntoConstraints = false
        codeSegmented.delegate = self
        codeSegmented.backgroundColor = .clear
        selectionView.addSubview(codeSegmented)
        
        NSLayoutConstraint.activate([
            codeSegmented.topAnchor.constraint(equalTo: selectionView.topAnchor),
            codeSegmented.bottomAnchor.constraint(equalTo: selectionView.bottomAnchor),
            codeSegmented.leadingAnchor.constraint(equalTo: selectionView.leadingAnchor),
            codeSegmented.trailingAnchor.constraint(equalTo: selectionView.trailingAnchor)
        ])
    }
    
    func configureTableView() {
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
            self.toggleEmptyMessage()
        }
    }
    
    func toggleEmptyMessage() {
        emptyMessageLabel.isHidden = !(genericPostulations?.isEmpty ?? true)
        emptyMessageLabel.text = selectedSegmentIndex == postulationOption ? Constants.String.noPostulation : Constants.String.noVacancies
    }
}

// MARK: - Custom Segment Control Delegate

extension VacanciesSavedViewController: CustomSegmentedControlDelegate {
    
    func changeToIndex(index: Int) {
        selectedSegmentIndex = index
        genericPostulations = index == postulationOption ? postulations : postulastionsSaved
        
        toggleEmptyMessage()
        tableView.reloadData()
        
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
        
        if selectedSegmentIndex == 0 {
            selected.isSaved = true
            selected.isPostulated = false
        } else if selectedSegmentIndex == 1{
            selected.isPostulated = true
            selected.isSaved = false
        }
        
        showDetailCompany(vacancySelected: selected)
    }
}
