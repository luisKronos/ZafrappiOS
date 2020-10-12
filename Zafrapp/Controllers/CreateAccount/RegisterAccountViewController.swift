//
//  RegisterAccountViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/4/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class RegisterAccountViewController: ZPMasterViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum String {
            static let privacyPoliciesUrl = "https://zafrapp.com/docs/aviso-de-privacidad.pdf"
            static let termsAndConditionsUrl = "https://zafrapp.com/docs/terminos-y-condiciones.pdf"
            static let termsAndConditions = "Términos y Condiciones"
            static let privacyPolicies = "Políticas de Privacidad"
            static let and = " y"
        }
        
        enum Font {
            static let termsAndCondition = UIFont.systemFont(ofSize: 15.0)
            static let privacyPolicies = UIFont.systemFont(ofSize: 15.0)
        }
        
        enum Color {
            static let termsAndConditonsTitle = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        }
    }
    // MARK: - IBOutlets
    @IBOutlet private var backgroundImageView: UIImageView!
    @IBOutlet private var passwordTextField: ZPDesignableUITextField! {
        didSet{
            passwordTextField.delegate = self
        }
    }
    @IBOutlet private var nameTextField: ZPDesignableUITextField! {
        didSet{
            nameTextField.delegate = self
        }
    }
    @IBOutlet private var emailTextField: ZPDesignableUITextField! {
        didSet{
            emailTextField.delegate = self
        }
    }
    @IBOutlet private var cellphoneTextField: ZPDesignableUITextField! {
        didSet{
            cellphoneTextField.delegate = self
        }
    }
    @IBOutlet private var publishPhoneSwitch: UISwitch!
    @IBOutlet private var professionTextField: ZPDesignableUITextField! {
        didSet{
            professionTextField.delegate = self
        }
    }
    @IBOutlet private var searchJobSwitch: UISwitch!
    @IBOutlet private var jobDepartmentTextField: ZPDesignableUITextField! {
        didSet{
            jobDepartmentTextField.delegate = self
        }
    }
    @IBOutlet private var workPlaceTextField: ZPDesignableUITextField! {
        didSet{
            workPlaceTextField.delegate = self
        }
    }
    @IBOutlet private var otherDeparmentTextField: ZPDesignableUITextField! {
        didSet{
            otherDeparmentTextField.delegate = self
        }
    }
    @IBOutlet private var otherIngenioTextField: ZPDesignableUITextField! {
        didSet{
            otherIngenioTextField.delegate = self
        }
    }
    
    @IBOutlet private var dayTextField: ZPDesignableUITextField! {
        didSet{
            dayTextField.delegate = self
        }
    }
    @IBOutlet private var monthTextField: ZPDesignableUITextField! {
        didSet {
            monthTextField.delegate = self
        }
    }
    @IBOutlet private var yearTextField: ZPDesignableUITextField! {
        didSet{
            yearTextField.delegate = self
        }
    }
    
    @IBOutlet private var otherDeparmentErrorLabel: UILabel!
    @IBOutlet private var otherIngenioErrorLabel: UILabel!
    @IBOutlet private var nameErrorLabel: UILabel!
    @IBOutlet private var emailErrorLabel: UILabel!
    @IBOutlet private var cellphoneErrorLabel: UILabel!
    @IBOutlet private var birthdayErrorLabel: UILabel!
    @IBOutlet private var currentJobErrorLabel: UILabel!
    @IBOutlet private var professionErrorLabel: UILabel!
    @IBOutlet private var placeWorkErrorLabel: UILabel!
    @IBOutlet private var passwordErrorLabel: UILabel!
    @IBOutlet private var lycDepartmentHeighConstraint: NSLayoutConstraint!
    @IBOutlet private var lyvIngenioHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var termsAndConditionsButton: UIButton!
    @IBOutlet private var privacyPoliciesButton: UIButton!
    
    // MARK: - Private Properties
    
    private let datePicker = UIDatePicker()
    private var picker = UIPickerView()
    private var pickerType = 0
    private var workPlaces: [String] = []
    private var activeTextField = UITextField()
    private var dataRegistered = RegisterAccount()
    
    // MARK: -  View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        lyvIngenioHeightConstraint.constant = 80
        lycDepartmentHeighConstraint.constant = 30
        otherDeparmentTextField.isHidden = true
        otherIngenioTextField.isHidden = true
        searchJobSwitch.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        publishPhoneSwitch.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
    }
    
    // MARK: - IBActions
    
    @IBAction func registerAction(_ sender: Any) {
        if UITextField.validateAll(textFields: [nameTextField,emailTextField,cellphoneTextField,dayTextField,monthTextField,yearTextField,professionTextField,jobDepartmentTextField,workPlaceTextField]) && ((emailTextField.validateEmail(field: emailTextField) != nil)) && cellphoneTextField.text?.count == 10 && Int(dayTextField.text ?? "0") ?? 0 < 32  && Int(monthTextField.text ?? "0") ?? 0 < 13 && Int(yearTextField.text ?? "") ?? 0 < 2020{
            if jobDepartmentTextField.text == "Otro" && workPlaceTextField.text == "Otro (Cuál)"{
                if !(otherIngenioTextField.text?.isEmpty ?? false) && !(otherDeparmentTextField.text?.isEmpty ?? false){
                    saveAllAndService (department: otherDeparmentTextField.text! , ingenio: otherIngenioTextField.text!)
                } else {
                    checkOptionalesDptEIngenio()
                }
            } else if  jobDepartmentTextField.text == "Otro" || workPlaceTextField.text == "Otro (Cuál)"{
                checkOptionalesDptEIngenio()
            } else {
                saveAllAndService(department: jobDepartmentTextField.text!, ingenio: workPlaceTextField.text!)
            }
        } else {
            self.present(ZPAlertGeneric.oneOption(title: "Campos incompletos", message: "Completar todos los campos", actionTitle: AppConstants.String.accept),animated: true)
            checkFields()
        }
    }
    
    @IBAction func openTermsAndConditionsAction(_ sender: Any) {
        guard let termsAndCoditionsUrl = URL(string: Constants.String.termsAndConditionsUrl) else {
            return
        }
        guard UIApplication.shared.canOpenURL(termsAndCoditionsUrl) else {
            return
        }
        UIApplication.shared.open(termsAndCoditionsUrl, options: [:], completionHandler: nil)
    }
    
    @IBAction func openPrivacyPoliciesAction(_ sender: Any) {
        guard let privacyPoliciesUrl = URL(string: Constants.String.privacyPoliciesUrl) else {
            return
        }
        guard UIApplication.shared.canOpenURL(privacyPoliciesUrl) else {
            return
        }
        UIApplication.shared.open(privacyPoliciesUrl, options: [:], completionHandler: nil)
    }
    
}

