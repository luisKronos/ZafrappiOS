//
//  forgotPassword_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class forgotPassword_ViewController: ZPMasterViewController {

    @IBOutlet weak var txtEmail: ZPDesignableUITextField!{
        didSet {
            txtEmail.delegate = self
        }
    }
    
    var indicator = UIActivityIndicatorView()
    @IBOutlet weak var lycHeight: NSLayoutConstraint!
    @IBOutlet weak var lblErrorPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow),
        name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide),
        name: UIResponder.keyboardWillHideNotification, object: nil)    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        if #available(iOS 11.0, *){
             self.lycHeight.constant = keyboardHeight! - view.safeAreaInsets.bottom
         }
         else {
              self.lycHeight.constant = view.safeAreaInsets.bottom
            }
          UIView.animate(withDuration: 0.5){

             self.view.layoutIfNeeded()
          }
      }

     @objc func keyboardWillHide(notification: Notification){
         self.lycHeight.constant =  247 // or change according to your logic
          UIView.animate(withDuration: 0.5){
             self.view.layoutIfNeeded()
          }
     }
    func showSucces () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SucessChangePasswordVC") as? ExitChangeEmail_ViewController
        vc?.delegate = self
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc ?? ExitChangeEmail_ViewController(), animated: true, completion: nil)
    }
    
    func executeService (Email : String) {
          self.activityIndicatorBegin()
        let ws = recoverPassword_WS ()
        ws.recoverPass(Email: Email) {[weak self] (respService, error) in
             guard let self = self else { return }
             self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                  self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.showSucces()
                }
            }else if (error! as NSError).code == -1009  {
            self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)

            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    @IBAction func continuar(_ sender: Any) {
        if (txtEmail.validateEmail(field: txtEmail) != nil) {
          executeService(Email: txtEmail.text ?? "")
        }else {
            lblErrorPassword.text = "Ingresa un correo válido"
        }
        
    }
}

extension forgotPassword_ViewController : returnRootDelegate {
    func returnLogin() {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}

extension forgotPassword_ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lblErrorPassword.text = ""
        return true
    }
}
