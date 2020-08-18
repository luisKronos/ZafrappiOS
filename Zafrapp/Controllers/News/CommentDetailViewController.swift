//
//  CommentDetailViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 25/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class CommentDetailViewController: ZPMasterViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var button: UIButton!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textView: UITextView!
    @IBOutlet private var lycHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var commentView: UIView!
    @IBOutlet private var lycDetailHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - Private Properties
    
    private var comments: [Comment] = []
    
    // MARK: - Public Properties
    
    var isImageSaved = false
    var comentSelected: Comment?
    
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
        configureView()
        checkComments()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        comentSelected?.isAnswerShown = true
        comentSelected?.isMovSelected = true
        if comentSelected?.userId != userId {
            commentView.isHidden = true
            lycDetailHeightConstraint.constant = 10
        }
        serviceGetReplyComments(newsId: Int(comentSelected?.newsId ?? "0") ?? 0)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - IBActions
    
    @IBAction func buttonAction(_ sender: Any) {
        if textView.text == "Escribe un comentario..."{
            present(ZPAlertGeneric.oneOption(title: "Nuevo comentario", message: "Ingresa un comentario", actionTitle: AppConstants.String.accept),animated: true)
        } else {
            addReplyComments(INews: Int(comentSelected?.newsId ?? "0") ?? 0, IUser: Int(userId) ?? 0, Text: textView.text)
        }
    }
    
}

// MARK :- Private Methods

private extension CommentDetailViewController {
    
    func checkComments() {
        let user = userId
        let checkData = comments.filter({$0.userId == user})
        if checkData.count < 2 {
            textView.text = "Escribe un comentario..."
        } else {
            textView.text = "Haz alcanzado el límite de comentarios, sigue esta conversación por WhatsApp"
            button.isEnabled = false
            commentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
            textView.isEditable = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            commentView.addGestureRecognizer(tap)
        }
    }
    func succesComment() {
        serviceGetReplyComments(newsId: Int(comentSelected?.newsId ?? "0") ?? 0)
        tableView.reloadData()
        checkComments()
    }
    
    func addReplyComments(INews: Int, IUser: Int, Text: String) {
        let service = SendCommentService()
        self.activityIndicatorBegin()
        service.sendComentario(id_news: INews, user_Id: IUser, textcometaio: Text, bisReply: true) {[weak self] (respService, error) in
            guard self != nil else { return }
            self?.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == "OK" {
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
    
    func serviceGetReplyComments(newsId: Int) {
        let service = CommentService()
        self.activityIndicatorBegin()
        service.obtainComents(id_news: newsId, isReply: true) {[weak self] (respService, error) in
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
    
    func showDetailCompany(clientId: String) {
        let storyboard = UIStoryboard(name: "ProfileCompany", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "profileVc") as! CompanyProfileViewController
        vc.companyId = clientId
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        showDetailCompany(clientId: comentSelected?.clientId ?? "3")
    }
    
    func configureView() {
        let imagefromDocuments: UIImage? = getImageFromDocument().fileInDocumentsDirectory(filename: "ProfilePicture\(userId).jpg")
        if  isImageSaved{
            self.imageView.image = imagefromDocuments
            nameLabel.isHidden = true
        } else {
            var urlImage: String? = imageSaved
            urlImage = imageSaved.isEmpty ? nil: imageSaved
            if let image = urlImage {
                imageView.downloaded(from: image, contentMode: .scaleToFill)
                nameLabel.isHidden = true
            } else {
                nameLabel.isHidden = false
                changeLabel().changeColorLabel(string: nameSaved, label: nameLabel)
            }
        }
        textView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
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
                self.lycHeightConstraint.constant = 0.0
            } else {
                self.lycHeightConstraint.constant = (endFrame?.size.height ?? 0.0)-90
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
}

// MARK: - TableView Delegate

extension CommentDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell ?? CommentsTableViewCell()
        customCell.selectionStyle = .none
        if indexPath.section == 0 {
            customCell.aComent = comentSelected
        } else {
            customCell.selectionStyle = .none
            if !comments.isEmpty {
                let coment = comments[indexPath.row]
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

// MARK: - UITextViewDelegate

extension CommentDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