// MARK :- Private Methods

private extension RegisterAccountViewController {
    
    func configureButton() {
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byWordWrapping

        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: Constants.Color.termsAndConditonsTitle,
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.font : Constants.Font.termsAndCondition,
            NSAttributedString.Key.paragraphStyle : style
        ]
        
        let termsAndConditionsAttributedString = NSMutableAttributedString(string: Constants.String.termsAndConditions, attributes: attributes)
        
        var andAttributes = attributes
        andAttributes.removeValue(forKey: NSAttributedString.Key.underlineStyle)
        
        let andAttributedString = NSAttributedString(string: Constants.String.and, attributes: andAttributes)
        
        termsAndConditionsAttributedString.append(andAttributedString)
        termsAndConditionsButton.setAttributedTitle(termsAndConditionsAttributedString, for: .normal)
        
        let privacyPoliciesAttributedString = NSMutableAttributedString(string: Constants.String.privacyPolicies, attributes: attributes)
        
        privacyPoliciesButton.setAttributedTitle(privacyPoliciesAttributedString, for: .normal)
    }
    
    func checkOptionalesDptEIngenio() {
        if !(otherIngenioTextField.text?.isEmpty ?? false) && workPlaceTextField.text == "Otro (Cuál)" {
            saveAllAndService(department: jobDepartmentTextField.text!, ingenio: otherIngenioTextField.text!)
        } else if (otherIngenioTextField.text?.isEmpty ?? false) && workPlaceTextField.text == "Otro (Cuál)" {
            otherIngenioErrorLabel.text = "Ingresa tus datos"
        }
        
        if !(otherDeparmentTextField.text?.isEmpty ?? false) && jobDepartmentTextField.text == "Otro"{
            saveAllAndService(department: otherDeparmentTextField.text!, ingenio: workPlaceTextField.text!)
        } else if (otherDeparmentTextField.text?.isEmpty ?? false) && jobDepartmentTextField.text == "Otro" {
            otherDeparmentErrorLabel.text = "Ingresa tus datos"
        }
    }
    
    func saveAllAndService(department: String , ingenio: String) {
        dataRegistered.name = nameTextField.text
        dataRegistered.email = emailTextField.text
        dataRegistered.phone = Int(cellphoneTextField.text ?? "")
        dataRegistered.birthdate = "\(dayTextField.text ?? "")/\(monthTextField.text ?? "")/\(yearTextField.text ?? "")"
        dataRegistered.currentJob = professionTextField.text
        dataRegistered.workPlace = ingenio
        dataRegistered.workDepartment = department
        dataRegistered.isCellphoneShared = publishPhoneSwitch.isOn
        dataRegistered.isSearchingJob = searchJobSwitch.isOn
        dataRegistered.password = passwordTextField.text
        
        executeService(userData: dataRegistered)
    }
    
    func showSuccessAccountCreated() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SucessAccountVC") as? AccountSuccessViewController
        vc?.delegate = self
        vc?.modalPresentationStyle = .fullScreen
        present(vc ?? AccountSuccessViewController(), animated: true, completion: nil)
    }
    
    func executeService(userData: RegisterAccount?) {
        self.activityIndicatorBegin()
        let service = CreateAccountService()
        service.createAccount(data: userData ?? RegisterAccount()) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.showSuccessAccountCreated()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func checkFields() {
        if nameTextField.text?.isEmpty ?? false {
            nameErrorLabel.text = "Ingresa tu nombre"
        }
        if emailTextField.text?.isEmpty ?? false {
            emailErrorLabel.text = "Ingresa tu correo"
        } else if !(emailTextField.validateEmail(field: emailTextField) != nil){
            emailErrorLabel.text = "Ingresa un correo válido"
        }
        if cellphoneTextField.text?.isEmpty ?? false{
            cellphoneErrorLabel.text = "Ingresa tu número celular"
        } else if cellphoneTextField.text?.count ?? 0 < 10 {
            cellphoneErrorLabel.text = "Ingresa un número válido"
        }
        if yearTextField.text?.isEmpty ?? false || monthTextField.text?.isEmpty ?? false || dayTextField.text?.isEmpty ?? false{
            birthdayErrorLabel.text = "Ingresa una fecha"
        } else if  Int(dayTextField.text ?? "0") ?? 0 > 31  || Int(monthTextField.text ?? "0") ?? 0 > 12 || Int(yearTextField.text ?? "") ?? 0 > 2019{
            birthdayErrorLabel.text = "Ingresa una fecha válida"
        }
        if professionTextField.text?.isEmpty ?? false{
            professionErrorLabel.text = "Selecciona una profesión"
        }
        if jobDepartmentTextField.text?.isEmpty ?? false{
            currentJobErrorLabel.text = "Selecciona un ingenio"
        }
        if workPlaceTextField.text?.isEmpty ?? false{
            placeWorkErrorLabel.text = "Selecciona un departamento "
        }
        if passwordTextField.text?.isEmpty ?? false {
            passwordErrorLabel.text = "Ingresa una contraseña "
        }
    }
    
    func showPickerView() {
        picker.delegate = self
        picker.dataSource = self
        picker.backgroundColor = .white
        
        jobDepartmentTextField.inputView = picker
        workPlaceTextField.inputView = picker
    }
}

