//
//  NewsViewController.swift
//  Zafrapp
//
//  Created by Berenice Miranda on 5/5/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class NewsViewController: ZPMasterViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var emptyView: UIView!
    
    // MARK: - Private Properties
    
    private var premiumList: [NewsList] = []
    private var normalList: [NewsList] = []
    private var informationSaved: Response?
    private var showNews: NewsList?
    private var imageShow: UIImage?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationSaved = InformationClasify.sharedInstance.data
        configureTableView()
        executeService(interest: informationSaved?.messageResponse?.interestArea ?? "")
        swipeDown()
    }
    
    // MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetail" {
            if let viewController = segue.destination as? NewsDetailViewController {
                viewController.newsDetail = showNews
            }
        }
    }
    
}

// MARK :- Private Methods

private extension NewsViewController {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"MainNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "MainNewsTableViewCell")
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName:"SecondaryNewsTableViewCell", bundle: nil), forCellReuseIdentifier: "SecondaryNewsTableViewCell")
    }
    
    func swipeDown() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeDown.direction = .down
        self.emptyView.addGestureRecognizer(swipeDown)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                executeService(interest: informationSaved?.messageResponse?.interestArea ?? "")
            default:
                break
            }
        }
    }
    
    func executeService(interest: String) {
        tableView.isHidden = true
        activityIndicatorBegin()
        let service = NewsService()
        service.newsList(interest: interest) {[weak self] (respService, error) in
            guard let self = self else { return }
            self.activityIndicatorEnd()
            if (error! as NSError).code == 0 && respService != nil {
                if respService?.status == AppConstants.ErrorCode.bad {
                    self.present(ZPAlertGeneric.oneOption(title: "Aún no tienes noticias.", message: respService?.message, actionTitle: AppConstants.String.accept),animated: true)
                } else {
                    if respService?.newsListArray?.count ?? 0 > 0 {
                        self.tableView.isHidden = false
                    }
                    self.updateBothNews(list: respService?.newsListArray ?? [])
                }
            } else if (error! as NSError).code == AppConstants.ErrorCode.noInternetConnection {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.internetConnection, message: AppConstants.String.internetConnectionMessage, actionTitle: AppConstants.String.tryAgain),animated: true)
            } else {
                self.present(ZPAlertGeneric.oneOption(title: AppConstants.String.errorTitle, message: AppConstants.String.tryAgain, actionTitle: AppConstants.String.accept),animated: true)
            }
        }
    }
    
    func updateBothNews(list: [NewsList]){
        premiumList = list.filter{$0.type == "premium"}
        normalList = list.filter{$0.type == "normal"}
        self.tableView.reloadData()
    }
}

// MARK: - TableView Delegates

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "MainNewsTableViewCell", for: indexPath) as? MainNewsTableViewCell
            customCell?.listOfNews = premiumList
            customCell?.delegateNextPage = self
            return customCell ?? UITableViewCell()
        } else {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "SecondaryNewsTableViewCell", for: indexPath) as? SecondaryNewsTableViewCell
            customCell?.mainNewDelegate = self
            customCell?.listOfSecondaryNews = normalList
            return customCell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        } else {
            if normalList.count.isPrime {
                let sum = CGFloat((95 * normalList.count)) +
                95
                return sum
            } else {
                return CGFloat((95 * normalList.count))
            }
        }
    }
}

// MARK: - ShowNewSelectedDelegate

extension NewsViewController: ShowNewSelectedDelegate {
    func show(new: NewsList) {
        showNews = new
        performSegue(withIdentifier: "segueDetail", sender: nil)
    }
    
}
