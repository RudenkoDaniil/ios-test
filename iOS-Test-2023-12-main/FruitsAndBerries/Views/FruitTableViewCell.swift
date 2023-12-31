//
//  FruitTableViewCell.swift
//  iOS-Test
//
//  Created by Daniil on 31.12.2023.
//

import UIKit

final class FruitTableViewCell: UITableViewCell {
    private let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 1
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let uiImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(uiImageView)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            backView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
            backView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5),
            
            uiImageView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 16),
            uiImageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -16),
            uiImageView.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -16),
            uiImageView.widthAnchor.constraint(equalToConstant: 78)
        ])
    }
    
    public func configure(with item: FruitsAndBerriesModels.Load.ViewModel.Item) {
        nameLabel.text = item.name
        if let color = UIColor(hex: item.color) {
            backView.backgroundColor = color
        } 
        else {
            backView.backgroundColor = .systemPink
        }
        if let image = item.image {
            uiImageView.image = image
        }
    }
}
