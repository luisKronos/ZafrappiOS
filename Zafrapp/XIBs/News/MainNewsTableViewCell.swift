//
//  MainNewsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 30/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class MainNewsTableViewCell: UITableViewCell {
    
    // MARK: - Private IBOutlet
    
    @IBOutlet private var newsCollection: UICollectionView!
    
    var listOfNews: [NewsList] = []{
        didSet{
            newsCollection.dataSource = self
            newsCollection.delegate = self
            newsCollection.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
            newsCollection.showsHorizontalScrollIndicator = false
            let layout = self.returnNewsPrincipal()
            newsCollection.collectionViewLayout = layout
            newsCollection.reloadData()
        }
    }
    
    var delegateNextPage: ShowNewSelectedDelegate?
    
    func returnNewsPrincipal()-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0.1
        let size = CGSize(width: self.newsCollection.frame.size.width - 100 , height: newsCollection.frame.size.height - 40)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = size
        
        return layout
    }
}

// MARK: - Collection View Delegates

extension MainNewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listOfNews.isEmpty {
            return 2
        } else {
            return listOfNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = newsCollection.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.layer.cornerRadius = 24
        if !listOfNews.isEmpty {
            let oneNews = listOfNews[indexPath.row]
            cell.noticia = oneNews
            cell.imageView.downloaded(from: oneNews.image ?? "", contentMode: .scaleToFill)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let new = listOfNews[indexPath.row]
        delegateNextPage?.show(new: new)
    }
}
