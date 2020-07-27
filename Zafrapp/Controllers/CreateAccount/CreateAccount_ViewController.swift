//
//  CreateAccount_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/4/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CreateAccount_ViewController: ZPMasterViewController {
    
    //MARK:IBOutlets
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var txtPassword: ZPDesignableUITextField!{
        didSet{
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var txtName: ZPDesignableUITextField!{
        didSet{
            txtName.delegate = self
        }
    }
    @IBOutlet weak var txtEmail: ZPDesignableUITextField!{
        didSet{
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var txtCelular: ZPDesignableUITextField!{
        didSet{
            txtCelular.delegate = self
        }
    }
    @IBOutlet weak var switchPublisPhone: UISwitch!
    @IBOutlet weak var txtProfesion: ZPDesignableUITextField!{
        didSet{
            txtProfesion.delegate = self
        }
    }
    @IBOutlet weak var switchLookingJob: UISwitch!
    @IBOutlet weak var txtDepartmentJob: ZPDesignableUITextField!{
        didSet{
            txtDepartmentJob.delegate = self
        }
    }
    @IBOutlet weak var txtPlaceToWork: ZPDesignableUITextField!{
        didSet{
            txtPlaceToWork.delegate = self
        }
    }
    @IBOutlet weak var txtOtroDpto: ZPDesignableUITextField!{
        didSet{
            txtOtroDpto.delegate = self
        }
    }
    @IBOutlet weak var txtOtroIngenio: ZPDesignableUITextField!{
        didSet{
            txtOtroIngenio.delegate = self
        }
    }
    
    @IBOutlet weak var txtDay: ZPDesignableUITextField!{
        didSet{
            txtDay.delegate = self
        }
    }
    @IBOutlet weak var txtMonth: ZPDesignableUITextField!{
        didSet {
            txtMonth.delegate = self
        }
    }
    @IBOutlet weak var txtYear: ZPDesignableUITextField!{
        didSet{
            txtYear.delegate = self
        }
    }
    
    @IBOutlet weak var lblErrorotroDepartamento: UILabel!
    @IBOutlet weak var lblErrorOtroIngenio: UILabel!
    @IBOutlet weak var lblErrorName: UILabel!
    @IBOutlet weak var lblErrorEmail: UILabel!
    @IBOutlet weak var lbleErrorCellPhone: UILabel!
    @IBOutlet weak var lblErrorBirthDay: UILabel!
    @IBOutlet weak var lblErrorCurrentJob: UILabel!
    @IBOutlet weak var lblErrorProfession: UILabel!
    @IBOutlet weak var lblErrorPlaceToWork: UILabel!
    @IBOutlet weak var lblErrorPassword: UILabel!
    @IBOutlet weak var lycHeighDepto: NSLayoutConstraint!
    @IBOutlet weak var lyvHeightIngenio: NSLayoutConstraint!
    
    //MARK: Variables
    var intTypePicker = 0
    let datePicker = UIDatePicker()
    var arrPlaceWork : [String] = []
    var picker = UIPickerView()
    var activeTextField = UITextField()
    var DatosRegistrar = registerAccount()
    
    //MARK: VCLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lyvHeightIngenio.constant = 80
        lycHeighDepto.constant = 30
        txtOtroDpto.isHidden = true
        txtOtroIngenio.isHidden = true
        switchLookingJob.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        switchPublisPhone.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
    }

   
    //MARK:IBAction
    @IBAction func btnRegister(_ sender: Any) {
        if UITextField.validateAll(textFields: [txtName,txtEmail,txtCelular,txtDay,txtMonth,txtYear,txtProfesion,txtDepartmentJob,txtPlaceToWork]) && ((txtEmail.validateEmail(field: txtEmail) != nil)) && txtCelular.text?.count == 10 && Int(txtDay.text ?? "0") ?? 0 < 32  && Int(txtMonth.text ?? "0") ?? 0 < 13 && Int(txtYear.text ?? "") ?? 0 < 2020{
            if txtDepartmentJob.text == "Otro" && txtPlaceToWork.text == "Otro (Cuál)"{
                if !(txtOtroIngenio.text?.isEmpty ?? false) && !(txtOtroDpto.text?.isEmpty ?? false){
                  saveAllAndService (departamento : txtOtroDpto.text! , ingenio: txtOtroIngenio.text!)
                } else {
                  checkOptionalesDptEIngenio()
                }
            }else if  txtDepartmentJob.text == "Otro" || txtPlaceToWork.text == "Otro (Cuál)"{
              checkOptionalesDptEIngenio()
            }else{
                saveAllAndService(departamento: txtDepartmentJob.text!, ingenio: txtPlaceToWork.text!)
            }
        }else {
             self.present(ZPAlertGeneric.OneOption(title : "Campos incompletos", message: "Completar todos los campos", actionTitle: "Aceptar"),animated: true)
            checkFields()
        }
    }
    
     //MARK: Private functions
    func checkOptionalesDptEIngenio(){
        if !(txtOtroIngenio.text?.isEmpty ?? false) && txtPlaceToWork.text == "Otro (Cuál)" {
            saveAllAndService(departamento: txtDepartmentJob.text!, ingenio: txtOtroIngenio.text!)
        }else if (txtOtroIngenio.text?.isEmpty ?? false) && txtPlaceToWork.text == "Otro (Cuál)" {
            lblErrorOtroIngenio.text = "Ingresa tus datos"
        }
        
        if !(txtOtroDpto.text?.isEmpty ?? false) && txtDepartmentJob.text == "Otro"{
            saveAllAndService(departamento: txtOtroDpto.text!, ingenio: txtPlaceToWork.text!)
        }else if (txtOtroDpto.text?.isEmpty ?? false) && txtDepartmentJob.text == "Otro" {
            lblErrorotroDepartamento.text = "Ingresa tus datos"
             }
    }
    func saveAllAndService (departamento : String , ingenio: String) {
        DatosRegistrar.strName = txtName.text
        DatosRegistrar.strEmail = txtEmail.text
        DatosRegistrar.intPhone = Int(txtCelular.text ?? "")
        DatosRegistrar.strBirthDay = "\(txtDay.text ?? "")/\(txtMonth.text ?? "")/\(txtYear.text ?? "")"
        DatosRegistrar.strCurrent_job = txtProfesion.text
        DatosRegistrar.strWork_place = ingenio
        DatosRegistrar.strWork_deparment = departamento
        DatosRegistrar.bShareCel = switchPublisPhone.isOn
        DatosRegistrar.bIs_search_work = switchLookingJob.isOn
        DatosRegistrar.strPassword = txtPassword.text
        
        executeService (DataUser: DatosRegistrar)
    }
    func ShowSuccesCreateAccount () {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "SucessAccountVC") as? AccountSucces_ViewController
          vc?.delegate = self
          vc?.modalPresentationStyle = .fullScreen
          self.present(vc ?? AccountSucces_ViewController(), animated: true, completion: nil)
      }
    
    func executeService (DataUser : registerAccount?) {
        self.activityIndicatorBegin()
        let ws = CreateAccount_WS ()
        ws.createAccount(Data: DataUser ?? registerAccount()) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                    self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.ShowSuccesCreateAccount()
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    func checkFields () {
        if txtName.text?.isEmpty ?? false {
                  lblErrorName.text = "Ingresa tu nombre"
              }
        if txtEmail.text?.isEmpty ?? false {
           lblErrorEmail.text = "Ingresa tu correo"
        }else if !(txtEmail.validateEmail(field: txtEmail) != nil){
                  lblErrorEmail.text = "Ingresa un correo válido"
              }
        if txtCelular.text?.isEmpty ?? false{
            lbleErrorCellPhone.text = "Ingresa tu número celular"
        }else if txtCelular.text?.count ?? 0 < 10 {
            lbleErrorCellPhone.text = "Ingresa un número válido"
        }
        if txtYear.text?.isEmpty ?? false || txtMonth.text?.isEmpty ?? false || txtDay.text?.isEmpty ?? false{
            lblErrorBirthDay.text = "Ingresa una fecha"
        }else if  Int(txtDay.text ?? "0") ?? 0 > 31  || Int(txtMonth.text ?? "0") ?? 0 > 12 || Int(txtYear.text ?? "") ?? 0 > 2019{
             lblErrorBirthDay.text = "Ingresa una fecha válida"
        }
        if txtProfesion.text?.isEmpty ?? false{
                  lblErrorProfession.text = "Selecciona una profesión"
              }
        if txtDepartmentJob.text?.isEmpty ?? false{
                  lblErrorCurrentJob.text = "Selecciona un ingenio"
              }
        if txtPlaceToWork.text?.isEmpty ?? false{
                  lblErrorPlaceToWork.text = "Selecciona un departamento "
              }
        if txtPassword.text?.isEmpty ?? false {
              lblErrorPassword.text = "Ingresa una contraseña "
             }
    }
    
    func showPickerView () {
      picker.delegate = self
      picker.dataSource = self
      picker.backgroundColor = UIColor.white
       
      txtDepartmentJob.inputView = picker
      txtPlaceToWork.inputView = picker
    }
}

//MARK: Textfield Delegate
extension CreateAccount_ViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if textField.tag == typeOfDataPicker_Enum.ingenio.rawValue || textField.tag == typeOfDataPicker_Enum.birthDay.rawValue || textField.tag == typeOfDataPicker_Enum.Departamento.rawValue {
             return false
         }else {
             return true
         }
     }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblErrorOtroIngenio.text = ""
        lblErrorotroDepartamento.text = ""
        lblErrorPassword.text = ""
        lblErrorPlaceToWork.text = ""
        lblErrorEmail.text = ""
        lblErrorCurrentJob.text = ""
        lblErrorPassword.text = ""
        lbleErrorCellPhone.text = ""
        lblErrorBirthDay.text = ""
        lblErrorProfession.text = ""
        lblErrorPlaceToWork.text = ""
        lblErrorName.text = ""
        lblErrorBirthDay.text = ""
        if textField.tag == typeOfDataPicker_Enum.Departamento.rawValue {
            lycHeighDepto.constant = 30
            txtOtroDpto.isHidden = true
            intTypePicker = typeOfDataPicker_Enum.Departamento.rawValue
            arrPlaceWork = arrDepartamento
            showPickerView ()
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
            picker.selectRow(0, inComponent: 0, animated: true)
        }else if textField.tag == typeOfDataPicker_Enum.ingenio.rawValue {
            txtOtroIngenio.isHidden = true
            lyvHeightIngenio.constant = 80
            intTypePicker = typeOfDataPicker_Enum.ingenio.rawValue
            arrPlaceWork = arrIngenio
            showPickerView()
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }else if textField.tag == typeOfDataPicker_Enum.birthDay.rawValue {
            intTypePicker = typeOfDataPicker_Enum.birthDay.rawValue
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }
      }
}


//MARK: Picker Delegate
extension CreateAccount_ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: arrPlaceWork[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPlaceWork.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrPlaceWork[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if intTypePicker == typeOfDataPicker_Enum.Departamento.rawValue {
          txtDepartmentJob.text = arrPlaceWork[row]
            if txtDepartmentJob.text == "Otro" {
                txtOtroDpto.isHidden = false
                lycHeighDepto.constant = 102
            }else {
                lycHeighDepto.constant = 30
            }
        }else {
          txtPlaceToWork.text = arrPlaceWork[row]
            if txtPlaceToWork.text == "Otro (Cuál)" {
                txtOtroIngenio.isHidden = false
                lyvHeightIngenio.constant = 155
            }else {
                lyvHeightIngenio.constant = 80
            }
        }
    }
}

 //MARK: returnRootDelegate Delegate
extension CreateAccount_ViewController : returnRootDelegate {
    func returnLogin() {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
