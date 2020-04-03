//
//  AssetsEmptyView.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//
import UIKit

open class AssetsEmptyView: AssetsGuideView {
    
    override func commonInit() {
        var messageKey = "Message_No_Items"
        if !UIImagePickerController.isCameraDeviceAvailable(.rear) {
            messageKey = "Message_No_Items_Camera"
        }
        set(title: "No image...", message: "\(messageKey)")
        titleStyle = .title2
        super.commonInit()
    }
}
