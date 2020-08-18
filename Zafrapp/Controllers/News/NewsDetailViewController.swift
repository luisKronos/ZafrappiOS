//
//  NewsDetailViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 20/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit
import AVKit
import WebKit

protocol SelectButtonCellDelegate {
    func showContact()
    func shareData()
    func getLinkAction()
}

class NewsDetailViewController: ZPMasterViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var playImageView: UIImageView!
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var commentTextView: UITextView!
    @IBOutlet private var commentView: UIView!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var lycCommentConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var companyId: String?
    private var comments: [Comment] = []
    private var commentSelected = Comment()
    private var isImageSaved: Bool = false
    
    // MARK: - Public Properties
    
    var newsDetail: NewsList?
    
    // MARK: - Computed Properties
    
    private var imageSaved: String {
        let data = InformationClasify.sharedInstance.data
        return data?.messageResponse?.image ?? ""
    }
    
    private var userId: String {
        let data = InformationClasify.sharedInstance.data
        return data?.messageResponse?.userId ?? ""
    }
    
    private var nameSaved: String {
        let data =  InformationClasify.sharedInstance.data
        return data?.messageResponse?.name ?? ""
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allComments(newsId: Int(newsDetail?.intNews ?? "0") ?? 0)
        
        companyId = newsDetail?.clientId
        webView.isHidden = true
        commentTextView.delegate = self
        if newsDetail?.video == nil{
            playImageView.isHidden = true
            let tapImage = UITapGestureRecognizer(target: self, action: #selector(showImage))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapImage)
        } else {
            playImageView.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(play))
            playImageView.isUserInteractionEnabled = true
            playImageView.addGestureRecognizer(tap)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        configureTableView()
        adjustImageView()
        adjustWebView()
        checkComments()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    
    @IBAction func sendComentAction(_ sender: Any) {
        if commentTextView.text == "Escribe un comentario..."{
            present(ZPAlertGeneric.oneOption(title: "Nuevo comentario", message: "Ingresa un comentario", actionTitle: AppConstants.String.accept),animated: true)
        } else {
            serviceAddComment(INews: Int(newsDetail?.intNews ?? "0") ?? 0, IUser: Int(userId) ?? 0, Text: commentTextView.text)
        }
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailNewMessage"){
            let vcTableMovements = segue.destination as? CommentDetailViewController
            vcTableMovements?.comentSelected = commentSelected
            vcTableMovements?.isImageSaved = true
        } else if (segue.identifier == "showImage"){
            let vcTableMovements = segue.destination as? ImageScrollViewController
            vcTableMovements?.urlImage = newsDetail?.image ?? ""
        }
    }
}

// MARK :- Private Methods

private extension NewsDetailViewController {
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.lycCommentConstraint.constant = 0.0
            } else {
                self.lycCommentConstraint.constant = (endFrame?.size.height ?? 0.0)-90
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func allComments(newsId: Int) {
        let service = CommentService()
        activityIndicatorBegin()
        service.obtainComents(id_news: newsId) {[weak self] (respService, error) in
            guard self != nil else { return }
            self?.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == "OK" {
                    self?.comments = respService?.comments ?? []
                    self?.tableView.reloadData()
                    self?.checkComments()
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self?.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self?.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }

    func checkComments() {
        let user = userId
        let checkData = comments.filter({$0.userId == user})
        if checkData.count == 0 {
            commentTextView.text = "Escribe un comentario..."
        } else {
            commentTextView.text = "Ya has comentado, pulsa para ir directo a tu comentario"
            sendButton.isEnabled = false
            commentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            commentTextView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            commentTextView.isEditable = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            commentView.addGestureRecognizer(tap)
        }
    }
    
    func scrollToFirstRow(row: Int) {
        let indexPath = IndexPath(row: row, section: 1)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let user = userId
        let indexs = comments.firstIndex(where: { (item) -> Bool in
            item.userId == user
        })
        scrollToFirstRow(row: indexs ?? 0)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewsButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsButtonTableViewCell")
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
    }
    
    func showDetailCompany() {
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! CompanyProfileViewController
        vc.companyId = companyId ?? ""
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func succesComment() {
        commentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        commentTextView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        allComments(newsId: Int(newsDetail?.intNews ?? "0") ?? 0)
        tableView.reloadData()
        checkComments()
    }
    
    func serviceAddComment(INews: Int, IUser: Int, Text: String) {
        let service = SendCommentService()
        self.activityIndicatorBegin()
        service.sendComentario(id_news: INews, user_Id: IUser, textcometaio: Text) {[weak self] (respService, error) in
            guard self != nil else { return }
            self?.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self?.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    self?.present(ZPAlertGeneric.oneOption(title: "Nuevo comentario", message: respService?.message, actionTitle: AppConstants.String.accept, actionHandler:{ (_) in
                        self?.succesComment()
                    }),animated: true)
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self?.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.accept),animated: true)
            } else {
                self?.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
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
        loadYoutube(videoID: newsDetail?.video ?? "")
    }
    @objc func showImage(_ sender: UITapGestureRecognizer? = nil) {
        performSegue(withIdentifier: "showImage", sender: nil)
    }
    
    func adjustWebView() {
        webView.layer.cornerRadius = 21
        webView.layer.masksToBounds = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    
    func adjustImageView() {
        imageView.downloaded(from: newsDetail?.image ?? "")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 21
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(userId).jpg")
        if  checkIfImageIsSaved() {
            self.userImageView.image = imagefromDocuments
            isImageSaved = true
            nameLabel.isHidden = true
        } else {
            var urlImage: String? = imageSaved
            urlImage = imageSaved.isEmpty ? nil: imageSaved
            if let image = urlImage {
                userImageView.downloaded(from: image, contentMode: .scaleToFill)
                nameLabel.isHidden = true
            } else {
                nameLabel.isHidden = false
                changeLabel().changeColorLabel(string: nameSaved, label: nameLabel)
            }
            
        }
    }
    
    func checkIfImageIsSaved()-> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("ProfilePicture\(userId).jpg") {
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
}

// MARK: - WKWebView Delegates

extension NewsDetailViewController: WKNavigationDelegate, WKUIDelegate {
    
    func showActivityIndicator(show: Bool) {
        if show {
            self.activityIndicatorBegin()
        } else {
            self.activityIndicatorEnd()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorEnd()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorBegin()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicatorEnd()
    }
}

// MARK: - TableView Delgates

extension NewsDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "NewsButtonTableViewCell", for: indexPath) as? NewsButtonTableViewCell ?? NewsButtonTableViewCell()
            customCell.detailNews = newsDetail
            customCell.delegate = self
            customCell.selectionStyle = .none
            return customCell
        } else {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
            customCell.selectionStyle = .none
            if !comments.isEmpty {
                let coment = comments[indexPath.row]
                customCell.aComent = coment
            }
            return customCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !comments.isEmpty {
            let value = comments[indexPath.row]
            commentSelected = value
            if Int(value.hasCommentsString ?? "0") ?? 0 > 0 {
                performSegue(withIdentifier: "DetailNewMessage", sender: nil)
            }
        }
    }
}

// MARK: - SelectButtonCellDelegate

extension NewsDetailViewController: SelectButtonCellDelegate {
    func showContact() {
        showDetailCompany()
    }
    func shareData() {
        let text = newsDetail?.url ?? ""
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func getLinkAction() {
        guard let url = URL(string: newsDetail?.url ?? "https://google.com") else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - UITextViewDelegate

extension NewsDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
