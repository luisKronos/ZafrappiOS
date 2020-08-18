//
//  SecondaryNewsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 30/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class SecondaryNewsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var secondaryNewsCollection: UICollectionView!
    
    // MARK: - Properties
    
    var listOfSecondaryNews: [NewsList] = []{
        didSet{
            secondaryNewsCollection.dataSource = self
            secondaryNewsCollection.delegate = self
            secondaryNewsCollection.isScrollEnabled = false 
            secondaryNewsCollection.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
            let layout = self.returnNewsSecondary()
            secondaryNewsCollection.collectionViewLayout = layout
            secondaryNewsCollection.reloadData()
        }
    }
    var mainNewDelegate: ShowNewSelectedDelegate?
    
}

// MARK: - Configure Methods

private extension SecondaryNewsTableViewCell {
    
    func returnNewsSecondary()-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0.1
        let size = CGSize(width: self.secondaryNewsCollection.frame.size.width / 2.6 , height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        layout.itemSize = size
        
        return layout
    }
}

// MARK: - Collection View Delgate

extension SecondaryNewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listOfSecondaryNews.count == 0 {
            return 2
        } else {
            return listOfSecondaryNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = secondaryNewsCollection.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as! NewsCollectionViewCell
        cell.layer.cornerRadius = 24
        if !listOfSecondaryNews.isEmpty {
            let oneNews = listOfSecondaryNews[indexPath.row]
            cell.noticiaSecondary = oneNews
            cell.imageView.downloaded(from: oneNews.image ?? "", contentMode: .scaleToFill)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondaryNew = listOfSecondaryNews[indexPath.row]
        mainNewDelegate?.show(new: secondaryNew)
    }
}
