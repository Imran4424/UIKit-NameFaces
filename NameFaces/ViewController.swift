//
//  ViewController.swift
//  NameFaces
//
//  Created by Shah Md Imran Hossain on 17/9/22.
//

import UIKit

class ViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

// MARK: - Collection View datasource
extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as? PersonCell else {
            print("Unable to dequeue Person Cell")
            return UICollectionViewCell()
        }
        
        cell.personName.text = "label"
        
        return cell
    }
}

