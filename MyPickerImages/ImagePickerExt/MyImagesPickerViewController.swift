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
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
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
    
    lazy var titleBar: UILabel = {
        let lbl = UILabel()
        return lbl
    }()
    
    init(config: AssetsPickerConfig) {
        self.pickerConfig = config
        AssetsManager.shared.pickerConfig = config
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
        AssetsManager.shared.clear()
        AssetsManager.shared.authorize { [weak self] (isGranted) in
            guard let `self` = self else { return }
            self.updateNoPermissionView()
            if isGranted {
                self.setupAssets()
            } else {
                //self.delegate?.assetsPickerCannotAccessPhotoLibrary?(controller: self.picker)
            }
        }
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("viewWillDisappear")
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupView() {
        
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        view.addSubview(topView)
        topView.edgesToSuperview(excluding: .bottom, insets: UIEdgeInsets.zero, usingSafeArea: false)
        let hTopView: CGFloat = 44.0 + statusBarHeight
        topView.height(hTopView)
        
        view.addSubview(collectionView)
        collectionView.edgesToSuperview(excluding: .top, insets: UIEdgeInsets.zero, usingSafeArea: false)
        collectionView.topToBottom(of: topView)
        collectionView.register(ImagePickerCell.self, forCellWithReuseIdentifier: reuseIdentifierCel)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        
        view.addSubview(emptyView)
        view.addSubview(noPermissionView)
        emptyView.edgesToSuperview()
        noPermissionView.edgesToSuperview()
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("キャンセル", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cancelButton.addTarget(self, action: #selector(onTapCancelButton), for: .touchUpInside)
        
        //navigationItem.titleView = titleBar
        titleBar.isUserInteractionEnabled = true
        titleBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapTitleBar)))
        
        topView.addSubview(titleBar)
        titleBar.centerXToSuperview()
        titleBar.topToSuperview().constant = hTopView/2
        
        topView.addSubview(cancelButton)
        cancelButton.leftToSuperview().constant = 12
        cancelButton.centerY(to: titleBar)
        
    }
    
    override func viewDidLayoutSubviews() {
        print("viewcontrollers: \(navigationController?.viewControllers)")
    }
    
    @objc private func onTapTitleBar() {
        openAlbum()
    }
    
    @objc private func onTapCancelButton() {
        navigationController?.popViewControllerToBottom()
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
    
    func setupAssets() {
        let manager = AssetsManager.shared
        manager.subscribe(subscriber: self)
        manager.fetchAlbums()
        manager.fetchAssets() { [weak self] photos in
            
            guard let `self` = self else { return }
            
            self.updateEmptyView(count: photos.count)
            self.titleBar.text = self.title(forAlbum: manager.selectedAlbum)
            self.collectionView.reloadData()
        }
    }
    
    func title(forAlbum album: PHAssetCollection?) -> String {
        var titleString: String!
        if let albumTitle = album?.localizedTitle {
            titleString = "\(albumTitle) ▾"
        } else {
            titleString = ""
        }
        return titleString
    }
    
    @objc private func openAlbum() {
        presentAlbumController()
    }
    
    func presentAlbumController(animated: Bool = true) {
        guard PHPhotoLibrary.authorizationStatus() == .authorized else { return }
        let controller = AssetsAlbumViewController(config: self.pickerConfig)
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        self.navigationController?.present(navigationController, animated: animated, completion: nil)
    }
    
    func select(album: PHAssetCollection) {
        if AssetsManager.shared.select(album: album) {
            self.titleBar.text = title(forAlbum: album)
            collectionView.reloadData()
        }
    }
    
}

// MARK: - AssetsAlbumViewControllerDelegate
extension MyImagesPickerViewController: AssetsAlbumViewControllerDelegate {
    
    public func assetsAlbumViewControllerCancelled(controller: AssetsAlbumViewController) {
        print("Cancelled.")
    }
    
    public func assetsAlbumViewController(controller: AssetsAlbumViewController, selected album: PHAssetCollection) {
        select(album: album)
    }
}

// MARK: - AssetsManagerDelegate
extension MyImagesPickerViewController: AssetsManagerDelegate {
    func assetsManager(manager: AssetsManager, authorizationStatusChanged oldStatus: PHAuthorizationStatus, newStatus: PHAuthorizationStatus) {
        
    }
    
