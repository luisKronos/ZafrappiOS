//
//  AutoLoginViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class AutoLoginViewController: ZPMasterViewController {
    
    private enum Constants {
        enum Segue {
            static let news = "segueSplashToNews"
        }
    }
    
    // MARK: - IBOutlets
    
    private var informationToSave: Response?
    private var information = LogInData()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        information.name = UserDefaults.standard.string(forKey: AppConstants.UserDefaults.defaultRecoverUser.rawValue)
        information.password = UserDefaults.standard.string(forKey: AppConstants.UserDefaults.defaultRecoverDrowssap.rawValue)
        executeService(userData: information)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Segue.news) {
            let vcLogin = segue.destination as? TabBarManagerViewController
            vcLogin?.modalPresentationStyle = .fullScreen
            vcLogin?.selectedIndex = 0
        }
    }
    
}

// MARK: - Private Methods

private extension AutoLoginViewController {
    
    func showLogIn() {
        let storyboard = UIStoryboard(name: AppConstants.Storyboard.login, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: AppConstants.ViewController.loginNavigation)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func executeService(userData: LogInData?) {
        let service = LoginService()
        service.logInClient(Data: userData ?? LogInData()) { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                let nserror = error as NSError
                if nserror.code == 0, let response = response {
                    if response.status == AppConstants.ErrorCode.bad {
                        self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle,
                                                              message: response.message,
                                                              actionTitle: AppConstants.String.accept),
                                                              animated: true)
                    } else {
                        self.informationToSave = response
                        InformationClasify.sharedInstance.data = self.informationToSave
                        self.performSegue(withIdentifier: Constants.Segue.news, sender: nil)
                    }
                } else if nserror.code == AppConstants.ErrorCode.noInternetConnection {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection,
                                                          message: AppConstants.String.internetConnectionMessage,
                                                          actionTitle: AppConstants.String.accept,
                                                          actionHandler: {(_) in self.showLogIn() }),
                                                          animated: true)
                }
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle,
                                                      message: AppConstants.String.tryAgain,
                                                      actionTitle: AppConstants.String.accept,
                                                      actionHandler:{(_) in self.showLogIn() }),
                                                      animated: true)
            }
        }
    }
}
