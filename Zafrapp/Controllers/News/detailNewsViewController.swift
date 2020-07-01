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
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var btnTime: UIButton!
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

       adjustText()
       adjustImageView()
       adjustWebView()
    }
    
    
    func showDetailCompany(){
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! ProfileCompanyViewController
        vc.strIdCompany = strIdCompany ?? ""
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
        animated: true)
    }
    
    func compareDate(strDate: String) -> String {
          let dateSended = strDate.toDate() ?? Date()
          let currentDate = Date()
          let format = DateFormatter()
          format.dateFormat = "yyyy-MM-dd"
          
          let dias = daysBetweenDates(startDate: dateSended, endDate: currentDate)
          
          switch  dias{
          case 0:
              return "Hoy"
          default:
              return  strDate
          }
           
      }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int
       {
         let calendar = Calendar.current
           let date1 = calendar.startOfDay(for: startDate)
           let date2 = calendar.startOfDay(for: endDate)

           let components = calendar.dateComponents([.day], from: date1, to: date2)
           return components.day ?? 0
       }
    
    
      func loadYoutube(videoID:String) {
          guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
              return
          }
          webView.load(URLRequest(url: youtubeURL))
      }
    
    @objc func play(_ sender: UITapGestureRecognizer? = nil) {
        webView.isHidden = false
        loadYoutube(videoID: "xwwAVRyNmgQ")
    }
    
    func adjustText(){
        lblTitle.text = detailNews?.strTitle
        lblDescription.text = detailNews?.strDescription
        let time = compareDate(strDate: detailNews?.strPublish_date ?? "")
        btnTime.setTitle("  \(time)", for: .normal)
        
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