// MARK: -  Textfield Delegate

extension RegisterAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == PickerDataType.ingenio.rawValue || textField.tag == PickerDataType.birthDay.rawValue || textField.tag == PickerDataType.suburb.rawValue {
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        otherIngenioErrorLabel.text = ""
        otherDeparmentErrorLabel.text = ""
        passwordErrorLabel.text = ""
        placeWorkErrorLabel.text = ""
        emailErrorLabel.text = ""
        currentJobErrorLabel.text = ""
        passwordErrorLabel.text = ""
        cellphoneErrorLabel.text = ""
        birthdayErrorLabel.text = ""
        professionErrorLabel.text = ""
        placeWorkErrorLabel.text = ""
        nameErrorLabel.text = ""
        birthdayErrorLabel.text = ""
        if textField.tag == PickerDataType.suburb.rawValue {
            lycDepartmentHeighConstraint.constant = 30
            otherDeparmentTextField.isHidden = true
            pickerType = PickerDataType.suburb.rawValue
            workPlaces = departamentoArray
            showPickerView()
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
            picker.selectRow(0, inComponent: 0, animated: true)
        } else if textField.tag == PickerDataType.ingenio.rawValue {
            otherIngenioTextField.isHidden = true
            lyvIngenioHeightConstraint.constant = 80
            pickerType = PickerDataType.ingenio.rawValue
            workPlaces = ingenioArray
            showPickerView()
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        } else if textField.tag == PickerDataType.birthDay.rawValue {
            pickerType = PickerDataType.birthDay.rawValue
            picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
        }
    }
}


// MARK: -  Picker Delegate

extension RegisterAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: workPlaces[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workPlaces.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workPlaces[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == PickerDataType.suburb.rawValue {
            jobDepartmentTextField.text = workPlaces[row]
            if jobDepartmentTextField.text == "Otro" {
                otherDeparmentTextField.isHidden = false
                lycDepartmentHeighConstraint.constant = 102
            } else {
                lycDepartmentHeighConstraint.constant = 30
            }
        } else {
            workPlaceTextField.text = workPlaces[row]
            if workPlaceTextField.text == "Otro (Cuál)" {
                otherIngenioTextField.isHidden = false
                lyvIngenioHeightConstraint.constant = 155
            } else {
                lyvIngenioHeightConstraint.constant = 80
            }
        }
    }
}

// MARK: -  ReturnRootDelegate Delegate

extension RegisterAccountViewController: ReturnRootDelegate {
    func returnLogin() {
        self.navigationController?.popViewController(animated: false)
    }
    
    
}
