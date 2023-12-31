//
//  FruitsAndBerriesDetailsViewController.swift
//  iOS-Test
//
//  Created by Daniii on 31.12.2023.
//

import UIKit

final class FruitsAndBerriesDetailsViewController: UIMainViewController {
    public var item: FruitsAndBerriesModels.Load.ViewModel.Item?
    public var descriptionItem: FruitsAndBerriesModels.LoadDetails.Response?
    // MARK: - Properties
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let uiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1"
        return label
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        let refreshButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(closeView))
        refreshButton.tintColor = UIColor.white
        navigationItem.leftBarButtonItem = refreshButton
        
        guard let item = item, let descriptionItem = descriptionItem else { return }
        title = item.name
        descriptionLabel.text = descriptionItem.text
        if let color = UIColor(hex: item.color) {
            backView.backgroundColor = color
        } 
        else {
            backView.backgroundColor = .systemPink
        }
        if let image = item.image {
            uiImageView.image = image
        }
        else {
            uiImageView.image = UIImage(systemName: "photo.artframe")
        }
        view.addSubview(backView)
        view.addSubview(uiImageView)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backView.bottomAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            backView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            backView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            
            descriptionLabel.topAnchor.constraint(equalTo: uiImageView.bottomAnchor, constant: 15),
            descriptionLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 15),
            descriptionLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -15),
            
            uiImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 15),
            uiImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uiImageView.heightAnchor.constraint(equalToConstant: 100),
            uiImageView.widthAnchor.constraint(equalToConstant: 100),
        ])
    }
    @objc func closeView(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
}
