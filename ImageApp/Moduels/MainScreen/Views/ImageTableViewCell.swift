//
//  ImageTableViewCell.swift
//  ImageApp
//
//  Created by Oleksandr Karpenko on 11.12.2020.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "ImageCell"
    
    var isActive: Bool = false
    var isDownloaded: Bool = false
    var imageDetails: UIImage?
    var item: ImageModel? {
        didSet {
            nameLabel.text = item?.name
        }
    }
    
    private lazy var mainImageView: UIImageView = {
        let image = UIImage(named: "empty-photo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0%"
        label.isHidden = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.layer.cornerRadius = 10
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private let padding: CGFloat = 20
    
    private var networkManager: NetworkManager?
    
    func setupUI() {
        addSubview(mainImageView)
        addSubview(nameLabel)
        addSubview(progressLabel)
        addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            mainImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mainImageView.widthAnchor.constraint(equalToConstant: 60),
            
            nameLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: downloadButton.leadingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            progressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            progressLabel.bottomAnchor.constraint(equalTo: downloadButton.topAnchor, constant: -5),
            progressLabel.widthAnchor.constraint(equalToConstant: 80),
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            downloadButton.widthAnchor.constraint(equalToConstant: 80),
            downloadButton.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        if networkManager == nil { networkManager = NetworkManager(delegate: self) }
    }
    
    func startDownload() {
        isActive = true
        progressLabel.isHidden = false
        downloadButton.setTitle("Stop", for: .normal)
        
        if let item = item,
           let url = networkManager?.getURLFromString(item.url) {
            networkManager?.download(from: url)
        }
    }
    
    func stopDownload() {
        isActive = false
        progressLabel.isHidden = true
        downloadButton.setTitle("Download", for: .normal)
        
        networkManager?.abort()
    }
}

extension ImageTableViewCell: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let networkManager = networkManager,
           let data = networkManager.readDownloadedData(of: location) {
            
            DispatchQueue.main.async { [weak self] in
                let image = networkManager.getUIImageFromData(data)
                self?.stopDownload()
                self?.imageDetails = image
                self?.mainImageView.image = image
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
        DispatchQueue.main.async { [weak self] in
            self?.isDownloaded = true
            self?.progressLabel.text = "\(percentDownloaded * 100)%"
        }
    }
}
