//
//  ProfileViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/6/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private enum Constants {
        enum TableView {
            static let selectOptionCellIdentifier = "SelectOptionCellIdentifier"
        }
        enum Segue {
            static let editData = "segueEditarDatos"
            static let vacancies = "segueVacancies"
            static let cv = "segueCVProfile"
            static let camera = "ShowCamera"
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var tableView: UITableView! {
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    // MARK: - Private Properties
    
    private var panGesture = UITapGestureRecognizer()
    private var optionsInformation: [OptionsProfile]?
    private var informationUser: Response?
    private var imageProfileSend: UIImage?
    private var allInformation: String?
    
    private var isImageSaved: Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("ProfilePicture\(informationUser?.messageResponse?.userId ?? "").jpg") {
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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureGestureRecognizer()
        updateData()
        informationUser = InformationClasify.sharedInstance.data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adjustImageRound()
        updateView()
    }
    
    // MARK: - Segue Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == Constants.Segue.editData, let viewController = segue.destination as? EditProfileViewController {
            viewController.modalPresentationStyle = .fullScreen
            viewController.imageProfile = imageProfileSend
        } else if segue.identifier == Constants.Segue.vacancies {
            let viewController = segue.destination
            viewController.modalPresentationStyle = .fullScreen
        }
    }
}

// MARK: - Private Methods

private extension ProfileViewController {
    
    func configureTableView() {
        tableView.register(UINib(nibName: "SelectOptionsViewCell", bundle: nil), forCellReuseIdentifier: Constants.TableView.selectOptionCellIdentifier)
        tableView.addCorner()
        tableView.addShadow()
    }
    
    func configureGestureRecognizer() {
        panGesture = UITapGestureRecognizer(target: self, action: #selector(selectPhoto(_:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(panGesture)
    }
    
    func adjustImageRound() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.borderColor = #colorLiteral(red: 0.1490196078, green: 0.6, blue: 0.9843137255, alpha: 1)
        profileImageView.layer.borderWidth = 2
        profileImageView.clipsToBounds = true
    }
    
    @objc func selectPhoto(_ sender:UIPanGestureRecognizer){
        performSegue(withIdentifier: Constants.Segue.camera, sender: nil)
    }
    
    func updateView() {
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(informationUser?.messageResponse?.userId ?? "").jpg")
        
        if isImageSaved {
            self.profileImageView.image = imagefromDocuments
            imageProfileSend = imagefromDocuments
        } else if informationUser?.messageResponse?.image != nil, let url = URL(string: informationUser?.messageResponse?.image ?? "") {
            downloadImage(from: url)
        }
        nameLabel.text = informationUser?.messageResponse?.name
        emailLabel.text = informationUser?.messageResponse?.email
    }
    
    func downloadImage(from url: URL) {
        func getData(from url: URL, completion: @escaping(Data?, URLResponse?, Error?) ->()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        getData(from: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            DispatchQueue.main.async() {
                self.profileImageView.image = UIImage(data: data)
                self.imageProfileSend = UIImage(data: data)
                self.saveImage()
            }
        }
    }
    
    func saveImage() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "ProfilePicture\(InformationClasify.sharedInstance.data?.messageResponse?.userId ?? "").jpg"
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        if let data = profileImageView.image?.jpegData(compressionQuality:  1.0),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func updateData() {
        var firstTitle = OptionsProfile()
        firstTitle.title = "Mis datos"
        firstTitle.image = "1persona"
        
        var secondTitle = OptionsProfile()
        secondTitle.title = "Mis vacantes"
        secondTitle.image = "star"
        
        var thirthTitle = OptionsProfile()
        thirthTitle.title = "Mi cv"
        thirthTitle.image = "cv"
        
        var fifthTitle = OptionsProfile()
        fifthTitle.title = "Cerrar sesión"
        fifthTitle.image = "LogOut"
        optionsInformation = [firstTitle,secondTitle,thirthTitle,fifthTitle]
    }
    
    func showSuccesCreateAccount() {
        let vc = storyboard?.instantiateViewController(withIdentifier: AppConstants.ViewController.editProfile) as? EditProfileViewController
        vc?.modalPresentationStyle = .fullScreen
        present(vc ?? EditProfileViewController(), animated: true, completion: nil)
    }
}

// MARK: - TableView Delegates

extension ProfileViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsInformation?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.selectOptionCellIdentifier, for: indexPath) as? SelectOptionsViewCell
        let singleTitle = optionsInformation?[indexPath.row]
        cell?.titleLabel.text = singleTitle?.title
        cell?.iconImageView.image = UIImage(named: singleTitle?.image ?? "")
        cell?.selectionStyle = .none
        return cell ?? SelectOptionsViewCell()
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: Constants.Segue.editData, sender: nil)
        case 1:
            performSegue(withIdentifier: Constants.Segue.vacancies, sender: nil)
        case 2:
            performSegue(withIdentifier:  Constants.Segue.cv, sender: nil)
        case 3:
            presentLogIn()
            break
        default:
            break
        }
    }
    
    func presentLogIn() {
        
        UserDefaults.standard.removeObject(forKey: AppConstants.UserDefaults.defaultRecoverUser.rawValue)
        UserDefaults.standard.removeObject(forKey:AppConstants.UserDefaults.defaultRecoverDrowssap.rawValue)
        UserDefaults.standard.removeObject(forKey:AppConstants.UserDefaults.isSaved.rawValue)
        
        let storyboard = UIStoryboard(name: AppConstants.Storyboard.login, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: AppConstants.ViewController.loginNavigation)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
