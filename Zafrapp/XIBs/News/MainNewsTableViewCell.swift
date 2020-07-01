//
//  MainNewsTableViewCell.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 30/05/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class MainNewsTableViewCell: UITableViewCell {
    @IBOutlet weak var collectionNews: UICollectionView!
    var listOfNews : [listaNews] = []{
        didSet{
            collectionNews.dataSource = self
            collectionNews.delegate = self
            collectionNews.register(UINib(nibName: "NewssCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewssCollectionViewCell")
            collectionNews.showsHorizontalScrollIndicator = false
            let layout = self.returnNewsPrincipal()
            collectionNews.collectionViewLayout = layout
            collectionNews.reloadData()
        }
    }
    
    var delegateNextPage : showNewSelectedDelegate?
    
   func returnNewsPrincipal()-> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0.1
        let size = CGSize(width: self.collectionNews.frame.size.width - 100 , height: collectionNews.frame.size.height - 40)
        layout.sectionInset = UIEdgeInsets (top: 20, left: 20, bottom: 20, right: 20)
        layout.itemSize = size
        
        return layout
    }
}
extension MainNewsTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listOfNews.count == 0 {
            return 2
        }else {
            return listOfNews.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionNews.dequeueReusableCell(withReuseIdentifier: "NewssCollectionViewCell", for: indexPath) as! NewssCollectionViewCell
        cell.layer.cornerRadius = 24
        if listOfNews.count > 0 {
            let oneNews = listOfNews[indexPath.row]
             cell.noticia = oneNews
        cell.image.downloaded(from: oneNews.strImage ?? "", contentMode : .scaleToFill)
    }
    return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let new = listOfNews[indexPath.row]
        delegateNextPage?.show(New: new)
    }
}
