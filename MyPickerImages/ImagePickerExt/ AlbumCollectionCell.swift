//
//   AlbumCollectionCell.swift
//  MyPickerImages
//
//  Created by Chu Van Truong on 4/5/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {
    
    let albumImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .blue
        return img
    }()
    
    let countImage: UILabel = {
        let lbl = UILabel()
        lbl.text = "20 images"
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        albumImageView.width(100)
        let albumStack = UIStackView(arrangedSubviews: [albumImageView, countImage])
        albumStack.axis = .horizontal
        albumStack.spacing = 8
        contentView.addSubview(albumStack)
        albumStack.edgesToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
