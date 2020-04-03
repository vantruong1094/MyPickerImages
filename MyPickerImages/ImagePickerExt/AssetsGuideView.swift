//
//  AssetsGuideView.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit

open class AssetsGuideView: UIView {

    var lineSpace: CGFloat = 10
    var titleStyle: UIFont.TextStyle = .title1
    var bodyStyle: UIFont.TextStyle = .body
    
    fileprivate lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 10
        return label
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        addSubview(messageLabel)
        messageLabel.edgesToSuperview()
    }
    
    open func set(title: String, message: String) {
        
        let attributedString = NSMutableAttributedString()
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.paragraphSpacing = lineSpace
        titleParagraphStyle.alignment = .center
        let attributedTitle = NSMutableAttributedString(string: "\(title)\n", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: titleParagraphStyle
            ])
        
        let bodyParagraphStyle = NSMutableParagraphStyle()
        bodyParagraphStyle.alignment = .center
        bodyParagraphStyle.firstLineHeadIndent = 20
        bodyParagraphStyle.headIndent = 20
        bodyParagraphStyle.tailIndent = -20
        let attributedBody = NSMutableAttributedString(string: message, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.darkGray,
            NSAttributedString.Key.paragraphStyle: bodyParagraphStyle
            ])
        
        attributedString.append(attributedTitle)
        attributedString.append(attributedBody)
        messageLabel.attributedText = attributedString
    }
}

