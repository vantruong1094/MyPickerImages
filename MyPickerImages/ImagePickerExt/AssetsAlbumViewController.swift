//
//  AssetsAlbumViewController.swift
//  MyPickerImages
//
//  Created by Chu Van Truong on 4/5/20.
//  Copyright © 2020 TruongCV. All rights reserved.
//

import UIKit
import Photos

// MARK: - AssetsAlbumViewControllerDelegate
protocol AssetsAlbumViewControllerDelegate: class {
    func assetsAlbumViewControllerCancelled(controller: AssetsAlbumViewController)
    func assetsAlbumViewController(controller: AssetsAlbumViewController, selected album: PHAssetCollection)
}

class AssetsAlbumViewController: UIViewController {
    
    private let reuseIdentifierCel = "AlbumCollectionCell"
    weak var delegate: AssetsAlbumViewControllerDelegate?
    
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
        
        AssetsManager.shared.authorize(completion: { [weak self] isAuthorized in
            if isAuthorized {
                AssetsManager.shared.fetchAlbums { (_) in
                    self?.collectionView.reloadData()
                }
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperview()
        collectionView.register(AlbumCollectionCell.self, forCellWithReuseIdentifier: reuseIdentifierCel)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
    
    
}

extension AssetsAlbumViewController: CollectionViewMethod {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.assetsAlbumViewController(controller: self, selected: AssetsManager.shared.album(at: indexPath))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let albumCell = cell as? AlbumCollectionCell else {
            return
        }
        albumCell.album = AssetsManager.shared.album(at: indexPath)
        albumCell.albumTitle.text = AssetsManager.shared.title(at: indexPath)
        albumCell.countImage.text = "\(AssetsManager.shared.numberOfAssets(at: indexPath))"
        
        AssetsManager.shared.imageOfAlbum(at: indexPath, size: pickerConfig.albumCacheSize, isNeedDegraded: true) { (image) in
            if let image = image {
                if let _ = albumCell.albumImageView.image {
                    UIView.transition(
                        with: albumCell.albumImageView,
                        duration: 0.20,
                        options: .transitionCrossDissolve,
                        animations: {
                            albumCell.albumImageView.image = image
                    },
                        completion: nil
                    )
                } else {
                    albumCell.albumImageView.image = image
                }
            } else {
                albumCell.albumImageView.image = nil
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let count = AssetsManager.shared.numberOfSections
        print("numberOfSections: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = AssetsManager.shared.numberOfAlbums(inSection: section)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifierCel, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return .init(width: width, height: 88)
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension AssetsAlbumViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var assets = [PHAsset]()
        for albumIndexPath in indexPaths {
            let album = AssetsManager.shared.album(at: albumIndexPath)
            if let asset = AssetsManager.shared.fetchResult(forAlbum: album)?.lastObject {
                assets.append(asset)
            }
        }
        if assets.count > 0 {
            AssetsManager.shared.cache(assets: assets, size: pickerConfig.albumCacheSize)
            print("Caching album images at \(indexPaths)")
        }
    }
}
