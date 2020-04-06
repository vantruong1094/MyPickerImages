//
//   AlbumCollectionCell.swift
//  MyPickerImages
//
//  Created by Chu Van Truong on 4/5/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit
import Photos

class AlbumCollectionCell: UICollectionViewCell {
    
    let albumImageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .blue
        return img
    }()
    
    lazy var iconAlbumChecked: UIImageView = {
        let img = UIImageView()
        img.image = #imageLiteral(resourceName: "btn_check_pressed.pdf")
        return img
    }()
        
    let albumTitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "Title"
        lbl.numberOfLines = 1
        return lbl
    }()
    
    let countImage: UILabel = {
        let lbl = UILabel()
        lbl.text = "20 images"
        return lbl
    }()
    
    let lineTopView = UIView()
    let lineBottomView = UIView()
    
    var album: PHAssetCollection?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        albumImageView.width(72)
        iconAlbumChecked.contentMode = .scaleAspectFit
        iconAlbumChecked.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        albumImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let topViewInfo = UIView()
        topViewInfo.height(8)
        let infoAlbumStack = UIStackView(arrangedSubviews: [topViewInfo,albumTitle, countImage, UIView()])
        infoAlbumStack.axis = .vertical
        infoAlbumStack.spacing = 6
        infoAlbumStack.distribution = .fill
        
        let albumStack = UIStackView(arrangedSubviews: [albumImageView, infoAlbumStack, iconAlbumChecked])
        albumStack.axis = .horizontal
        albumStack.spacing = 16
        contentView.addSubview(albumStack)
        albumStack.topToSuperview().constant = 8
        albumStack.leftToSuperview().constant = 8
        albumStack.bottomToSuperview().constant = -8
        albumStack.rightToSuperview().constant = -16
        
        contentView.addSubview(lineTopView)
        lineTopView.edgesToSuperview(excluding: .bottom, insets: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false)
        lineTopView.height(0.5)
        lineTopView.backgroundColor = UIColor.lightGray
        
        contentView.addSubview(lineBottomView)
        lineBottomView.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 0, bottom: 0, right: 0), usingSafeArea: false)
        lineBottomView.height(0.5)
        lineBottomView.backgroundColor = UIColor.lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
