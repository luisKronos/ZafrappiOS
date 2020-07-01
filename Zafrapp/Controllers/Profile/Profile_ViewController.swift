//
//  Profile_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class Profile_ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var allInformation : String?
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblOptions: UITableView! {
        didSet{
            tblOptions.delegate = self
            tblOptions.dataSource = self
        }
    }
    
    var panGesture       = UITapGestureRecognizer()
    var optionsInformation : [optionsProfile]?
    var informationUser : responseLogIn?
    var imageProfileSend : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustImageRound()
        dataInView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblOptions.register(UINib(nibName: "SelectOptions_ViewController", bundle: nil), forCellReuseIdentifier: "SelectOptions_ViewController")
        self.tblOptions.addCorner()
        self.tblOptions.addShadow()
        data()
        informationUser = informationClasify.sharedInstance.data
        
        panGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto))
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(panGesture)
    }
    
    func adjustImageRound () {
        self.imgProfile.layer.cornerRadius = imgProfile.frame.size.height / 2
        self.imgProfile.layer.borderColor = #colorLiteral(red: 0.337254902, green: 0.3882352941, blue: 1, alpha: 1)
        self.imgProfile.layer.borderWidth = 2
        self.imgProfile.clipsToBounds = true
    }
    @objc func selectPhoto(_ sender:UIPanGestureRecognizer){
        self.performSegue(withIdentifier: "ShowCamera", sender: nil)
        }
    
    func dataInView () {
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(informationUser?.arrMessage?.strName ?? "").jpg")
       
        if  checkIfImageIsSaved(){
         self.imgProfile.image = imagefromDocuments
         imageProfileSend = imagefromDocuments
        }else {
            if informationUser?.arrMessage?.strImage != nil{
                let url = URL(string: informationUser?.arrMessage?.strImage ?? "")!
                downloadImage(from: url)
            } 
        }
        lblName.text = informationUser?.arrMessage?.strName
        lblEmail.text = informationUser?.arrMessage?.strEmail
      }
    
    func checkIfImageIsSaved()-> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("ProfilePicture\(informationUser?.arrMessage?.strName ?? "").jpg") {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
     }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                self.imgProfile.image = UIImage(data: data)
                self.imageProfileSend = UIImage(data: data)
                self.saveImage()
            }
        }
    }
    
    
    func saveImage () {
         let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
         let fileName = "ProfilePicture\(informationClasify.sharedInstance.data?.arrMessage?.strName ?? "").jpg"
         let fileURL = documentsDirectory.appendingPathComponent(fileName)
         
         if let data = imgProfile.image?.jpegData(compressionQuality:  1.0),
           !FileManager.default.fileExists(atPath: fileURL.path) {
             do {
                 try data.write(to: fileURL)
                 print("file saved")
             } catch {
                 print("error saving file:", error)
             }
         }
     }
    func data () {
        let firstTitle = optionsProfile ()
        firstTitle.strTitle = "Mis datos"
        firstTitle.strImage = "1persona"
       let secondTitle = optionsProfile ()
        secondTitle.strTitle = "Mis vacantes"
        secondTitle.strImage = "star"
       let thirthTitle = optionsProfile ()
        thirthTitle.strTitle = "Mi cv"
        thirthTitle.strImage = "cv"
        //CambiarImagen
//       let fourthTitle = optionsProfile ()
//        fourthTitle.strTitle = "Valorar la app"
//        fourthTitle.strImage = "like"
      let fifthTitle = optionsProfile ()
        fifthTitle.strTitle = "Cerrar sesión"
        fifthTitle.strImage = "LogOut"
        optionsInformation = [firstTitle,secondTitle,thirthTitle,fifthTitle]
    }
    
    func ShowSuccesCreateAccount () {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "editProfileVC") as? EditProfile_ViewController
        vc?.modalPresentationStyle = .fullScreen
        self.present(vc ?? EditProfile_ViewController(), animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          super.prepare(for: segue, sender: sender)
      if (segue.identifier == "segueEditarDatos") {
            let vcLogin = segue.destination as? EditProfile_ViewController
              vcLogin?.modalPresentationStyle = .fullScreen
              vcLogin?.imageProfile = imageProfileSend
      }else  if (segue.identifier == "segueVacancies") {
          let vcLogin = segue.destination as? VacanciesSavedViewController
          vcLogin?.modalPresentationStyle = .fullScreen
        }
      }
}

extension Profile_ViewController: UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsInformation?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tblOptions.dequeueReusableCell(withIdentifier: "SelectOptions_ViewController", for: indexPath) as? SelectOptions_ViewController
        let singleTitle = optionsInformation?[indexPath.row]
        cell?.lblText.text = singleTitle?.strTitle
        cell?.lblImage.image = UIImage(named: singleTitle?.strImage ?? "")
        cell?.selectionStyle = .none
        return cell ?? SelectOptions_ViewController()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "segueEditarDatos", sender: nil)
        case 1:
            self.performSegue(withIdentifier: "segueVacancies", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "segueCVProfile", sender: nil)
        case 3:
            return
            // Valorar app
        default:
            // cerrar sesion
            return
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
