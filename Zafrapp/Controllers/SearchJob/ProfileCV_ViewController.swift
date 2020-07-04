//
//  ProfileCV_ViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 21/06/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import MobileCoreServices

class ProfileCV_ViewController: ZPMasterViewController {
    
    @IBOutlet weak var imgProfileCV: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var vwCv: UIView!
    @IBOutlet weak var titleCV: UILabel!
    @IBOutlet weak var btnUpdateCV: ZPDesignableUIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var updateCV = false
    var strCV = ""
    var alreadyHasCV = false
    var titlePDF = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      getEmailSaved()
      adjustImageRound()
      shadowView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        vwCv.isUserInteractionEnabled = true
        vwCv.addGestureRecognizer(tap)
     
     let getName =  informationClasify.sharedInstance.data
     let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(getName?.arrMessage?.strId_user ?? "").jpg")
       self.imgProfileCV.image = imagefromDocuments
    }
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if alreadyHasCV {
          performSegue(withIdentifier: "segueShowPDF", sender: nil)
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
             super.prepare(for: segue, sender: sender)
         if (segue.identifier == "segueShowPDF") {
               let vcShowCV = segue.destination as? ShowPDFViewController
                 vcShowCV?.modalPresentationStyle = .fullScreen
                 vcShowCV?.urlStr = strCV
             }
         }
    func adjustImageRound () {
        self.imgProfileCV.layer.cornerRadius = imgProfileCV.frame.size.height / 2
        self.imgProfileCV.layer.borderColor = #colorLiteral(red: 0.337254902, green: 0.3882352941, blue: 1, alpha: 1)
        self.imgProfileCV.layer.borderWidth = 2
        self.imgProfileCV.clipsToBounds = true
    }
    
    func getEmailSaved() {
        let getEmail =  informationClasify.sharedInstance.data
        lblEmail.text = getEmail?.arrMessage?.strEmail
        lblName.text = getEmail?.arrMessage?.strName
        if !(getEmail?.arrMessage?.strCv?.isEmpty ?? false) && getEmail?.arrMessage?.strCv != nil {
            titleCV.text = "Ya has subido un CV, toca para verlo"
            strCV = getEmail?.arrMessage?.strCv ?? ""
            alreadyHasCV = true
            btnUpdateCV.isEnabled = false
            btnUpdateCV.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
            btnUpdateCV.setTitle("Actualizar", for: .normal)
        }else {
            btnDelete.setTitle("", for: .normal)
            btnDelete.setImage(UIImage(named: "longArrowUp"), for: .normal)
            titleCV.text = "Subir CV"
            alreadyHasCV = false
            btnUpdateCV.setTitle("Subir", for: .normal)
        }
          }
    
    func updateCV (mail : String, strPdf : String) {
        self.activityIndicatorBegin()
       let ws = uploadCv_WS ()
        ws.savePosition(mail: mail, strPDF : strPdf) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                    self.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    self.btnUpdateCV.isEnabled = false
                    self.btnUpdateCV.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1).withAlphaComponent(0.6)
                    self.btnUpdateCV.setTitle("Actualizar", for: .normal)
                    self.btnDelete.setTitle("x", for: .normal)
                    self.btnDelete.setImage(UIImage(named: ""), for: .normal)
                    self.titleCV.text = self.titlePDF
                    self.present(ZPAlertGeneric.OneOption(title : "Éxito", message:"Tu CV se ha actualizado correctamente", actionTitle: "Aceptar"),animated: true)
                }
            }else if (error! as NSError).code == -1009 {
              self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
              self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
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

    func shadowView () {
           vwCv.layer.cornerRadius = 10
           vwCv.layer.shadowColor = UIColor.lightGray.cgColor
           vwCv.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
           vwCv.layer.shadowRadius = 5.0
           vwCv.layer.shadowOpacity = 0.5
       }
    
    
    @IBAction func btnUpdateCV(_ sender: Any) {
        alreadyHasCV = !alreadyHasCV
        if !alreadyHasCV {
           titleCV.text = "Subir CV"
           btnUpdateCV.isEnabled = true
           btnDelete.setTitle("", for: .normal)
           btnUpdateCV.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1)
           btnDelete.setImage(UIImage(named: "longArrowUp"), for: .normal)
        }
    }
    
    @IBAction func btnUpload(_ sender: Any) {
//        if !alreadyHasCV {
            let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
                           //Call Delegate
            documentPicker.delegate = self
            self.present(documentPicker, animated: true)
//        }
    }
}

extension ProfileCV_ViewController : UIDocumentPickerDelegate{
      func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let size = fileSize(forURL: urls.first!)
        if size < 0.5 {
            let fileData = try! Data.init(contentsOf: urls.first!)
            titlePDF =  urls.first!.lastPathComponent
            let base64 = fileData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            let getEmail =  informationClasify.sharedInstance.data
            updateCV(mail: getEmail?.arrMessage?.strEmail ?? "" , strPdf: base64)
        }else {
               self.present(ZPAlertGeneric.OneOption(title : "Tamaño máximo permitido", message: "Tu pdf debe pesar menos de 500 Kb ", actionTitle: "Aceptar"),animated: true)
            }
                
        }
}



