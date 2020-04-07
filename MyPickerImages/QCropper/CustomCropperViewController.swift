//
//  CustomCropperViewController.swift
//  DemoQCropper
//
//  Created by TruongCV on 3/12/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit

class CustomCropperViewController: CropperViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isCropBoxPanEnabled = false
        topBar.isHidden = true
        angleRuler.isHidden = true
        aspectRatioPicker.isHidden = true
        toolbar.isHidden = true
    }

    override func resetToDefaultLayout() {
        super.resetToDefaultLayout()

        aspectRatioLocked = true
        //setAspectRatioValue(1.2)
        setAspectRatio(.ratio(width: 9, height: 16))
    }
}
