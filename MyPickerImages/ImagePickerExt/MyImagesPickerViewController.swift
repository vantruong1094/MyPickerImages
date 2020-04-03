//
//  MyImagesPickerViewController.swift
//  MyPickerImages
//
//  Created by TruongCV on 4/3/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

typealias CollectionViewMethod = UICollectionViewDataSource & UICollectionViewDelegateFlowLayout

class MyImagesPickerViewController: UIViewController {
    
    private let reuseIdentifierCel = "ImagePickerCell"
    
    fileprivate let emptyView: AssetsEmptyView = {
        return AssetsEmptyView()
    }()
    fileprivate let noPermissionView: AssetsNoPermissionView = {
        return AssetsNoPermissionView()
    }()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        let c = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        c.showsVerticalScrollIndicator = false
        c.showsHorizontalScrollIndicator = false
        c.backgroundColor = UIColor.white
        c.bounces = true
        c.translatesAutoresizingMaskIntoConstraints = false
        return c
    }()
    
    let pickerConfig: AssetsPickerConfig
    fileprivate var requestIdMap = [IndexPath: PHImageRequestID]()
    fileprivate var selectedArray = [PHAsset]()
    fileprivate var selectedMap = [String: PHAsset]()
    
    init(config: AssetsPickerConfig) {
        self.pickerConfig = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
        updateEmptyView(count: 0)
        updateNoPermissionView()
        
        AssetsManager.shared.authorize { [weak self] (isGranted) in
            guard let `self` = self else { return }
            self.updateNoPermissionView()
            if isGranted {
               // self.setupAssets()
            } else {
                //self.delegate?.assetsPickerCannotAccessPhotoLibrary?(controller: self.picker)
            }
        }
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        collectionView.register(ImagePickerCell.self, forCellWithReuseIdentifier: reuseIdentifierCel)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(emptyView)
        view.addSubview(noPermissionView)
        emptyView.edgesToSuperview()
        noPermissionView.edgesToSuperview()
    }
    
    func updateEmptyView(count: Int) {
        let hasPermission = PHPhotoLibrary.authorizationStatus() == .authorized
        if hasPermission {
            if emptyView.isHidden {
                if count == 0 {
                    emptyView.isHidden = false
                }
            } else {
                if count > 0 {
                    emptyView.isHidden = true
                }
            }
        } else {
            emptyView.isHidden = true
        }
    }
    
    func updateNoPermissionView() {
        noPermissionView.isHidden = PHPhotoLibrary.authorizationStatus() == .authorized
    }

}

extension MyImagesPickerViewController: CollectionViewMethod {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCel, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 2)/3
        return .init(width: width, height: width)
    }
    
}


