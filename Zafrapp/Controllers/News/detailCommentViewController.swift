//
//  detailCommentViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class detailCommentViewController: ZPMasterViewController{
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lycHeight: NSLayoutConstraint!
    @IBOutlet weak var viewComment: UIView!
    @IBOutlet weak var lycHeightDetail: NSLayoutConstraint!
    @IBOutlet weak var lblNAme: UILabel!
    
    var bIsImageIsSaved = false
    var comentSelected : comment?
    var comentarios : [comment] = []
    
    override func viewWillAppear(_ animated: Bool) {
        comentSelected?.bShowAnswer = true
        comentSelected?.bisMovSelected = true
        if comentSelected?.id_user != getUserSaved() {
            viewComment.isHidden = true
            lycHeightDetail.constant = 10
        }
        serviceGetReplyComments(id_newsData: Int(comentSelected?.id_news ?? "0") ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupVIew()
        checkComments()
        
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.lycHeight.constant = 0.0
            } else {
                self.lycHeight.constant = (endFrame?.size.height ?? 0.0)-90
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getUserSaved() -> String {
          let getUser =  informationClasify.sharedInstance.data
          return  getUser?.arrMessage?.strId_user ?? ""
            }
    
     func checkComments () {
         let user = getUserSaved()
         let checkData = comentarios.filter({$0.id_user == user})
         if checkData.count < 2 {
               txtView.text = "Escribe un comentario..."
         }else {
           txtView.text = "Haz alcanzado el límite de comentarios, sigue esta conversación por WhatsApp"
           btn.isEnabled = false
           viewComment.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
           txtView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
           txtView.isEditable = false
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
             viewComment.addGestureRecognizer(tap)
         }
       }
    func succesComment (){
        serviceGetReplyComments(id_newsData: Int(comentSelected?.id_news ?? "0") ?? 0)
        tbl.reloadData()
        checkComments()
    }
    func getImageSaved() -> String {
                 let getEmail =  informationClasify.sharedInstance.data
              return  getEmail?.arrMessage?.strImage ?? ""
           }
       
       func getNameSaved () -> String {
           let getName =  informationClasify.sharedInstance.data
           return  getName?.arrMessage?.strName ?? ""
       }
    
  func addReplyComments (INews : Int, IUser: Int, Text: String) {
       let ws = sendComentario_WS ()
    self.activityIndicatorBegin()
     ws.sendComentario(id_news : INews, user_Id : IUser, textcometaio : Text, bisReply : true) {[weak self] (respService, error) in
            guard self != nil else { return }
          self?.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "OK" {
                    self?.present(ZPAlertGeneric.OneOption(title : "Nuevo comentario", message: respService?.strMessage, actionTitle: "Aceptar", actionHandler:{ (_) in
                         self?.succesComment()
                    }),animated: true)
                }
            }else if (error! as NSError).code == -1009 {
                      self?.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
                }else {
                    self?.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
                }
        }
    }
  
    func serviceGetReplyComments (id_newsData : Int) {
        let ws = getAllComments_WS ()
         self.activityIndicatorBegin()
        ws.obtainComents(id_news: id_newsData, bIsReply : true) {[weak self] (respService, error) in
             guard self != nil else { return }
              self?.activityIndicatorEnd()
             if (error! as NSError).code == 0 && respService != nil {
                 if respService?.strStatus == "OK" {
                     self?.comentarios = respService?.allComment ?? []
                     self?.tbl.reloadData()
                     self?.checkComments()
                 }
             }else if (error! as NSError).code == -1009 {
                  self?.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
            }else {
                self?.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
         }
     }
    func showDetailCompany (IdClient: String) {
              let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
              let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! ProfileCompanyViewController
              vc.strIdCompany = IdClient
              vc.modalPresentationStyle = .fullScreen
              navigationController?.pushViewController(vc,
              animated: true)
          }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        showDetailCompany(IdClient: comentSelected?.id_client ?? "3")
    }
   
    
    func settupVIew () {
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(getUserSaved()).jpg")
            if  bIsImageIsSaved{
                self.img.image = imagefromDocuments
                lblNAme.isHidden = true
            }else {
                var urlImage : String? = getImageSaved()
                urlImage = getImageSaved().isEmpty ? nil : getImageSaved()
                if let image = urlImage {
                   img.downloaded(from: image, contentMode: .scaleToFill)
                   lblNAme.isHidden = true
                    }else {
                   lblNAme.isHidden = false
                 changeLabel().changeColorLabel(Name: getNameSaved(), label: lblNAme)
                }
        }
      txtView.delegate = self
      tbl.delegate = self
      tbl.dataSource = self
      tbl.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
    }

    
    @IBAction func btnAction(_ sender: Any) {
        if txtView.text == "Escribe un comentario..."{
        present(ZPAlertGeneric.OneOption(title : "Nuevo comentario", message: "Ingresa un comentario", actionTitle: "Aceptar"),animated: true)
        }else {
           addReplyComments(INews: Int(comentSelected?.id_news ?? "0") ?? 0, IUser: Int(getUserSaved()) ?? 0, Text: txtView.text)
        }
    }
    
}

extension detailCommentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comentarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
         customCell.selectionStyle = .none
        if indexPath.section == 0 {
            customCell.aComent = comentSelected
        }else {
            customCell.selectionStyle = .none
            if comentarios.count > 0 {
            let coment = comentarios[indexPath.row]
            customCell.aComent = coment
            }
        }
        return customCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
}

extension detailCommentViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
          txtView.text = ""
         }
}
