//
//  AutoLoginViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 29/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class AutoLoginViewController: ZPMasterViewController{
 
    var informationToSave : responseLogIn?
    var information = LogInData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        information.strName = UserDefaults.standard.string(forKey: UserDefaultsConstants_Enum.defaultRecoverUser.rawValue)
        information.strPass = UserDefaults.standard.string(forKey: UserDefaultsConstants_Enum.defaultRecoverDrowssap.rawValue)
       executeService(DataUser: information)
    }
 
    func executeService (DataUser : LogInData?) {
          let ws = LogIn_WC ()
           ws.logInClient(Data: DataUser ?? LogInData()) {[weak self] (respService, error) in
                guard let self = self else { return }
               if (error! as NSError).code == 0 && respService != nil {
                   if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                   }else {
                           self.informationToSave = respService ?? responseLogIn()
                           informationClasify.sharedInstance.data = self.informationToSave
                           self.performSegue(withIdentifier: "segueSplashToNews", sender: nil)
                   }
               }else if (error! as NSError).code == -1009 {
                self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar", actionHandler: {(_) in
                    self.showLogIn ()
                }),animated: true)
               }else {
                self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar",actionHandler:{(_) in
                    self.showLogIn ()
                }),animated: true)
               }
           }
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueSplashToNews") {
          let vcLogin = segue.destination as? TabBarManage_ViewController
          vcLogin?.modalPresentationStyle = .fullScreen
          vcLogin?.selectedIndex = 0
        }
    }
    func showLogIn () {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "Login_Nav")
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true)
    }

}
