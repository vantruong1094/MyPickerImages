//
//  AssetsAlbumViewController.swift
//  MyPickerImages
//
//  Created by Chu Van Truong on 4/5/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit


class AssetsAlbumViewController: UIViewController {
    
    private let reuseIdentifierCel = "AlbumCollectionCell"

    
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
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifierCel)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
}

extension AssetsAlbumViewController: CollectionViewMethod {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// asset selected
        //let asset = AssetsManager.shared.assetArray[indexPath.row]
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
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
        let width = collectionView.frame.width
        return .init(width: width, height: 100)
    }
    
}
