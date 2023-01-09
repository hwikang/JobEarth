//
//  DetailViewController.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/09.
//

import Foundation
import UIKit


final class DetailViewController : UIViewController {
    private var name: String!
    private var imageUrl: String!
   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    static func initiate(title: String, imageUrl: String) -> DetailViewController{
        let vc = UIStoryboard(name: "Detail", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.name = title
        vc.imageUrl = imageUrl
        return vc
    }
    
    override func viewDidLoad() {
        titleLabel.text = name
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
    }
    @IBAction func onTouchBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}


