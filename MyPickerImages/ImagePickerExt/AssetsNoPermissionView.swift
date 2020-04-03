//
//  AssetsNoPermissionView.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit

open class AssetsNoPermissionView: AssetsGuideView {
   
    override func commonInit() {
        set(title: "No permission...", message: "Do you grant permission?")
        super.commonInit()
    }
}