    func assetsManager(manager: AssetsManager, reloadedAlbumsInSection section: Int) {
        
    }
    
    func assetsManager(manager: AssetsManager, insertedAlbums albums: [PHAssetCollection], at indexPaths: [IndexPath]) {
        
    }
    
    func assetsManager(manager: AssetsManager, removedAlbums albums: [PHAssetCollection], at indexPaths: [IndexPath]) {
        
    }
    
    func assetsManager(manager: AssetsManager, updatedAlbums albums: [PHAssetCollection], at indexPaths: [IndexPath]) {
        
    }
    
    func assetsManager(manager: AssetsManager, reloadedAlbum album: PHAssetCollection, at indexPath: IndexPath) {
        
    }
    
    func assetsManager(manager: AssetsManager, insertedAssets assets: [PHAsset], at indexPaths: [IndexPath]) {
        
    }
    
    func assetsManager(manager: AssetsManager, removedAssets assets: [PHAsset], at indexPaths: [IndexPath]) {
        
    }
    
    func assetsManager(manager: AssetsManager, updatedAssets assets: [PHAsset], at indexPaths: [IndexPath]) {
        
    }
    
    
}

extension MyImagesPickerViewController: CollectionViewMethod {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// asset selected
        let asset = AssetsManager.shared.assetArray[indexPath.row]
        
        let requestImageOption = PHImageRequestOptions()
        requestImageOption.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
        requestImageOption.isNetworkAccessAllowed = true
        
        let manager = PHImageManager.default()
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode:PHImageContentMode.default, options: requestImageOption) { (image: UIImage?, _) in
            // process the original image
            if let imageData = image {
                DispatchQueue.main.async {
                    guard var childsVC = self.navigationController?.children else {
                        return
                    }
                    for (index, childViewController) in childsVC.enumerated() where childViewController.isKind(of: CustomCropperViewController.self) {
                        childsVC.remove(at: index)
                        self.navigationController?.setViewControllers(childsVC, animated: false)
                    }
                    let cropper = CustomCropperViewController(originalImage: imageData)
                    cropper.optionStype = .thumbnailVideo
                    self.navigationController?.pushViewController(cropper, animated: true)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? ImagePickerCell else {
            print("Failed to cast UICollectionViewCell.")
            return
        }
        
        cancelFetching(at: indexPath)
        let requestId = AssetsManager.shared.image(at: indexPath.row, size: pickerConfig.assetCacheSize, completion: { [weak self] (image, isDegraded) in
            if self?.isFetching(indexPath: indexPath) ?? true {
                if !isDegraded {
                    self?.removeFetching(indexPath: indexPath)
                }
                UIView.transition(
                    with: photoCell.thumbImageView,
                    duration: 0.125,
                    options: .transitionCrossDissolve,
                    animations: {
                        photoCell.thumbImageView.image = image
                },
                    completion: nil
                )
            }
        })
        registerFetching(requestId: requestId, at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = AssetsManager.shared.assetArray.count
        updateEmptyView(count: count)
        return count
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

// MARK: - UICollectionViewDataSourcePrefetching
extension MyImagesPickerViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var assets = [PHAsset]()
        for indexPath in indexPaths {
            assets.append(AssetsManager.shared.assetArray[indexPath.row])
        }
        AssetsManager.shared.cache(assets: assets, size: pickerConfig.assetCacheSize)
    }
}

// MARK: - Image Fetch Utility
extension MyImagesPickerViewController {
    
    func cancelFetching(at indexPath: IndexPath) {
        if let requestId = requestIdMap[indexPath] {
            requestIdMap.removeValue(forKey: indexPath)
            AssetsManager.shared.cancelRequest(requestId: requestId)
        }
    }
    
    func registerFetching(requestId: PHImageRequestID, at indexPath: IndexPath) {
        requestIdMap[indexPath] = requestId
    }
    
    func removeFetching(indexPath: IndexPath) {
        if let _ = requestIdMap[indexPath] {
            requestIdMap.removeValue(forKey: indexPath)
        }
    }
    
    func isFetching(indexPath: IndexPath) -> Bool {
        if let _ = requestIdMap[indexPath] {
            return true
        } else {
            return false
        }
    }
}
