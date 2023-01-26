//
//  GFAvatarImageView.swift
//
//  Created by Rashad Surratt on 1/13/23.
//

import UIKit

class GFAvatarImageView: UIImageView {
    
    let cache            = NetworkManager.shared.cache
    let placeHolderImage = Images.placeHolder
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius                        = 10
        clipsToBounds                             = true
        image                                     = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadImage(fromURL url: String) {
        
        Task {
            image = await NetworkManager.shared.downloadImage(from: url) ?? placeHolderImage
        }
    }
}
