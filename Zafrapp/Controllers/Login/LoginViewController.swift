//
//  Login_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/3/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class LoginViewController: ZPMasterViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum String {
            static let link = "www.zafrapp.com"
            static let mail = NSLocalizedString("Correo", comment: "")
            static let password = NSLocalizedString("Contraseña", comment: "")
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var userTextField: ZPDesignableUITextField! {
        didSet {
            userTextField.delegate = self
        }
    }
    @IBOutlet private var userErrorLabel: UILabel!
    @IBOutlet private var passwordTextField: ZPDesignableUITextField! {
        didSet{
            passwordTextField.delegate = self
        }
    }
    @IBOutlet private var passwordErrorLabel: UILabel!
    @IBOutlet private var createAccountButton: UIButton!
    @IBOutlet private var rememberImageView: UIImageView!
    @IBOutlet private var linkButton: UIButton!
    
    // MARK: - Properties
    
    private let defaults = UserDefaults.standard
    private var isDataSaved = false
    private var information = LogInData()
    private var responseInfo: Response?
    
    // MARK: -  View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextButtonRegister()
        configureLinkButton()
        configureTextFields()
    }
    
    // MARK: - IBActions
    
    @IBAction func loginAction(_ sender: Any) {
        if UITextField.validateAll(textFields: [userTextField,passwordTextField]) && ((userTextField.validateEmail(field: userTextField) != nil)) {
            information.name = userTextField.text
            information.password = passwordTextField.text
            executeService(userData: information)
        } else {
            checkFields()
        }
    }
    
    @IBAction func rememberPasswordAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            isDataSaved = true
            if let image = UIImage(named: "iconCheck") {
                rememberImageView.image = image
            }
        } else {
            isDataSaved = false
            if let image = UIImage(named: "iconUncheck") {
                rememberImageView.image = image
            }
        }
    }
    
    @IBAction func websiteAction(_ sender: Any) {
        guard let url = URL(string: "https://zafrapp.com/") else { return }
        UIApplication.shared.open(url)
        
    }
    
    @IBAction func forgotPasswordAction(_ sender: Any) {
        self.performSegue(withIdentifier: "LogInVcToPasswordForgotVc", sender: nil)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        self.performSegue(withIdentifier: "LogInVcToRegisterVc", sender: nil)
    }
    
    // MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let secondViewController = segue.destination as? RegisterAccountViewController {
            secondViewController.modalPresentationStyle = .fullScreen
        } else if (segue.identifier == "LoginVcToNews") {
            let vcLogin = segue.destination as? TabBarManagerViewController
            vcLogin?.modalPresentationStyle = .fullScreen
            vcLogin?.selectedIndex = 0
        }
    }
}

// MARK :- Private Methods

private extension LoginViewController {
    
    func configureLinkButton() {
        linkButton.setTitle(Constants.String.link, for: .normal)
        linkButton.setTitleColor(.white, for: .normal)
    }
    
    func configureTextFields() {
        userTextField.placeholder = Constants.String.mail
        userTextField.textColor = ZafrappTheme.Color.gray
        passwordTextField.placeholder = Constants.String.password
        passwordTextField.textColor = ZafrappTheme.Color.gray
    }
    
    func customTextButtonRegister() {
        let attributeNormal = [ NSAttributedString.Key.font: UIFont(name: "Poppins-Light", size: 13.0)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        let firstSentence = NSMutableAttributedString(string: "¿No tienes una cuenta?  ", attributes: attributeNormal )
        
        let attributeBold = [ NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 13.0)!, NSAttributedString.Key.foregroundColor: UIColor.white ]
        let SecondSentence = NSMutableAttributedString(string: "REGÍSTRATE", attributes: attributeBold )
        
        firstSentence.append(SecondSentence)
        
        createAccountButton.setAttributedTitle(firstSentence, for: .normal)
    }
    
    func executeService(userData: LogInData?) {
        self.activityIndicatorBegin()
        let service = LoginService()
        service.logInClient(data: userData ?? LogInData()) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    if self.isDataSaved {
                        self.saveInformation(dataUser: self.information.name ?? "", dataPassword: self.information.password ?? "")
                    }
                    self.responseInfo = respService ?? Response()
                    InformationClasify.sharedInstance.data = self.responseInfo
                    self.performSegue(withIdentifier: "LoginVcToNews", sender: nil)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func saveInformation(dataUser:String, dataPassword: String) {
        defaults.set(dataPassword, forKey: AppConstants.UserDefaults.defaultRecoverDrowssap.rawValue)
        defaults.set(dataUser, forKey: AppConstants.UserDefaults.defaultRecoverUser.rawValue)
        defaults.set(true, forKey: AppConstants.UserDefaults.isSaved.rawValue)
    }
    
    func checkFields() {
        if userTextField.text?.isEmpty ?? false {
            userErrorLabel.text = "Ingresa tu usuario"
        } else if !(userTextField.validateEmail(field: userTextField) != nil) {
            userErrorLabel.text = "Ingresa un correo  válido"
        }
        if passwordTextField.text?.isEmpty ?? false{
            passwordErrorLabel.text = "Ingresa tu contraseña"
        }
    }
}

// MARK: -  Textfield Delegate

extension LoginViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        userErrorLabel.text = ""
        passwordErrorLabel.text = ""
        return true
    }
}

// MARK: -  SaveInfoUser

class InformationClasify {
    static var sharedInstance = InformationClasify()
    private init() {}
    var data: Response?
}
