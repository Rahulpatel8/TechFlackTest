//
//  ViewController.swift
//  RSTechFlackTest
//
//  Created by RS on 26/09/18.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var imageDatas = [RootClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        Alamofire.request(URL(string: Base_Url+Api_Key)!).responseData { (data) in
            do {
                let dict = try JSONSerialization.jsonObject(with: data.data! , options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:Any]
                print(dict)
                let tempArr = dict["articles"] as! [[String:Any]]
                for obj in tempArr {
                    let imageData = RootClass(fromDictionary: obj)
                    self.imageDatas.append(imageData)                    
                }
                self.collectionView.reloadData()
            } catch {
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 2.2
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageDetailCell {
            guard let image = cell.imageView.image else {
                return CGSize(width: width, height: width)
            }
            
            let text = imageDatas[indexPath.item].descriptionField
            let font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
            let textHeight = text?.heightForWidth(width: width, font: font)

            return CGSize(width: width, height: image.height(forWidth: width ) + 2 + textHeight!)
        }
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageDetailCell", for: indexPath) as! ImageDetailCell
        let imageData = imageDatas[indexPath.item]
        cell.descriptionLabel.text = imageData.descriptionField
        if let strUrl = imageData.urlToImage {
            cell.imageView.sd_setImage(with: URL(string: strUrl)!, completed: { (image, error, type, url) in
                self.collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contentObj = imageDatas[indexPath.item]
        let descVC  = self.storyboard?.instantiateViewController(withIdentifier: "DescriptionController") as! DescriptionController
        descVC.contentObject = contentObj
        self.navigationController?.pushViewController(descVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}

