//
//  ViewController.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushViewControllerFromBottom(controller: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
    
    func popViewControllerToBottom() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        popViewController(animated: false)
    }
    
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var originalImage: UIImage?
    var cropperState: CropperState?

    lazy var startButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - 200, width: view.frame.size.width, height: 40))
        button.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
        button.setTitle("Start", for: .normal)
        return button
    }()

    lazy var reeditButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: view.frame.size.height - 160, width: view.frame.size.width, height: 40))
        button.addTarget(self, action: #selector(reeditButtonPressed(_:)), for: .touchUpInside)
        button.setTitle("Re-edit", for: .normal)
        return button
    }()

    lazy var imageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 100, width: view.frame.size.width, height: view.frame.size.width))
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 1
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(imageView)
        view.addSubview(startButton)
        view.addSubview(reeditButton)
        
    }

    @objc
    func startButtonPressed(_: UIButton) {
        var pickerConfig = AssetsPickerConfig()
        pickerConfig = pickerConfig.prepare()
        let myImagePicker = MyImagesPickerViewController(config: pickerConfig)
        navigationController?.pushViewControllerFromBottom(controller: myImagePicker)
    }

    @objc
    func reeditButtonPressed(_: UIButton) {
        if let image = originalImage, let state = cropperState {
            let cropper = CustomCropperViewController(originalImage: image, initialState: state)
            cropper.optionStype = .thumbnailVideo
            navigationController?.pushViewController(cropper, animated: true)
        }
    }
    
    func cropperDidConfirm(originImage: UIImage, croppedImage: UIImage?, state: CropperState?) {
        if let state = state,
            let image = croppedImage {
            originalImage = originImage
            cropperState = state
            imageView.image = image
        }
    }
    
}

