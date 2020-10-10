//
//  CVProfileViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import MobileCoreServices

class CVProfileViewController: ZPMasterViewController {
    
    private enum Constants {
        enum Segue {
            static let showPDF = "segueShowPDF"
        }
        enum String {
            static let resume = NSLocalizedString("Currículum", comment: "")
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var cvProfileImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var cvView: UIView!
    @IBOutlet private var cvTitleLabel: UILabel!
    @IBOutlet private var updateCvButton: ZPDesignableUIButton!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var resumeLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var updateCV = false
    private var cv = ""
    private var hasCV = false
    private var titlePDF = ""
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabel()
        configureResumeView()
        configureGestureRecognizer()
        adjustImageRound()
        shadowView()
        
        
        let getName =  InformationClasify.sharedInstance.data
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(getName?.messageResponse?.userId ?? "").jpg")
        cvProfileImageView.image = imagefromDocuments
    }
    
    // MARK: - IBActions
    
    @IBAction func updateResumeAction(_ sender: Any) {
        hasCV = !hasCV
        if !hasCV {
            cvTitleLabel.text = "Subir CV"
            updateCvButton.isEnabled = true
            deleteButton.setTitle("", for: .normal)
        }
    }
    
    @IBAction func uploadAction(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        //Call Delegate
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == Constants.Segue.showPDF, let viewController = segue.destination as? PDFViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.urlString = cv
        }
    }
}

// MARK :- Private Methods

private extension CVProfileViewController {
    
    func configureLabel() {
        resumeLabel.text = Constants.String.resume
    }
    
    func adjustImageRound() {
        cvProfileImageView.layer.cornerRadius = cvProfileImageView.frame.size.height / 2
        cvProfileImageView.layer.borderColor = #colorLiteral(red: 0.337254902, green: 0.3882352941, blue: 1, alpha: 1)
        cvProfileImageView.layer.borderWidth = 2
        cvProfileImageView.clipsToBounds = true
    }
    
    func configureResumeView() {
        let getEmail =  InformationClasify.sharedInstance.data
        emailLabel.text = getEmail?.messageResponse?.email
        nameLabel.text = getEmail?.messageResponse?.name
        if !(getEmail?.messageResponse?.cv?.isEmpty ?? false) && getEmail?.messageResponse?.cv != nil {
            cvTitleLabel.text = "Ya has subido un CV, toca para verlo"
            cv = getEmail?.messageResponse?.cv ?? ""
            hasCV = true
            updateCvButton.isEnabled = false
            updateCvButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
            updateCvButton.setTitle("Actualizar", for: .normal)
        } else {
            deleteButton.setTitle("", for: .normal)
            cvTitleLabel.text = "Subir CV"
            hasCV = false
            updateCvButton.setTitle("Subir", for: .normal)
        }
    }
    
    func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showResume(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        cvView.isUserInteractionEnabled = true
        cvView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func updateCV(mail: String, strPdf: String) {
        self.activityIndicatorBegin()
        let service = CVService()
        service.savePosition(mail: mail, strPDF: strPdf) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self.updateCvButton.isEnabled = false
                    self.updateCvButton.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                    self.updateCvButton.setTitle("Actualizar", for: .normal)
                    self.deleteButton.setTitle("x", for: .normal)
                    self.deleteButton.setImage(UIImage(named: ""), for: .normal)
                    self.cvTitleLabel.text = self.titlePDF
                    self.present(ZPAlertGeneric.oneOption(title: "Éxito", message:"Tu CV se ha actualizado correctamente", actionTitle: AppConstants.String.accept),animated: true)
                }
                self.hasCV = !self.hasCV
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func fileSize(forURL url: Any) -> Double {
        var fileURL: URL?
        var fileSize: Double = 0.0
        if (url is URL) || (url is String)
        {
            if (url is URL) {
                fileURL = url as? URL
            }
            else {
                fileURL = URL(fileURLWithPath: url as! String)
            }
            var fileSizeValue = 0.0
            try? fileSizeValue = (fileURL?.resourceValues(forKeys: [URLResourceKey.fileSizeKey]).allValues.first?.value as! Double?)!
            if fileSizeValue > 0.0 {
                fileSize = (Double(fileSizeValue) / (1024 * 1024))
            }
        }
        return fileSize
    }
    
    func shadowView() {
        cvView.layer.cornerRadius = 10
        cvView.layer.shadowColor = UIColor.lightGray.cgColor
        cvView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cvView.layer.shadowRadius = 5.0
        cvView.layer.shadowOpacity = 0.5
    }
    
    @objc func showResume(sender: UITapGestureRecognizer) {
        guard hasCV else { return }
        performSegue(withIdentifier: Constants.Segue.showPDF, sender: nil)
    }
}

// MARK: - UIDocumentPickerDelegate

extension CVProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let size = fileSize(forURL: urls.first!)
        if size < 0.5 {
            let fileData = try! Data(contentsOf: urls.first!)
            titlePDF =  urls.first!.lastPathComponent
            let base64 = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            let getEmail =  InformationClasify.sharedInstance.data
            updateCV(mail: getEmail?.messageResponse?.email ?? "" , strPdf: base64)
        } else {
            present(ZPAlertGeneric.oneOption(title: "Tamaño máximo permitido", message: "Tu pdf debe pesar menos de 500 Kb ", actionTitle: AppConstants.String.accept),animated: true)
        }
        
    }
}



