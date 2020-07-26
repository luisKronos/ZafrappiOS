//
//  detailCommentViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class detailCommentViewController: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var viewComment: UIView!
    
     var comentSelected : comment?
     var comentarios : [comment] = []
    
    override func viewWillAppear(_ animated: Bool) {
        serviceGetReplyComments(id_newsData: Int(comentSelected?.id_news ?? "0") ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settupVIew()
        checkComments()
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
         }else if checkData.count == 2{
           txtView.text = "Haz alcanzado el límite de comentarios, sigue esta conversación por WhatsApp"
           btn.isEnabled = false
           viewComment.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
           txtView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
           txtView.isEditable = false
           let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
             viewComment.addGestureRecognizer(tap)
           }
       }
    
  
    func serviceGetReplyComments (id_newsData : Int) {
        let ws = getAllComments_WS ()
        ws.obtainComents(id_news: id_newsData, bIsReply : true) {[weak self] (respService, error) in
             guard self != nil else { return }
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
           let user = getUserSaved()
              let indexs = comentarios.firstIndex(where: { (item) -> Bool in
                item.id_user == user // test if this is the item you're looking for
              })
              scrollToFirstRow(row: indexs ?? 0)
          }
    
    func scrollToFirstRow(row : Int) {
                let indexPath = IndexPath(row: row, section: 0)
                self.tbl.scrollToRow(at: indexPath, at: .middle, animated: true)
              }
    
    func settupVIew () {
      txtView.delegate = self
      tbl.delegate = self
      tbl.dataSource = self
      tbl.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    @IBAction func btnAction(_ sender: Any) {
        
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
        if indexPath.section == 0 {
            customCell.aComent = comentSelected
        }else {
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