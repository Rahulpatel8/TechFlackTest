//
//  DescriptionController.swift
//  RSTechFlackTest
//
//  Created by RS on 30/09/18.
//  Copyright © 2018 SL. All rights reserved.
//

import UIKit
import WebKit

class DescriptionController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pushAtLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var webContainerView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var bigImageView: UIImageView!
    
    var contentObject: RootClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webContainerView.isHidden = true
        self.webContainerView.alpha = 0.0
        self.bigImageView.alpha = 0.0
        if contentObject != nil {
            guard let strUrl = contentObject.urlToImage else {
                return
            }
            imageView.sd_setImage(with: URL(string: strUrl), completed: { (image, error, type, url) in
                self.bigImageView.image = image
            })
            authorLabel.text = "Author:\n" + (contentObject.author ?? "")
            titleLabel.text = "Title:\n" + (contentObject.title ?? "")
            descLabel.text = "Description:\n" + (contentObject.descriptionField ?? "")
            pushAtLabel.text = "Published At:\n" + (contentObject.publishedAt ?? "")
            linkButton.setTitle(contentObject.url, for: .normal)
            webView.allowsBackForwardNavigationGestures = true
            webView.allowsLinkPreview = true
        }
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(tappedONImage(recognizer:)))
        imageView.addGestureRecognizer(tapOnImage)
        let tapOnBigImage = UITapGestureRecognizer(target: self, action: #selector(tappedONImage(recognizer:)))
        bigImageView.addGestureRecognizer(tapOnBigImage)
        linkButton.titleLabel?.minimumScaleFactor = 0.5
        linkButton.titleLabel?.numberOfLines = 0
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        let frame = view.frame;
        let topCenter = CGPoint(x: frame.midX,y: frame.midY);
        bigImageView.layer.anchorPoint = topCenter
        bigImageView.frame = UIScreen.main.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tappedONImage(recognizer: UITapGestureRecognizer) {
        if self.bigImageView.alpha == 0.0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.bigImageView.alpha = 1.0
                self.bigImageView.transform = CGAffineTransform.identity
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.bigImageView.alpha = 0.0
                self.bigImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
            })
        }
    }
    
    @IBAction func linkClicked(_ sender: UIButton) {
        self.webContainerView.isHidden = false
        webView.load(URLRequest(url: URL(string: contentObject.url)!))
        UIView.animate(withDuration: 0.3) {
            self.webContainerView.transform = CGAffineTransform.identity
            self.webContainerView.alpha = 1.0
        }
    }
    
    @IBAction func closeClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.webContainerView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            self.webContainerView.alpha = 0.0
        }) { (complete) in
            self.webContainerView.isHidden = true
        }
    }
    
    
}
