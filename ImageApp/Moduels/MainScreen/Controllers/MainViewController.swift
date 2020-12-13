//
//  MainViewController.swift
//  ImageApp
//
//  Created by Oleksandr Karpenko on 11.12.2020.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Images"
        setupUI()
    }
    
    private let padding: CGFloat = 20
    
    private var viewModel = ImageViewModel()
    
    func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.backgroundColor = .white
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImageTableViewCell else { return }
        cell.setSelected(false, animated: true)
        
        if cell.isDownloaded {
            let vc = ImageDetailsViewController()
            vc.setImage(with: cell.imageDetails)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if cell.isActive {
                cell.stopDownload()
            } else {
                cell.startDownload()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.cellIdentifier) as? ImageTableViewCell {
            cell.item = viewModel.images[indexPath.row]
            return cell
        }
        return .init()
    }
}
