//
//  News_ViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class News_ViewController: ZPMasterViewController {

    @IBOutlet weak var tblNews: UITableView!
    @IBOutlet weak var viewEmptyTable: UIView!
    
    var listPremium : [listaNews] = []
    var listaNormal : [listaNews] = []
    var informationSaved : responseLogIn?
    var showNews : listaNews?
    var imageShow : UIImage?
    
     override func viewDidLoad() {
        super.viewDidLoad()
        informationSaved = informationClasify.sharedInstance.data
        configTable()
        executeService(interest: informationSaved?.arrMessage?.strAreaInteres ?? "")
        swipeDown()
    }
    
    func swipeDown () {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
           swipeDown.direction = .down
           self.viewEmptyTable.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
        switch swipeGesture.direction {
        case .down:
          executeService(interest: informationSaved?.arrMessage?.strAreaInteres ?? "")
        default:
            break
        }
     }
    }
    
    func configTable (){
        tblNews.delegate = self
        tblNews.dataSource = self
        tblNews.register(UINib(nibName:"MainNewsTableViewCell", bundle : nil), forCellReuseIdentifier: "MainNewsTableViewCell")
        self.tblNews.separatorStyle = UITableViewCell.SeparatorStyle.none
        tblNews.register(UINib(nibName:"SecondaryNewsTableViewCell", bundle : nil), forCellReuseIdentifier: "SecondaryNewsTableViewCell")
    }
    
    
    func executeService (interest : String) {
        self.tblNews.isHidden = true
        self.activityIndicatorBegin()
       let ws = getNews_WS ()
        ws.getNews(interest: interest) {[weak self] (respService, error) in
             guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.strStatus == "BAD" {
                        self.present(ZPAlertGeneric.OneOption(title : "Aún no tienes noticias.", message: respService?.strMessage, actionTitle: "Aceptar"),animated: true)
                }else {
                    if respService?.arrList?.count ?? 0 > 0 {
                        self.tblNews.isHidden = false
                    }
                    self.updateBothNews(list: respService?.arrList ?? [])
                }
            }else if (error! as NSError).code == -1009 {
                self.present(ZPAlertGeneric.OneOption(title : "Conexion de internet", message: "No tienes conexion a internet", actionTitle: "Intenta de nuevo"),animated: true)
            }else {
                self.present(ZPAlertGeneric.OneOption(title : "Error", message: "Intenta de nuevo", actionTitle: "Aceptar"),animated: true)
            }
        }
    }
    
    func updateBothNews(list : [listaNews]){
        listPremium = list.filter{$0.strType == "premium"}
        listaNormal = list.filter{$0.strType == "normal"}
        self.tblNews.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            if let viewController = segue.destination as? detailNewsViewController {
                viewController.detailNews = showNews
            }
        }
    }
    
}


extension News_ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let customCell = tblNews.dequeueReusableCell(withIdentifier: "MainNewsTableViewCell", for: indexPath) as? MainNewsTableViewCell
            customCell?.listOfNews = listPremium
            customCell?.delegateNextPage = self
            return customCell ?? UITableViewCell()
        }else {
            let customCell = tblNews.dequeueReusableCell(withIdentifier: "SecondaryNewsTableViewCell", for: indexPath) as? SecondaryNewsTableViewCell
            customCell?.mainNewDelegate = self
            customCell?.listOfSecondaryNews = listaNormal
            return customCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
         return 300
        }else {
            if listaNormal.count.isPrime {
                let sum = CGFloat((95 * listaNormal.count)) +
                95
                return sum
            }else {
              return CGFloat((95 * listaNormal.count))
            }
        }
    }
}

extension News_ViewController: showNewSelectedDelegate {
    func show(New: listaNews) {
        showNews = New
        performSegue(withIdentifier: "segueDetail", sender: nil)
    }
    
}
