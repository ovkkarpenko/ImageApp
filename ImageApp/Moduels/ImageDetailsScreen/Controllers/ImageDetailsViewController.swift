//
//  ImageDetailsViewController.swift
//  ImageApp
//
//  Created by Oleksandr Karpenko on 13.12.2020.
//

import UIKit

class ImageDetailsViewController: UIViewController {
    
    private lazy var imageDetailsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Details"
        setupUI()
    }
    
    private let padding: CGFloat = 20
    
    func setupUI() {
        view.addSubview(imageDetailsImageView)
        
        NSLayoutConstraint.activate([
            imageDetailsImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            imageDetailsImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            imageDetailsImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding+60),
            imageDetailsImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
        ])
        
        view.backgroundColor = .white
    }
    
    func setImage(with image: UIImage?) {
        imageDetailsImageView.image = image
    }
}
