//
//  detailNewsViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVKit
import WebKit

protocol selectButtonCellDelegate {
    func showContact ()
    func shareData()
    func getLinkAction()
}

class detailNewsViewController: ZPMasterViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var tableComments: UITableView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var textComent: UITextView!
    @IBOutlet weak var viewComent: UIView!
    @IBOutlet weak var btnSend: UIButton!
    
    
    var detailNews : listaNews?
    var strIdCompany : String?
    var comentarios : [comment] = []
    var Selection = comment ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strIdCompany = detailNews?.strClient_id
        webView.isHidden = true
        textComent.delegate = self
        if detailNews?.strVideo == nil{
            imgPlay.isHidden = true
        }else {
            imgPlay.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(play))
            imgPlay.isUserInteractionEnabled = true
            imgPlay.addGestureRecognizer(tap)
        }
       configTable()
       adjustImageView()
       adjustWebView()
        checkComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        servicePostulation(id_newsData: Int(detailNews?.intNews ?? "0") ?? 0)
    }
    
    @IBAction func sendComent(_ sender: Any) {
        serviceAddComment(INews: Int(detailNews?.intNews ?? "0") ?? 0, IUser: Int(getUserSaved()) ?? 0, Text: textComent.text)
    }
    
    func servicePostulation (id_newsData : Int) {
          let ws = getAllComments_WS ()
           ws.obtainComents(id_news: id_newsData) {[weak self] (respService, error) in
               guard self != nil else { return }
               if (error! as NSError).code == 0 && respService != nil {
                   if respService?.strStatus == "OK" {
                       self?.comentarios = respService?.allComment ?? []
                       self?.tableComments.reloadData()
                    self?.checkComments()
                }
               }else if (error! as NSError).code == -1009 {
                self?.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
               }else {
                self?.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
               }
           }
    }
    
    func getImageSaved() -> String {
              let getEmail =  informationClasify.sharedInstance.data
           return  getEmail?.arrMessage?.strImage ?? ""
        }
    
    func getUserSaved() -> String {
       let getUser =  informationClasify.sharedInstance.data
       return  getUser?.arrMessage?.strId_user ?? ""
         }
    
    func getNameSaved () -> String {
        let getName =  informationClasify.sharedInstance.data
        return  getName?.arrMessage?.strName ?? ""
    }
    
    func checkComments () {
      let user = getUserSaved()
      let checkData = comentarios.filter({$0.id_user == user})
      if checkData.count == 0 {
            textComent.text = "Escribe un comentario..."
      }else {
        textComent.text = "Ya has comentado, pulsa para ir directo a tu comentario"
        btnSend.isEnabled = false
        viewComent.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textComent.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textComent.isEditable = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
          viewComent.addGestureRecognizer(tap)
        }
    }
    
    func scrollToFirstRow(row : Int) {
             let indexPath = IndexPath(row: row, section: 0)
             self.tableComments.scrollToRow(at: indexPath, at: .middle, animated: true)
           }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let user = getUserSaved()
           let indexs = comentarios.firstIndex(where: { (item) -> Bool in
             item.id_user == user // test if this is the item you're looking for
           })
           scrollToFirstRow(row: indexs ?? 0)
       }
        
    func configTable () {
        tableComments.delegate = self
        tableComments.dataSource = self
         tableComments.register(UINib(nibName: "NewsBuTTonTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsBuTTonTableViewCell")
        tableComments.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    func showDetailCompany(){
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! ProfileCompanyViewController
        vc.strIdCompany = strIdCompany ?? ""
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
        animated: true)
    }
    
    func succesComment (){
        viewComent.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textComent.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        let newComment = comment()
        newComment.HasComments = "0"
        newComment.text_comment = textComent.text
        newComment.image = getImageSaved()
        newComment.name = getNameSaved()
        newComment.id_user = getUserSaved()
        comentarios.append(newComment)
        tableComments.reloadData()
        checkComments()
    }
    
    func serviceAddComment (INews : Int, IUser: Int, Text: String) {
            let ws = sendComentario_WS ()
             ws.sendComentario(id_news : INews, user_Id : IUser, textcometaio : Text) {[weak self] (respService, error) in
                 guard self != nil else { return }
                 if (error! as NSError).code == 0 && respService != nil {
                     if respService?.strStatus == "BAD" {
                        self?.present(ZPAlertGeneric.OneOption(title : "Error", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                     }else {
                        self?.succesComment()
                     }
                 }else if (error! as NSError).code == -1009 {
                  self?.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Aceptar"),animated: true)
                 }else {
                  self?.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
                 }
             }
         }
      func loadYoutube(videoID:String) {
          guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
              return
          }
          webView.load(URLRequest(url: youtubeURL))
      }
    
    @objc func play(_ sender: UITapGestureRecognizer? = nil) {
        webView.isHidden = false
        loadYoutube(videoID: detailNews?.strVideo ?? "")
    }
    

    func adjustWebView(){
        webView.layer.cornerRadius = 21
        webView.layer.masksToBounds = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
   
    
    func adjustImageView () {
    image.downloaded(from: detailNews?.strImage ?? "")
    image.contentMode = .scaleAspectFill
    image.layer.cornerRadius = 21
    image.layer.masksToBounds = true
    image.clipsToBounds = true
    imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
    imgUser.downloaded(from: getImageSaved(), contentMode: .scaleToFill)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                 if (segue.identifier == "DetailNewMessage"){
                     let vcTableMovements = segue.destination as? detailCommentViewController
                         vcTableMovements?.comentSelected = Selection
                     }
                 }
         
}

extension detailNewsViewController : WKNavigationDelegate, WKUIDelegate {
    func showActivityIndicator(show: Bool) {
          if show {
              self.activityIndicatorBegin()
          } else {
              self.activityIndicatorEnd()
          }
      }

      func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         self.activityIndicatorEnd()
      }

      func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          self.activityIndicatorBegin()
      }

      func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
         self.activityIndicatorEnd()
      }
}

extension detailNewsViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return comentarios.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "NewsBuTTonTableViewCell", for: indexPath) as? NewsBuTTonTableViewCell ?? NewsBuTTonTableViewCell()
            customCell.detailNews = detailNews
            customCell.delegate = self
        return customCell
        }else {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
            if comentarios.count > 0 {
                let coment = comentarios[indexPath.row]
                customCell.aComent = coment
            }
        return customCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if comentarios.count > 0 {
            let value = comentarios[indexPath.row]
            Selection = value
            if Int(value.HasComments ?? "0") ?? 0 > 0 {
                performSegue(withIdentifier: "DetailNewMessage", sender: nil)
            }
        }
    }
}

extension detailNewsViewController : selectButtonCellDelegate {
    func showContact() {
        showDetailCompany()
    }
    func shareData() {
         let text = detailNews?.strUrl ?? ""
                  let textShare = [ text ]
                  let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
                  activityViewController.popoverPresentationController?.sourceView = self.view
                  self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getLinkAction() {
     guard let url = URL(string: detailNews?.strUrl ?? "https://google.com") else { return }
     UIApplication.shared.open(url)
    }
    
    
}

extension detailNewsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
       }
}
