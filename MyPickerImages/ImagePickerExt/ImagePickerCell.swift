//
//  ImagePickerCell.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit
import TinyConstraints

class ImagePickerCell: UICollectionViewCell {
    
    lazy var thumbImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(thumbImageView)
        thumbImageView.edgesToSuperview()
        thumbImageView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
