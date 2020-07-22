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

class detailNewsViewController: ZPMasterViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var tableComments: UITableView!
    var detailNews : listaNews?
    var strIdCompany : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        strIdCompany = detailNews?.strClient_id
        webView.isHidden = true

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
    }
    
    @IBAction func shareBton(_ sender: Any) {
          let text = detailNews?.strUrl ?? ""
           let textShare = [ text ]
           let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func showNewInSafari(_ sender: Any) {
        guard let url = URL(string: detailNews?.strUrl ?? "https://stackoverflow.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func showContact(_ sender: Any) {
        showDetailCompany()
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
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let NewsDetail = tableView.dequeueReusableCell(withIdentifier: "NewsBuTTonTableViewCell", for: indexPath) as? NewsBuTTonTableViewCell ?? NewsBuTTonTableViewCell()
            NewsDetail.detailNews = detailNews
        return NewsDetail
        }else {
        let NewsDetail = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
                      
        return NewsDetail
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
 
}
