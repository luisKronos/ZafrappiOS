//
//  EditProfileViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class EditProfileViewController: ZPMasterViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        enum String {
            static let instructions = NSLocalizedString("Para actualizar tus datos presiona el botón de guardar, cada vez que modifiques al menos un campo por sección", comment: "")
        }
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var stateTextField: ZPDesignableUITextField! {
        didSet{
            stateTextField.delegate = self
        }
    }
    @IBOutlet private var suburbTextField: ZPDesignableUITextField! {
        didSet{
            suburbTextField.delegate = self
        }
    }
    @IBOutlet private var professionTextField: ZPDesignableUITextField! {
        didSet{
            professionTextField.delegate = self
        }
    }
    
    @IBOutlet private var officePhone: ZPDesignableUITextField! {
        didSet{
            officePhone.delegate = self
        }
    }
    @IBOutlet private var extensionTextField: ZPDesignableUITextField! {
        didSet{
            extensionTextField.delegate = self
        }
    }
    @IBOutlet private var searchJobSwitch: UISwitch!
    @IBOutlet private var showCellSwitch: UISwitch!
    @IBOutlet private var cellphoneTextField: ZPDesignableUITextField! {
        didSet{
            cellphoneTextField.delegate = self
        }
    }
    @IBOutlet private var jobTextField: ZPDesignableUITextField! {
        didSet{
            jobTextField.delegate = self
        }
    }
    @IBOutlet private var ingenioTextField: ZPDesignableUITextField! {
        didSet{
            ingenioTextField.delegate = self
        }
    }
    @IBOutlet private var streetTextField: ZPDesignableUITextField! {
        didSet{
            streetTextField.delegate = self
        }
    }
    
    @IBOutlet private var numberTextField: ZPDesignableUITextField! {
        didSet{
            numberTextField.delegate = self
        }
    }
    @IBOutlet private var zipTextField: ZPDesignableUITextField! {
        didSet{
            zipTextField.delegate = self
        }
    }
    @IBOutlet private var interestTextField: ZPDesignableUITextField! {
        didSet{
            interestTextField.delegate = self
        }
    }
    
    @IBOutlet private var otherInterestTextField: ZPDesignableUITextField! {
        didSet{
            otherInterestTextField.delegate = self
        }
    }
    @IBOutlet private var otherIngenioTextField: ZPDesignableUITextField! {
        didSet{
            otherIngenioTextField.delegate = self
        }
    }
    
    @IBOutlet private var departamentTextField: ZPDesignableUITextField! {
        didSet{
            departamentTextField.delegate = self
        }
    }
    
    @IBOutlet private var instructionsLabel: UILabel!
    @IBOutlet private var showCellLabel: ZpLabel!
    @IBOutlet private var jobSearchLabel: ZpLabel!
    @IBOutlet private var cellphoneView: UIView!
    @IBOutlet private var addressView: UIView!
    @IBOutlet private var interestView: UIView!
    @IBOutlet private var phoneView: UIView!
    @IBOutlet private var cellphoneErrorLabel: UILabel!
    @IBOutlet private var streetErrorLabel: UILabel!
    @IBOutlet private var stateErrorLabel: UILabel!
    @IBOutlet private var suburbErrorLabel: UILabel!
    @IBOutlet private var numberErrorLabel: UILabel!
    @IBOutlet private var zipLabel: UILabel!
    @IBOutlet private var professionErrorLabel: UILabel!
    @IBOutlet private var interesErrorLabel: UILabel!
    @IBOutlet private var ingenioErrorLabel: UILabel!
    @IBOutlet private var departmentErrorLabel: UILabel!
    @IBOutlet private var officePhoneErrorLabel: UILabel!
    @IBOutlet private var otherDepartmentErrorLabel: UILabel!
    @IBOutlet private var otherIngenioErrorLabel: UILabel!
    @IBOutlet private var extensionErrorLabel: UILabel!
    @IBOutlet private var otherInterestErrorLabel: UILabel!
    @IBOutlet private var lycHeightJobConstraint: NSLayoutConstraint!
    @IBOutlet private var lycInterestConstraint: NSLayoutConstraint!
    @IBOutlet private var lycCurrentIngenioConstraint: NSLayoutConstraint!
    
    // MARK: - Private Properties
    
    private var sectionUpdated = 0
    private let picker = UIPickerView()
    private var dataPicker: [String] = []
    private var indicator = UIActivityIndicatorView()
    private var updateInfo = UpdateData()
    private var informationUser: Response?
    private var informationFill: Response?
    
    // MARK: - Public Properties
    
    var imageProfile: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        addData()
        adjustImageRound()
        searchJobSwitch.addTarget(self, action: #selector(onSwitchValueChanged), for: .touchUpInside)
        informationUser = InformationClasify.sharedInstance.data
        
        // Disable IQKeyboardManager because of how tag were set
        // needs to refactor this view to use IQKeyboardManager
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    // MARK: -  IBAction
    
    @IBAction func switchSearchJob(_ sender: UISwitch) {
        sectionUpdated = EditProfilePickerType.interestArea.rawValue
        changeColorBackgroundView()
    }
    
    @IBAction func switchShowCell(_ sender: UISwitch) {
        sectionUpdated = EditProfilePickerType.cell.rawValue
        changeColorBackgroundView()
    }
    
    func checkOptionales() {
        if otherInterestTextField.text?.isEmpty ?? false && interestTextField.text == "Otro (cuál)" {
            otherInterestErrorLabel.text = "Ingresa un área de interés"
        }
        if otherIngenioTextField.text?.isEmpty ?? false && ingenioTextField.text == "Otro (Cuál)" {
            otherIngenioErrorLabel.text = "Ingresa un ingenio"
        }
        
        if departamentTextField.text?.isEmpty ?? false && jobTextField.text == "Otro" {
            otherDepartmentErrorLabel.text = "Ingresa un departamento"
        }
    }
    
    @IBAction func saveData(_ sender: Any) {
        switch EditProfilePickerType(rawValue: sectionUpdated ) {
        case .state, .suburb,.street:
            if UITextField.validateAll(textFields: [stateTextField,suburbTextField,streetTextField,numberTextField,zipTextField]) &&  zipTextField.text?.count ?? 0 == 5 {
                addDataService()
                executeService(dataUser: updateInfo)
            } else {
                checkSectionAddress()
            }
        case .work, .interestArea, .ingenio, .department,.interestOptional, . departmentOptional, .ingenioOptional:
            if UITextField.validateAll(textFields: [professionTextField,interestTextField]){
                if interestTextField.text == "Otro (cuál)" && ingenioTextField.text == "Otro (Cuál)" && jobTextField.text == "Otro"{
                    if otherIngenioTextField.text?.isEmpty ?? false || departamentTextField.text?.isEmpty ?? false || otherInterestTextField.text?.isEmpty ?? false {
                        checkOptionales()
                    } else {
                        addDataService()
                        executeService(dataUser: updateInfo)
                    }
                } else if interestTextField.text == "Otro (cuál)" && ((otherInterestTextField.text?.isEmpty) != nil) ||  ingenioTextField.text == "Otro (Cuál)" && otherIngenioTextField.text?.isEmpty ?? false || jobTextField.text == "Otro" &&  departamentTextField.text?.isEmpty ?? false {
                    checkOptionales()
                } else {
                    addDataService()
                    executeService(dataUser: updateInfo)
                }
            } else {
                checkSectionJob()
            }
        case .officePhone:
            if UITextField.validateAll(textFields: [officePhone,extensionTextField]) && officePhone.text?.count ?? 0 == 10{
                addDataService()
                executeService(dataUser: updateInfo)
            } else {
                checkPhoneNumber()
            }
        case .cell:
            if UITextField.validateAll(textFields: [cellphoneTextField]) && cellphoneTextField.text?.count ?? 0 == 10{
                addDataService()
                executeService(dataUser: updateInfo)
            } else {
                if cellphoneTextField.text?.isEmpty ?? false {
                    cellphoneErrorLabel.text = "Ingresa un número de celular"
                } else {
                    cellphoneErrorLabel.text = "Ingresa un número de celular válido"
                }
            }
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
}

// MARK: - Private Methods

private extension EditProfileViewController {
    
    func configureLabel() {
        instructionsLabel.numberOfLines = 0
        instructionsLabel.font = ZafrappTheme.Font.Profile.instruction
        instructionsLabel.text = Constants.String.instructions
    }
    
    @objc func onSwitchValueChanged(_ switchS: UISwitch) {
        if switchS.tag == EditProfilePickerType.work.rawValue {
            sectionUpdated = EditProfilePickerType.work.rawValue
        } else if switchS.tag == EditProfilePickerType.cell.rawValue {
            sectionUpdated = EditProfilePickerType.cell.rawValue
        }
    }
    
    func textFieldWithPicker() {
        picker.delegate = self
        picker.dataSource = self
        stateTextField.inputView = picker
        suburbTextField.inputView = picker
        interestTextField.inputView = picker
        ingenioTextField.inputView = picker
        jobTextField.inputView = picker
    }
    func adjustImageRound() {
        showCellSwitch.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        searchJobSwitch.transform = CGAffineTransform(scaleX: 0.50, y: 0.50)
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1)
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true
        
        if imageProfile != nil {
            profileImageView.image = imageProfile
        }
    }
    
    func addData() {
        lycHeightJobConstraint.constant = 330
        otherIngenioTextField.isHidden = true
        otherInterestTextField.isHidden = true
        departamentTextField.isHidden = true
        
        informationFill =  InformationClasify.sharedInstance.data
        stateTextField.text = informationFill?.messageResponse?.state
        suburbTextField.text = informationFill?.messageResponse?.suburb
        streetTextField.text = informationFill?.messageResponse?.street
        numberTextField.text = informationFill?.messageResponse?.placeNumber
        officePhone.text = informationFill?.messageResponse?.officeNumber
        extensionTextField.text = informationFill?.messageResponse?.extension
        professionTextField.text = informationFill?.messageResponse?.currentJob
        searchJobSwitch.isOn = informationFill?.messageResponse?.isSearchWorkString == "1"
        interestTextField.text = informationFill?.messageResponse?.interest
        nameLabel.text = informationFill?.messageResponse?.name
        emailLabel.text = informationFill?.messageResponse?.email
        jobTextField.text = informationFill?.messageResponse?.wordDepartment
        cellphoneTextField.text = informationFill?.messageResponse?.cellphone
        ingenioTextField.text = informationFill?.messageResponse?.workPlace
        showCellSwitch.isOn = informationFill?.messageResponse?.isCellPhoneSharedString == "1"
        zipTextField.text =  informationFill?.messageResponse?.zip
    }
    
    func executeService(dataUser: UpdateData?) {
        self.activityIndicatorBegin()
        let service = SeccionsProfileService()
        service.updateInfoProfile(data: dataUser ?? UpdateData() , seccion: sectionUpdated) { [weak self] (response, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && response != nil {
                if response?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: response?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.updateinfoSaved()
                    self.present(ZPAlertGeneric.oneOption(title: "Correcto", message: response?.message, actionTitle: AppConstants.String.accept),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func updateinfoSaved() {
        var saveInfo = InformationClasify.sharedInstance.data?.messageResponse
        
        switch EditProfilePickerType(rawValue: sectionUpdated) {
        case .state, .suburb,.street:
            saveInfo?.state  = stateTextField.text
            saveInfo?.suburb = suburbTextField.text
            saveInfo?.street = streetTextField.text
            saveInfo?.placeNumber = numberTextField.text
            saveInfo?.zip = zipTextField.text ?? ""
            saveInfo?.userId = informationUser?.messageResponse?.userId
            saveInfo?.addressId = informationUser?.messageResponse?.addressId
        case .work, .interestArea, .interestOptional,.department, .ingenio, .departmentOptional, .ingenioOptional:
            saveInfo?.email = informationUser?.messageResponse?.email
            saveInfo?.currentJob = professionTextField.text
            saveInfo?.isSearchWorkString = String(searchJobSwitch.isOn)
            saveInfo?.interestArea = InterestedArea().returnAreaInterest(area: interestTextField.text ?? "")
            if interestTextField.text == "Otro (cuál)"{
                saveInfo?.interest = otherInterestTextField.text
            } else {
                saveInfo?.interest = interestTextField.text
            }
            if ingenioTextField.text == "Otro (Cuál)" {
                saveInfo?.workPlace = otherIngenioTextField.text
            } else {
                saveInfo?.workPlace = ingenioTextField.text
            }
            if jobTextField.text == "Otro"{
                saveInfo?.wordDepartment = departamentTextField.text
            } else {
                saveInfo?.wordDepartment = jobTextField.text
            }
        case .officePhone:
            saveInfo?.email = informationUser?.messageResponse?.email
            saveInfo?.officeNumber = officePhone.text
            saveInfo?.extension = extensionTextField.text
        case .cell:
            saveInfo?.cellphone = cellphoneTextField.text
            saveInfo?.isCellPhoneSharedString = String(showCellSwitch.isOn)
            saveInfo?.email = informationUser?.messageResponse?.email
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    func addDataService() {
        switch EditProfilePickerType(rawValue: sectionUpdated ) {
        case .state, .suburb,.street:
            updateInfo.state = stateTextField.text
            updateInfo.suburb = suburbTextField.text
            updateInfo.street = streetTextField.text
            updateInfo.streetNumber = numberTextField.text
            updateInfo.zip = Int(zipTextField.text ?? "")
            updateInfo.userId = informationUser?.messageResponse?.userId
            updateInfo.addressId = informationUser?.messageResponse?.addressId
        case .work, .interestArea,.department, .ingenio, .interestOptional, .ingenioOptional, .departmentOptional:
            
            if interestTextField.text == "Otro (cuál)" {
                updateInfo.interest = otherInterestTextField.text
            } else {
                updateInfo.interest = interestTextField.text
            }
            if ingenioTextField.text == "Otro (Cuál)" {
                updateInfo.workPlace = otherIngenioTextField.text
            } else {
                updateInfo.workPlace = ingenioTextField.text
            }
            if jobTextField.text == "Otro"{
                updateInfo.workDepartment = departamentTextField.text
            } else {
                updateInfo.workDepartment = jobTextField.text
            }
            updateInfo.email = informationUser?.messageResponse?.email
            updateInfo.currentJob = professionTextField.text
            updateInfo.isSearchingWork = searchJobSwitch.isOn
        case .officePhone:
            updateInfo.email = informationUser?.messageResponse?.email
            updateInfo.officeNumber = Int(officePhone.text ?? "")
            updateInfo.extension = Int(extensionTextField.text ?? "")
        case .cell:
            updateInfo.cellphone = Int(cellphoneTextField.text ?? "")
            updateInfo.isCellShown = showCellSwitch.isOn
            updateInfo.email = informationUser?.messageResponse?.email
        default:
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
    
    func resetErrorLabel() {
        otherInterestErrorLabel.text = ""
        stateErrorLabel.text = ""
        suburbErrorLabel.text = ""
        streetErrorLabel.text = ""
        numberErrorLabel.text = ""
        zipLabel.text = ""
        professionErrorLabel.text = ""
        interesErrorLabel.text = ""
        ingenioErrorLabel.text = ""
        departmentErrorLabel.text = ""
        officePhoneErrorLabel.text = ""
        extensionErrorLabel.text = ""
        cellphoneErrorLabel.text = ""
        otherIngenioErrorLabel.text = ""
        otherDepartmentErrorLabel.text = ""
    }
    
    func checkSectionAddress() {
        if stateTextField.text?.isEmpty ?? false {
            stateErrorLabel.text = "Selecciona un estado"
        }
        if suburbTextField.text?.isEmpty ?? false {
            suburbErrorLabel.text = "Selecciona un municipio"
        }
        if streetTextField.text?.isEmpty ?? false {
            streetErrorLabel.text = "Ingresa tu calle"
        }
        if numberTextField.text?.isEmpty ?? false {
            numberErrorLabel.text = "Ingresa el número"
        }
        if zipTextField.text?.isEmpty ?? false {
            zipLabel.text = "Ingresa tu código postal"
        } else if zipTextField.text?.count ?? 0 < 5{
            zipLabel.text = "Ingresa un código postal válido"
        }
    }
    func checkPhoneNumber() {
        if officePhone.text?.isEmpty ?? false {
            officePhoneErrorLabel.text = "Ingresa un número"
        } else if officePhone.text?.count ?? 0 < 10 {
            officePhoneErrorLabel.text = "Ingresa un número válido"
        }
        if extensionTextField.text?.isEmpty ?? false{
            extensionErrorLabel.text = "Ingresa una extension"
        }
    }
    func checkSectionJob() {
        if professionTextField.text?.isEmpty ?? false{
            professionErrorLabel.text = "Selecciona tu profesión"
        }
        if interestTextField.text?.isEmpty ?? false {
            interesErrorLabel.text = "Selecciona un área de interés"
        }
        if ingenioTextField.text?.isEmpty ?? false {
            ingenioErrorLabel.text = "Selecciona un ingenio"
        }
        if jobTextField.text?.isEmpty ?? false {
            departmentErrorLabel.text = "Selecciona un departamento"
        }
    }
    
    func changeColorBackgroundView() {
        switch EditProfilePickerType(rawValue: sectionUpdated ) {
        case .state, .suburb, .street:
            addressView.backgroundColor = .white
            interestView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            phoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            cellphoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
        case .interestArea, .work, .ingenio, .department, .interestOptional, .departmentOptional, .ingenioOptional:
            interestView.backgroundColor = .white
            phoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            cellphoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            addressView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
        case .officePhone:
            interestView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            cellphoneView.backgroundColor = .white
            phoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            addressView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
        case .cell:
            interestView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            cellphoneView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
            phoneView.backgroundColor = .white
            addressView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9647058824, blue: 0.9764705882, alpha: 1)
        default:
            return
        }
    }
}

// MARK: -  PickerDelegate

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        switch EditProfilePickerType(rawValue: sectionUpdated ) {
        case .state:
            stateTextField.text = dataPicker[row]
        case .suburb:
            suburbTextField.text = dataPicker[row]
        case .interestArea:
            interestTextField.text = dataPicker[row]
            if interestTextField.text == "Otro (cuál)" {
                lycHeightJobConstraint.constant = lycHeightJobConstraint.constant + 60
                lycInterestConstraint.constant = 60
                otherInterestTextField.isHidden = false
            } else {
                lycInterestConstraint.constant = 25
                otherInterestTextField.isHidden = true
            }
        case .ingenio:
            ingenioTextField.text = dataPicker[row]
            if ingenioTextField.text == "Otro (Cuál)" {
                lycHeightJobConstraint.constant = lycHeightJobConstraint.constant + 60
                lycCurrentIngenioConstraint.constant = 60
                otherIngenioTextField.isHidden = false
            } else {
                lycCurrentIngenioConstraint.constant = 25
                otherIngenioTextField.isHidden = true
            }
        case .department:
            jobTextField.text = dataPicker[row]
            if jobTextField.text == "Otro" {
                departamentTextField.isHidden = false
            } else {
                departamentTextField.isHidden = true
            }
        default:
            return
        }
        
    }
}

// MARK: -  TextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        resetErrorLabel()
        if textField.tag == 2 && stateTextField.text?.isEmpty ?? false{
            suburbErrorLabel.text = "Selecciona un estado"
        } else {
            switch EditProfilePickerType(rawValue: textField.tag ) {
            case  .street:
                sectionUpdated = EditProfilePickerType.street.rawValue
                changeColorBackgroundView()
            case  .interestOptional:
                sectionUpdated = EditProfilePickerType.interestOptional.rawValue
                changeColorBackgroundView()
            case .state:
                suburbTextField.text = ""
                sectionUpdated = EditProfilePickerType.state.rawValue
                dataPicker = statesArray
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
                changeColorBackgroundView()
            case .suburb:
                sectionUpdated = EditProfilePickerType.suburb.rawValue
                dataPicker = SuburbInformation().suburbs(for: stateTextField.text ?? "")
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
                changeColorBackgroundView()
            case .work:
                sectionUpdated = EditProfilePickerType.work.rawValue
                changeColorBackgroundView()
            case .interestArea:
                sectionUpdated = EditProfilePickerType.interestArea.rawValue
                changeColorBackgroundView()
                dataPicker = interestArray
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .ingenio:
                sectionUpdated = EditProfilePickerType.ingenio.rawValue
                changeColorBackgroundView()
                dataPicker = ingenioArray
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .ingenioOptional :
                sectionUpdated = EditProfilePickerType.ingenioOptional.rawValue
                changeColorBackgroundView()
            case .department:
                sectionUpdated = EditProfilePickerType.department.rawValue
                changeColorBackgroundView()
                dataPicker = departamentoArray
                textFieldWithPicker()
                picker.delegate?.pickerView?(picker, didSelectRow: 0, inComponent: 0)
                picker.selectRow(0, inComponent: 0, animated: true)
            case .departmentOptional:
                sectionUpdated = EditProfilePickerType.departmentOptional.rawValue
                changeColorBackgroundView()
            case .officePhone:
                sectionUpdated = EditProfilePickerType.officePhone.rawValue
                changeColorBackgroundView()
            case .cell :
                sectionUpdated = EditProfilePickerType.cell.rawValue
                changeColorBackgroundView()
            default:
                return
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == EditProfilePickerType.suburb.rawValue || textField.tag == EditProfilePickerType.state.rawValue || textField.tag == EditProfilePickerType.interestArea.rawValue || textField.tag == EditProfilePickerType.ingenio.rawValue || textField.tag == EditProfilePickerType.department.rawValue{
            return false
        } else {
            return true
        }
    }
}
