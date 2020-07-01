//
//  EditProfile_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class EditProfile_ViewController: ZPMasterViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtEstado: ZPDesignableUITextField!{
        didSet{
            txtEstado.delegate = self
        }
    }
    @IBOutlet weak var txtMunicipio: ZPDesignableUITextField!{
        didSet{
            txtMunicipio.delegate = self
        }
    }
    @IBOutlet weak var txtProfession: ZPDesignableUITextField!{
        didSet{
            txtProfession.delegate = self
        }
    }
    
    @IBOutlet weak var txtPhoneOffice: ZPDesignableUITextField!{
        didSet{
            txtPhoneOffice.delegate = self
        }
    }
    @IBOutlet weak var txtExt: ZPDesignableUITextField!{
        didSet{
            txtExt.delegate = self
        }
    }
    @IBOutlet weak var switchIsSearchJob: UISwitch!
    @IBOutlet weak var switchShowCell: UISwitch!
    @IBOutlet weak var txtCellPhone: ZPDesignableUITextField!{
        didSet{
            txtCellPhone.delegate = self
        }
    }
    @IBOutlet weak var txtJob: ZPDesignableUITextField!{
        didSet{
            txtJob.delegate = self
        }
    }
    @IBOutlet weak var txtIngenio: ZPDesignableUITextField!{
        didSet{
            txtIngenio.delegate = self
        }
    }
    @IBOutlet weak var txtStreet: ZPDesignableUITextField!{
        didSet{
            txtStreet.delegate = self
        }
    }
    
    @IBOutlet weak var txtNumber: ZPDesignableUITextField!{
        didSet{
            txtNumber.delegate = self
        }
    }
    @IBOutlet weak var txtCodigoPostal: ZPDesignableUITextField!{
        didSet{
            txtCodigoPostal.delegate = self
        }
    }
    @IBOutlet weak var txtInterest: ZPDesignableUITextField!{
        didSet{
            txtInterest.delegate = self
        }
    }
    
    @IBOutlet weak var txtOtherInterest: ZPDesignableUITextField!{
        didSet{
            txtOtherInterest.delegate = self
        }
    }
    @IBOutlet weak var txtOtherIngenio: ZPDesignableUITextField!{
        didSet{
            txtOtherIngenio.delegate = self
        }
    }
    
    @IBOutlet weak var txtDepartament: ZPDesignableUITextField!{
        didSet{
            txtDepartament.delegate = self
        }
    }
    
    @IBOutlet weak var lblShowCell: ZpLabel!
    @IBOutlet weak var lblSearchJob: ZpLabel!
    @IBOutlet weak var viewCellPhone: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewInterest: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var lblErrorCellPhone: UILabel!
    @IBOutlet weak var lblErrorStreet: UILabel!
    @IBOutlet weak var lblErrorEstado: UILabel!
    @IBOutlet weak var lblErrorMunicipio: UILabel!
    @IBOutlet weak var lblErrorNumber: UILabel!
    @IBOutlet weak var lblCP: UILabel!
    @IBOutlet weak var lblErrorProfesion: UILabel!
    @IBOutlet weak var lblErrorInteres: UILabel!
    @IBOutlet weak var lblErrorIngenio: UILabel!
    @IBOutlet weak var lblErrorDepartamento: UILabel!
    @IBOutlet weak var lblErrorPhoneOffice: UILabel!
    @IBOutlet weak var lblErrorOtherDepartment: UILabel!
    @IBOutlet weak var lblErrorOtherIngenio: UILabel!
    @IBOutlet weak var lblErrorExt: UILabel!
    @IBOutlet weak var lblErrorOtherInterest: UILabel!
    @IBOutlet weak var lycHeightJob: NSLayoutConstraint!
    @IBOutlet weak var lycInterest: NSLayoutConstraint!
    @IBOutlet weak var lycCurrentIngenio: NSLayoutConstraint!
    
    var iSeccionUpdate = 0
    let picker = UIPickerView()
    var dataPicker : [String] = []
    var indicator = UIActivityIndicatorView()
    var updateInfo = updateData ()
    var informationUser : responseLogIn?
    var informationFill : responseLogIn?
    var imageProfile : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addData()
        adjustImageRound ()
        switchIsSearchJob.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        informationUser = informationClasify.sharedInstance.data
    }
    
    @objc func onSwitchValueChanged(_ switchS: UISwitch) {
        if switchS.tag == typeOfPickerEditProfile_Enum.Trabajo.rawValue {
            iSeccionUpdate = typeOfPickerEditProfile_Enum.Trabajo.rawValue
        }else if switchS.tag == typeOfPickerEditProfile_Enum.Cell.rawValue {
            iSeccionUpdate = typeOfPickerEditProfile_Enum.Cell.rawValue
        }
    }
    func textFieldWithPicker (){
        picker.delegate = self
        picker.dataSource = self
        txtEstado.inputView = picker
        txtMunicipio.inputView = picker
        txtInterest.inputView = picker
        txtIngenio.inputView = picker
        txtJob.inputView = picker
    }
    func adjustImageRound () {
        switchShowCell.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        switchIsSearchJob.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
          self.imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
          self.imgProfile.layer.borderColor = #colorLiteral(red: 0.337254902, green: 0.3882352941, blue: 1, alpha: 1)
          self.imgProfile.layer.borderWidth = 2
          self.imgProfile.clipsToBounds = true
        if imageProfile != nil {
         imgProfile.image = imageProfile
        }
      }
    
    func addData () {
        lycHeightJob.constant = 330
        lycInterest.constant = 25
        lycCurrentIngenio.constant = 25
        txtOtherIngenio.isHidden = true
        txtOtherInterest.isHidden = true
        txtDepartament.isHidden = true
        
        informationFill =  informationClasify.sharedInstance.data
        txtEstado.text = informationFill?.arrMessage?.strEstado
        txtMunicipio.text = informationFill?.arrMessage?.strMunicipio
        txtStreet.text = informationFill?.arrMessage?.strCalle
        txtNumber.text = informationFill?.arrMessage?.strNumero
        txtPhoneOffice.text = informationFill?.arrMessage?.strNumber_office
        txtExt.text = informationFill?.arrMessage?.strExt
        txtProfession.text = informationFill?.arrMessage?.strCurrent_job
        switchIsSearchJob.isOn = informationFill?.arrMessage?.strIs_search_work == "1" ? true : false
        txtInterest.text = informationFill?.arrMessage?.strInterest
        lblName.text = informationFill?.arrMessage?.strName
        lblEmail.text = informationFill?.arrMessage?.strEmail
        txtJob.text = informationFill?.arrMessage?.strWork_deparment
        txtCellPhone.text = informationFill?.arrMessage?.strCelphone
        txtIngenio.text = informationFill?.arrMessage?.strWork_place
        switchShowCell.isOn = informationFill?.arrMessage?.strIs_share_cel == "1" ? true : false
        txtCodigoPostal.text =  informationFill?.arrMessage?.strCP
    }

    func executeService (DataUser : updateData?) {
        self.activityIndicatorBegin()
       let ws = SeccionsProfile_WS ()
        ws.updateInfoProfile(Data: DataUser ?? updateData() , seccion: iSeccionUpdate) {[weak self] (respService, error) in
             guard let self = self else { return }
               self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else{
                    self.updateinfoSaved()
                    self.present(ZPAlertGeneric.OneOption(title : "Correcto", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }
            }else if (error! as NSError).code == -1009 {
               self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
          }
        }
    
    func updateinfoSaved(){
        let saveInfo = informationClasify.sharedInstance.data?.arrMessage
        switch typeOfPickerEditProfile_Enum(rawValue: iSeccionUpdate ) {
        case .Estado, .Municipio,.Calle:
          saveInfo?.strEstado  = txtEstado.text
          saveInfo?.strMunicipio = txtMunicipio.text
          saveInfo?.strCalle = txtStreet.text
          saveInfo?.strNumero = txtNumber.text
          saveInfo?.strCP = txtCodigoPostal.text ?? ""
          saveInfo?.strId_user = informationUser?.arrMessage?.strId_user
          saveInfo?.strId_address = informationUser?.arrMessage?.strId_address
        case .Trabajo, .AreaDeInteres, .interesOpcional,.departamento, .Ingenio, .optionalDepartment, .optionaIngenio:
            saveInfo?.strEmail = informationUser?.arrMessage?.strEmail
            saveInfo?.strCurrent_job = txtProfession.text
            saveInfo?.strIs_search_work = String(switchIsSearchJob.isOn)
            saveInfo?.strAreaInteres = areaOfInteres().returnAreaInterest(Area: txtInterest.text ?? "")
            if txtInterest.text == "Otro (cuál)"{
              saveInfo?.strInterest = txtOtherInterest.text
            }else {
              saveInfo?.strInterest = txtInterest.text
            }
            if txtIngenio.text == "Otro (Cuál)" {
               saveInfo?.strWork_place = txtOtherIngenio.text
             }else{
                saveInfo?.strWork_place = txtIngenio.text
            }
            if txtJob.text == "Otro"{
                saveInfo?.strWork_deparment = txtDepartament.text
             }else{
                saveInfo?.strWork_deparment = txtJob.text
               }
        case .PhoneOffice:
            saveInfo?.strEmail = informationUser?.arrMessage?.strEmail
            saveInfo?.strNumber_office = txtPhoneOffice.text
            saveInfo?.strExt = txtExt.text
        case .Cell:
            saveInfo?.strCelphone = txtCellPhone.text
            saveInfo?.strIs_share_cel = String(switchShowCell.isOn)
            saveInfo?.strEmail = informationUser?.arrMessage?.strEmail
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    func addDataService () {
        switch typeOfPickerEditProfile_Enum(rawValue: iSeccionUpdate ) {
        case .Estado, .Municipio,.Calle:
          updateInfo.strState = txtEstado.text
          updateInfo.strMunicipio = txtMunicipio.text
          updateInfo.strStreet = txtStreet.text
          updateInfo.strNumberStreet = txtNumber.text
          updateInfo.intCP = Int(txtCodigoPostal.text ?? "")
          updateInfo.strId_user = informationUser?.arrMessage?.strId_user
          updateInfo.strId_Adress = informationUser?.arrMessage?.strId_address
        case .Trabajo, .AreaDeInteres,.departamento, .Ingenio, .interesOpcional, .optionaIngenio, .optionalDepartment:
            
            if txtInterest.text == "Otro (cuál)" {
             updateInfo.strInterest = txtOtherInterest.text
            }else {
             updateInfo.strInterest = txtInterest.text
            }
            if txtIngenio.text == "Otro (Cuál)" {
                updateInfo.strWork_place = txtOtherIngenio.text
            }else{
               updateInfo.strWork_place = txtIngenio.text
            }
            if txtJob.text == "Otro"{
                updateInfo.strWork_deparment = txtDepartament.text
            }else{
               updateInfo.strWork_deparment = txtJob.text
            }
            updateInfo.strEmail = informationUser?.arrMessage?.strEmail
            updateInfo.strCurrent_job = txtProfession.text
            updateInfo.bIs_search_work = switchIsSearchJob.isOn
        case .PhoneOffice:
            updateInfo.strEmail = informationUser?.arrMessage?.strEmail
            updateInfo.intNumber_Office = Int(txtPhoneOffice.text ?? "")
            updateInfo.intExt = Int(txtExt.text ?? "")
        case .Cell:
            updateInfo.intCellPhone = Int(txtCellPhone.text ?? "")
            updateInfo.bShow_Cell = switchShowCell.isOn
            updateInfo.strEmail = informationUser?.arrMessage?.strEmail
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    func resetErrorLabel () {
      lblErrorOtherInterest.text = ""
      lblErrorEstado.text = ""
      lblErrorMunicipio.text = ""
      lblErrorStreet.text = ""
      lblErrorNumber.text = ""
      lblCP.text = ""
      lblErrorProfesion.text = ""
      lblErrorInteres.text = ""
      lblErrorIngenio.text = ""
      lblErrorDepartamento.text = ""
      lblErrorPhoneOffice.text = ""
      lblErrorExt.text = ""
      lblErrorCellPhone.text = ""
      lblErrorOtherIngenio.text = ""
      lblErrorOtherDepartment.text = ""
     }
     
     func checkSectionAddress () {
         if txtEstado.text?.isEmpty ?? false{
           lblErrorEstado.text = "Selecciona un estado"
         }
         if txtMunicipio.text?.isEmpty ?? false {
            lblErrorMunicipio.text = "Selecciona un municipio"
         }
         if txtStreet.text?.isEmpty ?? false {
           lblErrorStreet.text = "Ingresa tu calle"
         }
         if txtNumber.text?.isEmpty ?? false {
           lblErrorNumber.text = "Ingresa el número"
         }
         if txtCodigoPostal.text?.isEmpty ?? false {
           lblCP.text = "Ingresa tu código postal"
         }else if txtCodigoPostal.text?.count ?? 0 < 5{
            lblCP.text = "Ingresa un código postal válido"
         }
     }
     func checkPhoneNumber () {
       if txtPhoneOffice.text?.isEmpty ?? false{
           lblErrorPhoneOffice.text = "Ingresa un número"
       }else if txtPhoneOffice.text?.count ?? 0 < 10 {
         lblErrorPhoneOffice.text = "Ingresa un número válido"
         }
       if txtExt.text?.isEmpty ?? false{
           lblErrorExt.text = "Ingresa una extension"
         }
     }
     func checkSectionJob () {
         if txtProfession.text?.isEmpty ?? false{
           lblErrorProfesion.text = "Selecciona tu profesión"
         }
         if txtInterest.text?.isEmpty ?? false {
             lblErrorInteres.text = "Selecciona un área de interés"
         }
         if txtIngenio.text?.isEmpty ?? false {
           lblErrorIngenio.text = "Selecciona un ingenio"
         }
         if txtJob.text?.isEmpty ?? false {
           lblErrorDepartamento.text = "Selecciona un departamento"
         }
     }
     
     func changeColorBackgroundView(){
         switch typeOfPickerEditProfile_Enum(rawValue: iSeccionUpdate ) {
          case .Estado, .Municipio, .Calle:
             viewAddress.backgroundColor = UIColor.white
             viewInterest.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewCellPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
         case .AreaDeInteres, .Trabajo, .Ingenio, .departamento, .interesOpcional, .optionalDepartment, .optionaIngenio:
             viewInterest.backgroundColor = UIColor.white
             viewPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewCellPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewAddress.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
         case .PhoneOffice:
             viewInterest.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewCellPhone.backgroundColor = UIColor.white
             viewPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewAddress.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
         case .Cell:
             viewInterest.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewCellPhone.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
             viewPhone.backgroundColor = UIColor.white
             viewAddress.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
         default:
             return
                }
     }
    
    //MARK: IBAction
    
    @IBAction func switchSearchJob(_ sender: UISwitch) {
        iSeccionUpdate = typeOfPickerEditProfile_Enum.AreaDeInteres.rawValue
        changeColorBackgroundView()
    }
    
    @IBAction func switchShowCell(_ sender: UISwitch) {
        iSeccionUpdate = typeOfPickerEditProfile_Enum.Cell.rawValue
        changeColorBackgroundView()
    }
    
    func checkOptionales(){
        if txtOtherInterest.text?.isEmpty ?? false && txtInterest.text == "Otro (cuál)" {
                   lblErrorOtherInterest.text = "Ingresa un área de interés"
               }
        if txtOtherIngenio.text?.isEmpty ?? false && txtIngenio.text == "Otro (Cuál)" {
              lblErrorOtherIngenio.text = "Ingresa un ingenio"
            }
          
        if txtDepartament.text?.isEmpty ?? false && txtJob.text == "Otro"{
              lblErrorOtherDepartment.text = "Ingresa un departamento"
               }
      }
    
    @IBAction func saveData(_ sender: Any) {
        switch typeOfPickerEditProfile_Enum(rawValue: iSeccionUpdate ) {
        case .Estado, .Municipio,.Calle:
            if UITextField.validateAll(textFields: [txtEstado,txtMunicipio,txtStreet,txtNumber,txtCodigoPostal]) &&  txtCodigoPostal.text?.count ?? 0 == 5{
              addDataService()
              executeService(DataUser: updateInfo)
            }else {
              checkSectionAddress()
            }
        case .Trabajo, .AreaDeInteres, .Ingenio, .departamento,.interesOpcional, . optionalDepartment, .optionaIngenio:
            if UITextField.validateAll(textFields: [txtProfession,txtInterest]){
                if txtInterest.text == "Otro (cuál)" && txtIngenio.text == "Otro (Cuál)" && txtJob.text == "Otro"{
                    if txtOtherIngenio.text?.isEmpty ?? false || txtDepartament.text?.isEmpty ?? false || txtOtherInterest.text?.isEmpty ?? false {
                        checkOptionales()
                    }else{
                        addDataService()
                        executeService(DataUser: updateInfo)
                    }
                }else if txtInterest.text == "Otro (cuál)" && ((txtOtherInterest.text?.isEmpty) != nil) ||  txtIngenio.text == "Otro (Cuál)" && txtOtherIngenio.text?.isEmpty ?? false || txtJob.text == "Otro" &&  txtDepartament.text?.isEmpty ?? false {
                       checkOptionales()
                }else {
                   addDataService()
                   executeService(DataUser: updateInfo)
                }
            }else{
                checkSectionJob()
            }
          case .PhoneOffice:
            if UITextField.validateAll(textFields: [txtPhoneOffice,txtExt]) && txtPhoneOffice.text?.count ?? 0 == 10{
              addDataService()
              executeService(DataUser: updateInfo)
            }else{
                checkPhoneNumber()
            }
          case .Cell:
            if UITextField.validateAll(textFields: [txtCellPhone]) && txtCellPhone.text?.count ?? 0 == 10{
              addDataService()
              executeService(DataUser: updateInfo)
            }else {
                if txtCellPhone.text?.isEmpty ?? false {
                    lblErrorCellPhone.text = "Ingresa un número de celular"
                }else {
                  lblErrorCellPhone.text = "Ingresa un número de celular válido"
                }
            }
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    
}

//MARK: PickerDelegate
extension EditProfile_ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataPicker.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataPicker[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch typeOfPickerEditProfile_Enum(rawValue: iSeccionUpdate ) {
        case .Estado:
             txtEstado.text = dataPicker[row]
        case .Municipio:
            txtMunicipio.text = dataPicker[row]
        case .AreaDeInteres:
            txtInterest.text = dataPicker[row]
            if txtInterest.text == "Otro (cuál)" {
             lycHeightJob.constant = lycHeightJob.constant + 60
             lycInterest.constant = 60
             txtOtherInterest.isHidden = false
            }else {
                lycInterest.constant = 25
                txtOtherInterest.isHidden = true
            }
        case .Ingenio:
            txtIngenio.text = dataPicker[row]
            if txtIngenio.text == "Otro (Cuál)"{
            lycHeightJob.constant = lycHeightJob.constant + 60
            lycCurrentIngenio.constant = 60
            txtOtherIngenio.isHidden = false
            }else{
                lycCurrentIngenio.constant = 25
                txtOtherIngenio.isHidden = true
            }
        case .departamento:
            txtJob.text = dataPicker[row]
            if txtJob.text == "Otro"{
                txtDepartament.isHidden = false
            }else{
               txtDepartament.isHidden = true
            }
        default:
            return
        }
        
    }
}

//MARK: TextFieldDelegate
extension EditProfile_ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resetErrorLabel()
        if textField.tag == 2 && txtEstado.text?.isEmpty ?? false{
            lblErrorMunicipio.text = "Selecciona un estado"
        }else {
            switch typeOfPickerEditProfile_Enum(rawValue: textField.tag ) {
            case  .Calle:
                   iSeccionUpdate = typeOfPickerEditProfile_Enum.Calle.rawValue
                  changeColorBackgroundView()
            case  .interesOpcional:
                  iSeccionUpdate = typeOfPickerEditProfile_Enum.interesOpcional.rawValue
                 changeColorBackgroundView()
            case .Estado:
                  txtMunicipio.text = ""
                  iSeccionUpdate = typeOfPickerEditProfile_Enum.Estado.rawValue
                  dataPicker = ArrEstados
                  textFieldWithPicker()
                  picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                  picker.selectRow(0, inComponent: 0, animated: true)
                 changeColorBackgroundView()
            case .Municipio:
                 iSeccionUpdate = typeOfPickerEditProfile_Enum.Municipio.rawValue
                dataPicker = returnMunicipios().municipios(Estado: txtEstado.text ?? "")
                textFieldWithPicker()
                 picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
                changeColorBackgroundView()
            case .Trabajo:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.Trabajo.rawValue
                changeColorBackgroundView()
            case .AreaDeInteres:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.AreaDeInteres.rawValue
                changeColorBackgroundView()
                dataPicker = arrAreasDeInteres
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .Ingenio:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.Ingenio.rawValue
                changeColorBackgroundView()
                dataPicker = arrIngenio
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .optionaIngenio :
                iSeccionUpdate = typeOfPickerEditProfile_Enum.optionaIngenio.rawValue
                changeColorBackgroundView()
            case .departamento:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.departamento.rawValue
                changeColorBackgroundView()
                dataPicker = arrDepartamento
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .optionalDepartment:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.optionalDepartment.rawValue
                     changeColorBackgroundView()
            case .PhoneOffice:
                iSeccionUpdate = typeOfPickerEditProfile_Enum.PhoneOffice.rawValue
                changeColorBackgroundView()
            case .Cell :
                iSeccionUpdate = typeOfPickerEditProfile_Enum.Cell.rawValue
                changeColorBackgroundView()
            default:
                return
               }
        }
    }
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == typeOfPickerEditProfile_Enum.Municipio.rawValue || textField.tag == typeOfPickerEditProfile_Enum.Estado.rawValue || textField.tag == typeOfPickerEditProfile_Enum.AreaDeInteres.rawValue || textField.tag == typeOfPickerEditProfile_Enum.Ingenio.rawValue || textField.tag == typeOfPickerEditProfile_Enum.departamento.rawValue{
            return false
        }else {
            return true
        }
    }
}
