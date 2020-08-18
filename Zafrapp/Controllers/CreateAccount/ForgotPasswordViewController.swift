//
//  ForgotPasswordViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: ZPMasterViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var emailTextField: ZPDesignableUITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    
    @IBOutlet private var lycHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var passwordErrorLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func continueAction(_ sender: Any) {
        if emailTextField.validateEmail(field: emailTextField) != nil {
            executeService(email: emailTextField.text ?? "")
        } else {
            passwordErrorLabel.text = "Ingresa un correo válido"
        }
        
    }
}

// MARK :- Private Methods

private extension ForgotPasswordViewController {
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        if #available(iOS 11.0, *){
            self.lycHeightConstraint.constant = keyboardHeight! - view.safeAreaInsets.bottom
        }
        else {
            self.lycHeightConstraint.constant = view.safeAreaInsets.bottom
        }
        UIView.animate(withDuration: 0.5){
            
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification){
        self.lycHeightConstraint.constant =  247 // or change according to your logic
        UIView.animate(withDuration: 0.5){
            self.view.layoutIfNeeded()
        }
    }
    func showSuccess() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SucessChangePasswordVC") as? ExitChangeEmailViewController
        vc?.delegate = self
        vc?.modalPresentationStyle = .fullScreen
        present(vc ?? ExitChangeEmailViewController(), animated: true, completion: nil)
    }
    
    func executeService(email: String) {
        activityIndicatorBegin()
        let service = RecoverPasswordService()
        service.recoverPass(Email: email) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.showSuccess()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection  {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
                
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
}

extension ForgotPasswordViewController: ReturnRootDelegate {
    
    func returnLogin() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        passwordErrorLabel.text = ""
        return true
    }
}
