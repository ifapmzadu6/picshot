//
//  ViewController.swift
//  Photony
//
//  Created by 狩宿恵介 on 2015/05/13.
//  Copyright (c) 2015年 KeisukeKarijuku. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import Photos


class ViewController: UIViewController, HomeSceneDelegate, UIDocumentInteractionControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPhotoLibraryChangeObserver {
    
    var homeSceneView: SKView?
    
    var assetURL: String?
    var originalImage: UIImage?
    
    var fetchResult: PHFetchResult<PHAsset>?
    
    var instagramLabel: UILabel?
    var documentController: UIDocumentInteractionController?
    var isDocumentControllerSelected: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        homeSceneView = SKView(frame: view.bounds)
        if let sceneView = homeSceneView {
            let scene = HomeScene(fileNamed: "HomeScene")
            scene?.myDelegate = self
            sceneView.presentScene(scene)
            view.addSubview(sceneView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            switch PHPhotoLibrary.authorizationStatus() {
            case .notDetermined:
                DispatchQueue.main.async {
                    PHPhotoLibrary.requestAuthorization { (status) -> Void in
                        switch status {
                        case .authorized:
                            DispatchQueue.main.async {
                                self.loadLastPhoto()
                            }
                        case .notDetermined:
                            break
                        case .denied:
                            fallthrough
                        case .restricted:
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Allow picshot Access to your Photos", message: "Just Go to Settings > Privacy > Photos and Switch picshot to ON.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                alertController.popoverPresentationController?.sourceView = self.view
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            case .denied:
                fallthrough
            case .restricted:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Allow picshot Access to your Photos", message: "Just Go to Settings > Privacy > Photos and Switch picshot to ON.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alertController.popoverPresentationController?.sourceView = self.view
                    self.present(alertController, animated: true, completion: nil)
                }
            case .authorized:
                self.loadLastPhoto()
                PHPhotoLibrary.shared().register(self)
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func loadLastPhoto() {
        let option = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssets(with: option)
        if let asset = fetchResult?.firstObject {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (image, info) -> Void in
                DispatchQueue.global().async {
                    if let scene = self.homeSceneView?.scene as? HomeScene {
                        if let squaredImage = image?.squaredImage() {
                            DispatchQueue.main.async {
                                scene.setImage(image: squaredImage)
                            }
                        }
                    }
                }
            }
            
            options.resizeMode = .none
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, info) -> Void in
                self.originalImage = image
            }
        }
        else {
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "No Picture", message: "Needs to Take a Picture.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alertController.popoverPresentationController?.sourceView = self.view
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        if let fetchResult = fetchResult, let details = changeInstance.changeDetails(for: fetchResult) {
            let isNewPhoto = details.insertedIndexes?.first == 0 ? true : false
            if isNewPhoto == true {
                if let scene = homeSceneView?.scene as? HomeScene {
                    scene.resetImage()
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                    self.loadLastPhoto()
                }
            }
        }
    }
    
    func didSelectTwitter() {
        Analytics.sendEvent(category: "twitter", action: "open")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) == false {
            return
        }
        
        if let viewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
            viewController.add(originalImage)
            viewController.completionHandler = {[weak self] (result) -> Void in
                if result == .done {
                    Analytics.sendEvent(category: "twitter", action: "done")
                }
                else {
                    Analytics.sendEvent(category: "twitter", action: "cancel")
                }
                
                if let scene = self?.homeSceneView?.scene as? HomeScene {
                    scene.reset()
                }
            }
            viewController.popoverPresentationController?.sourceView = view
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func didSelectFacebook() {
        Analytics.sendEvent(category: "facebook", action: "open")
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) == false {
            return
        }
        
        if let viewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
            viewController.add(originalImage)
            viewController.completionHandler = {[weak self] (result) -> Void in
                if result == .done {
                    Analytics.sendEvent(category: "facebook", action: "done")
                }
                else {
                    Analytics.sendEvent(category: "facebook", action: "cancel")
                }
                
                if let scene = self?.homeSceneView?.scene as? HomeScene {
                    scene.reset()
                }
            }
            viewController.popoverPresentationController?.sourceView = view
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func willSelectInstagram() {
        instagramLabel = UILabel()
        if let label = instagramLabel {
            label.text = "Select\nCopy to Instagram"
            label.textColor = UIColor.white
            label.font = UIFont(name: "Avenir-Book", size: 24)
            label.textAlignment = .center
            label.numberOfLines = 2
            label.sizeToFit()
            label.center.x = view.center.x
            label.center.y = 70
            label.alpha = 0
            view.addSubview(label)
            
            UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveLinear, animations: { () -> Void in
                label.alpha = 1
            }, completion: { (finish) -> Void in
            })
        }
    }
    
    func didSelectInstagram() {
        if let image = originalImage {
            postInstagram(image: image)
        }
    }
    
    func didSelectCameraButton() {
        Analytics.sendEvent(category: "camera", action: "open")
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
            let viewController = ImagePickerController()
            viewController.delegate = self
            viewController.sourceType = .camera
            viewController.cameraFlashMode = .off
            viewController.cameraDevice = .rear
            viewController.popoverPresentationController?.sourceView = view
            present(viewController, animated: true, completion: nil)
        }
    }
    
    func didSelectAlbumButton() {
        Analytics.sendEvent(category: "album", action: "open")
        
        let viewController = ImagePickerController()
        viewController.delegate = self
        viewController.sourceType = .savedPhotosAlbum
        viewController.popoverPresentationController?.sourceView = view
        present(viewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if picker.sourceType == .camera {
            Analytics.sendEvent(category: "camera", action: "cancel")
        }
        else {
            Analytics.sendEvent(category: "album", action: "cancel")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let scene = homeSceneView?.scene as? HomeScene {
            scene.resetImage()
        }
        
        if picker.sourceType == .camera {
            Analytics.sendEvent(category: "camera", action: "done")
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                picker.dismiss(animated: true, completion: nil)
            }
        }
        else {
            Analytics.sendEvent(category: "album", action: "done")
            
            if let assetURL = info[UIImagePickerControllerReferenceURL] as? NSURL {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
                let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL as URL], options: fetchOptions)
                if let asset = result.firstObject {
                    let options = PHImageRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.deliveryMode = .highQualityFormat
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (image, info) -> Void in
                        picker.dismiss(animated: true, completion: {[weak self] () -> Void in
                            if let scene = self?.homeSceneView?.scene as? HomeScene {
                                scene.resetImage()
                                DispatchQueue.global(qos: .background).async {
                                    if let squaredImage = image?.squaredImage() {
                                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                            scene.setImage(image: squaredImage)
                                        }
                                    }
                                }
                            }
                            })
                    }
                    
                    options.resizeMode = .none
                    PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { (image, info) -> Void in
                        self.originalImage = image
                    }
                }
            }
        }
    }
    
    func postInstagram(image: UIImage) {
        Analytics.sendEvent(category: "instagram", action: "open")
        
        let instagramURL = URL(string: "instagram://app")
        if let instagramURL = instagramURL , UIApplication.shared.canOpenURL(instagramURL) {
            let imageData = UIImageJPEGRepresentation(image, 1)
            let filePath = NSTemporaryDirectory().appending("image.igo")
            do {
                let url = URL(fileURLWithPath: filePath)
                try imageData?.write(to: url, options: .atomicWrite)
            }
            catch _ {
                return
            }
            
            let fileURL = URL(fileURLWithPath: filePath)
            documentController = UIDocumentInteractionController(url: fileURL)
            if let controller = documentController {
                controller.delegate = self
                controller.uti = "com.instagram.photo"
                controller.presentOpenInMenu(from: view.bounds, in: view, animated: true)
            }
        }
        else {
            let alertController = UIAlertController(title: "Needs Install \"Instagram\" to Share", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "AppStore", style: .default, handler: { (action) -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                    if let label = self.instagramLabel {
                        UIView.animate(withDuration: 0.2, animations: { () -> Void in
                            label.alpha = 0
                            }, completion: { (finishec) -> Void in
                                label.removeFromSuperview()
                                self.instagramLabel = nil
                        })
                    }
                    if let scene = self.homeSceneView?.scene as? HomeScene {
                        scene.reset()
                    }
                }
                
                if let url = URL(string: "https://itunes.apple.com/app/instagram/id389801252") , UIApplication.shared.canOpenURL(url) == true {
                    UIApplication.shared.openURL(url)
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
                if let label = self.instagramLabel {
                    UIView.animate(withDuration: 0.2, animations: { () -> Void in
                        label.alpha = 0
                        }, completion: { (finishec) -> Void in
                            label.removeFromSuperview()
                            self.instagramLabel = nil
                    })
                }
                if let scene = self.homeSceneView?.scene as? HomeScene {
                    scene.reset()
                }
            }))
            alertController.popoverPresentationController?.sourceView = view
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func documentInteractionController(_ controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        isDocumentControllerSelected = true
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        let delay: Double
        if isDocumentControllerSelected == true {
            delay = 3
            isDocumentControllerSelected = false
            
            Analytics.sendEvent(category: "instagram", action: "done")
        }
        else {
            delay = 0
            
            Analytics.sendEvent(category: "instagram", action: "cancel")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            if let label = self.instagramLabel {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    label.alpha = 0
                }, completion: { (finishec) -> Void in
                    label.removeFromSuperview()
                    self.instagramLabel = nil
                })
            }
            if let scene = self.homeSceneView?.scene as? HomeScene {
                scene.reset()
            }
        }
    }
    
}


