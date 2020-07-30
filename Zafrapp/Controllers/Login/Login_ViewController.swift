//
//  Login_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/3/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class Login_ViewController: ZPMasterViewController {
  
    //MARK:IBOutlets
    @IBOutlet weak var txtUser: ZPDesignableUITextField!{
        didSet {
            txtUser.delegate = self
        }
    }
    @IBOutlet weak var lblUserError: UILabel!
    @IBOutlet weak var txtPassword: ZPDesignableUITextField! {
        didSet{
              txtPassword.delegate = self
          }
    }
    @IBOutlet weak var lblPasswordError: UILabel!
    @IBOutlet weak var btnCreateAccountOut: UIButton!
    @IBOutlet weak var imgRemember: UIImageView!
    
    //MARK: Variables
    let defaults = UserDefaults.standard
    var isSaveData = false
    var information = LogInData()
    var responseInfo : responseLogIn?
    
    
    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customTextButtonRegister()
    }
    
    //MARK: Private functions
    func customTextButtonRegister () {
        let attributeNormal = [ NSAttributedString.Key.font: UIFont(name: "Poppins-Light", size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.white]
       let firstSentence = NSMutableAttributedString(string: "¿No tienes una cuenta?  ", attributes: attributeNormal )
        
        let attributeBold = [ NSAttributedString.Key.font: UIFont(name: "Poppins-Medium", size: 13.0)!, NSAttributedString.Key.foregroundColor : UIColor.white ]
      let SecondSentence = NSMutableAttributedString(string: "REGÍSTRATE", attributes: attributeBold )

        firstSentence.append(SecondSentence)
        
        btnCreateAccountOut.setAttributedTitle(firstSentence, for: .normal)
    }
    
    func executeService (DataUser : LogInData?) {
        self.activityIndicatorBegin()
       let ws = LogIn_WC ()
        ws.logInClient(Data: DataUser ?? LogInData()) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    if self.isSaveData {
                    self.saveInformation(dataUser: self.information.strName ?? "", dataPassword: self.information.strPass ?? "")
                     }
                        self.responseInfo = respService ?? responseLogIn()
                        informationClasify.sharedInstance.data = self.responseInfo
                        self.performSegue(withIdentifier: "LoginVcToNews", sender: nil)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let secondViewController = segue.destination as? CreateAccount_ViewController {
            secondViewController.modalPresentationStyle = .fullScreen
        }else if (segue.identifier == "LoginVcToNews") {
            let vcLogin = segue.destination as? TabBarManage_ViewController
            vcLogin?.modalPresentationStyle = .fullScreen
            vcLogin?.selectedIndex = 0
        }
    }
    
    
    func saveInformation (dataUser:String, dataPassword: String) {
        print(UserDefaultsConstants_Enum.defaultRecoverDrowssap.rawValue)
        defaults.set(dataPassword, forKey: UserDefaultsConstants_Enum.defaultRecoverDrowssap.rawValue)
        defaults.set(dataUser, forKey: UserDefaultsConstants_Enum.defaultRecoverUser.rawValue)
        defaults.set(true, forKey: UserDefaultsConstants_Enum.bIsSaved.rawValue)
    }
    
    func checkFields () {
        if txtUser.text?.isEmpty ?? false {
            lblUserError.text = "Ingresa tu usuario"
        }else if !(txtUser.validateEmail(field: txtUser) != nil) {
           lblUserError.text = "Ingresa un correo  válido"
        }
        if txtPassword.text?.isEmpty ?? false{
            lblPasswordError.text = "Ingresa tu contraseña"
        }
    }
    
    //MARK:IBAction
    @IBAction func btnLog(_ sender: Any) {
        if UITextField.validateAll(textFields: [txtUser,txtPassword]) && ((txtUser.validateEmail(field: txtUser) != nil)) {
                information.strName = txtUser.text
                information.strPass = txtPassword.text
                executeService(DataUser: information)
              }else {
                  checkFields()
              }
    }
    
    @IBAction func btnRememberPassw(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
             isSaveData = true
             if let image = UIImage(named: "iconCheck") {
                self.imgRemember.image = image
            }
        }else {
            isSaveData = false
            if let image = UIImage(named: "iconUncheck") {
                self.imgRemember.image = image
            }
        }

    }
    
    @IBAction func btnShowWebSite(_ sender: Any) {
        guard let url = URL(string: "https://zafrapp.com/") else { return }
        UIApplication.shared.open(url)

    }
    
    
    @IBAction func btnForgotPassw(_ sender: Any) {
        self.performSegue(withIdentifier: "LogInVcToPasswordForgotVc", sender: nil)
    }
    
    @IBAction func btnCreateAccount(_ sender: Any) {
        self.performSegue(withIdentifier: "LogInVcToRegisterVc", sender: nil)
    }
}

//MARK: Textfield Delegate
extension Login_ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        lblUserError.text = ""
        lblPasswordError.text = ""
        return true
    }
}



//MARK: SaveInfoUser
class informationClasify {
    static var sharedInstance = informationClasify()
    private init() {}
    var data: responseLogIn?
}
