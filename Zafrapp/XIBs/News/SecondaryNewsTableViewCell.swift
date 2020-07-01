//
//  SecondaryNewsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 30/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class SecondaryNewsTableViewCell: UITableViewCell {

    @IBOutlet weak var secondaryNewsCollection: UICollectionView!
   var listOfSecondaryNews : [listaNews] = []{
        didSet{
            secondaryNewsCollection.dataSource = self
            secondaryNewsCollection.delegate = self
            secondaryNewsCollection.isScrollEnabled = false 
            secondaryNewsCollection.register(UINib(nibName: "NewssCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewssCollectionViewCell")
            let layout = self.returnNewsSecondary()
            secondaryNewsCollection.collectionViewLayout = layout
            secondaryNewsCollection.reloadData()
        }
    }
    var mainNewDelegate : showNewSelectedDelegate?
    
    func returnNewsSecondary()-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0.1
        let size = CGSize(width: self.secondaryNewsCollection.frame.size.width / 2.6 , height: 150)
        layout.sectionInset = UIEdgeInsets (top: 0, left: 20, bottom: 20, right: 20)
        layout.itemSize = size
        
        return layout
    }
}

extension SecondaryNewsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listOfSecondaryNews.count == 0 {
            return 2
        }else {
            return listOfSecondaryNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = secondaryNewsCollection.dequeueReusableCell(withReuseIdentifier: "NewssCollectionViewCell", for: indexPath) as! NewssCollectionViewCell
        cell.layer.cornerRadius = 24
        if listOfSecondaryNews.count > 0 {
            let oneNews = listOfSecondaryNews[indexPath.row]
            cell.noticiaSecondary = oneNews
           cell.image.downloaded(from: oneNews.strImage ?? "", contentMode : .scaleToFill)
    }
    return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let secondaryNew = listOfSecondaryNews[indexPath.row]
        mainNewDelegate?.show(New: secondaryNew)
    }
}
