//
//  ImageScrollViewController.swift
//  Zafrapp
//
//  Created by Mayte Dominguez on 27/07/20.
//  Copyright © 2020 Berenice Miranda. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {
    
    var urlImage : String?
    var imageScrollView: ImageScrollView!

    override func viewWillAppear(_ animated: Bool) {
            let image = UIImage(named: "backGround")!
            self.imageScrollView.set(image: image)
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()

        getImageFromWeb(urlImage ?? "") { (image) in
            if let image = image {
                self.imageScrollView.set(image: image)
            }
        }
        
    }
    
    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
      func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
            guard let url = URL(string: urlString) else {
    return closure(nil)
            }
            let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    print("error: \(String(describing: error))")
                    return closure(nil)
                }
                guard response != nil else {
                    print("no response")
                    return closure(nil)
                }
                guard data != nil else {
                    print("no data")
                    return closure(nil)
                }
                DispatchQueue.main.async {
                    closure(UIImage(data: data!))
                }
            }; task.resume()
        }

}


