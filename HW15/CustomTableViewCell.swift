//
//  CustomTableViewCell.swift
//  HW15
//
//  Created by Павел on 14.02.2023.
//

import UIKit
import SnapKit

class CustomTableViewCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let separatorView = UIView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        subtitleLabel.numberOfLines = 2
        avatarImageView.layer.cornerRadius = 8
        titleLabel.font = Constants.titleFont
        subtitleLabel.font = Constants.textFont
        titleLabel.textColor = Constants.titleColor
        subtitleLabel.textColor = Constants.textColor
        separatorView.backgroundColor = Constants.separatorViewColor
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(separatorView)
        
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(16)
            make.size.equalTo(Constants.imageSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(82)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(1)
        }
    }
    
    func configure(model: TextModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        avatarImageView.image = nil
        guard let url = URL(string: model.image) else {
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            DispatchQueue.main.async {
                self.avatarImageView.image = UIImage(data: data)
            }
        }
    }
}

