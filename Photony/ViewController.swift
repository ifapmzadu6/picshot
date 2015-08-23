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
    
    var fetchResult: PHFetchResult?
    
    var instagramLabel: UILabel?
    var documentController: UIDocumentInteractionController?
    var isDocumentControllerSelected: Bool = false
    
    func showHomeScene() {
        homeSceneView = SKView(frame: view.bounds)
        if let sceneView = homeSceneView {
            let scene = HomeScene(fileNamed: "HomeScene")
            scene.myDelegate = self
            sceneView.presentScene(scene)
            view.addSubview(sceneView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor()
        
        showHomeScene()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            switch PHPhotoLibrary.authorizationStatus() {
            case .NotDetermined:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    PHPhotoLibrary.requestAuthorization { (status) -> Void in
                        switch status {
                        case .Authorized:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.loadLastPhoto()
                            })
                        case .NotDetermined:
                            break
                        case .Denied:
                            fallthrough
                        case .Restricted:
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                let alertController = UIAlertController(title: "Allow picshot Access to your Photos", message: "Just Go to Settings > Privacy > Photos and Switch picshot to ON.", preferredStyle: .Alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                alertController.popoverPresentationController?.sourceView = self.view
                                self.presentViewController(alertController, animated: true, completion: nil)
                            })
                        }
                    }
                })
            case .Denied:
                fallthrough
            case .Restricted:
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alertController = UIAlertController(title: "Allow picshot Access to your Photos", message: "Just Go to Settings > Privacy > Photos and Switch picshot to ON.", preferredStyle: .Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    alertController.popoverPresentationController?.sourceView = self.view
                    self.presentViewController(alertController, animated: true, completion: nil)
                })
            case .Authorized:
                self.loadLastPhoto()
                PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
            }
        }
    }
    
    func loadLastPhoto() {
        let option = PHFetchOptions()
        option.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchResult = PHAsset.fetchAssetsWithOptions(option)
        if let asset = fetchResult?.firstObject as? PHAsset {
            let options = PHImageRequestOptions()
            options.networkAccessAllowed = true
            options.deliveryMode = .HighQualityFormat
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(200, 200), contentMode: .AspectFill, options: options) { (image, info) -> Void in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), { () -> Void in
                    if let scene = self.homeSceneView?.scene as? HomeScene {
                        if let squaredImage = image.squaredImage() {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                scene.setImage(squaredImage)
                            })
                        }
                    }
                })
            }
            
            options.resizeMode = .None
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight)), contentMode: .AspectFill, options: options) { (image, info) -> Void in
                self.originalImage = image
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alertController = UIAlertController(title: "No Picture", message: "Needs to Take a Picture.", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                alertController.popoverPresentationController?.sourceView = self.view
                self.presentViewController(alertController, animated: true, completion: nil)
            })
        }
    }
    
    func photoLibraryDidChange(changeInstance: PHChange!) {
        if let details = changeInstance.changeDetailsForFetchResult(fetchResult) {
            var isNewPhoto = details.insertedIndexes?.firstIndex == 0 ? true : false
            if isNewPhoto == true {
                if let scene = homeSceneView?.scene as? HomeScene {
                    scene.resetImage()
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    self.loadLastPhoto()
                }
            }
        }
    }
    
    func didSelectTwitter() {
        let viewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        viewController.addImage(originalImage)
        viewController.completionHandler = {[weak self, viewController] (result) -> Void in
            if result == .Done {
                Analytics.sendEvent(category: "twitter", action: "done")
                
                self?.doYouLikePicshot()
            }
            else {
                Analytics.sendEvent(category: "twitter", action: "cancel")
            }
            
            if let scene = self?.homeSceneView?.scene as? HomeScene {
                scene.reset()
            }
        }
        viewController.popoverPresentationController?.sourceView = view
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func didSelectFacebook() {
        let viewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        viewController.addImage(originalImage)
        viewController.completionHandler = {[weak self] (result) -> Void in
            if result == .Done {
                Analytics.sendEvent(category: "facebook", action: "done")
                
                self?.doYouLikePicshot()
            }
            else {
                Analytics.sendEvent(category: "facebook", action: "cancel")
            }
            
            if let scene = self?.homeSceneView?.scene as? HomeScene {
                scene.reset()
            }
        }
        viewController.popoverPresentationController?.sourceView = view
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func willSelectInstagram() {
        instagramLabel = UILabel()
        if let label = instagramLabel {
            label.text = "Select\nOpen in Instagram"
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "Avenir-Book", size: 24)
            label.textAlignment = .Center
            label.numberOfLines = 2
            label.sizeToFit()
            label.center.x = view.center.x
            label.center.y = 70
            label.alpha = 0
            view.addSubview(label)
            
            UIView.animateWithDuration(0.2, delay: 0.5, options: .CurveLinear, animations: { () -> Void in
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == true {
            let viewController = UIImagePickerController()
            viewController.delegate = self
            viewController.sourceType = .Camera
            viewController.cameraFlashMode = .Off
            viewController.cameraDevice = .Rear
            viewController.popoverPresentationController?.sourceView = view
            presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
    func didSelectAlbumButton() {
        Analytics.sendEvent(category: "album", action: "open")
        
        let viewController = UIImagePickerController()
        viewController.delegate = self
        viewController.popoverPresentationController?.sourceView = view
        viewController.sourceType = .SavedPhotosAlbum
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        Analytics.sendEvent(category: "album", action: "cancel")
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        Analytics.sendEvent(category: "album", action: "done")
        
        if let scene = homeSceneView?.scene as? HomeScene {
            scene.resetImage()
        }
        if picker.sourceType == .Camera {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                picker.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        else {
            let assetURL = info[UIImagePickerControllerReferenceURL] as? NSURL
            if let assetURL = assetURL {
                let fetchOptions = PHFetchOptions()
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
                let result = PHAsset.fetchAssetsWithALAssetURLs([assetURL], options: fetchOptions)
                if let asset = result.firstObject as? PHAsset {
                    let options = PHImageRequestOptions()
                    options.networkAccessAllowed = true
                    options.deliveryMode = .HighQualityFormat
                    PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(200, 200), contentMode: .AspectFill, options: options) { (image, info) -> Void in
                        picker.dismissViewControllerAnimated(true, completion: {[weak self] () -> Void in
                            if let scene = self?.homeSceneView?.scene as? HomeScene {
                                if let squaredImage = image?.squaredImage() {
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                                        scene.setImage(squaredImage)
                                    }
                                }
                            }
                            })
                    }
                    
                    options.resizeMode = .None
                    PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSizeMake(CGFloat(asset.pixelWidth), CGFloat(asset.pixelHeight)), contentMode: .AspectFill, options: options) { (image, info) -> Void in
                        self.originalImage = image
                    }
                }
            }
        }
    }
    
    func postInstagram(#image: UIImage) {
        let instagramURL = NSURL(string: "instagram://app")
        if let instagramURL = instagramURL where UIApplication.sharedApplication().canOpenURL(instagramURL) {
            let imageData = UIImageJPEGRepresentation(image, 1)
            let filePath = NSTemporaryDirectory().stringByAppendingString("image.igo")
            var error: NSError?
            if imageData.writeToFile(filePath, options: .AtomicWrite, error: &error) == false {
                println("error")
                return
            }
            
            if let fileURL = NSURL(fileURLWithPath: filePath) {
                documentController = UIDocumentInteractionController(URL: fileURL)
                if let controller = documentController {
                    controller.delegate = self
                    controller.UTI = "com.instagram.exclusivegram"
                    controller.presentOpenInMenuFromRect(view.bounds, inView: view, animated: true)
                }
            }
        }
        else {
            let alertController = UIAlertController(title: "Needs Install \"Instagram\" to Share", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "AppStore", style: .Default, handler: { (action) -> Void in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                    if let label = self.instagramLabel {
                        UIView.animateWithDuration(0.2, animations: { () -> Void in
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
                
                if let url = NSURL(string: "https://itunes.apple.com/app/instagram/id389801252") where UIApplication.sharedApplication().canOpenURL(url) == true {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                if let label = self.instagramLabel {
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
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
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func documentInteractionController(controller: UIDocumentInteractionController, willBeginSendingToApplication application: String) {
        isDocumentControllerSelected = true
    }
    
    func documentInteractionControllerDidDismissOpenInMenu(controller: UIDocumentInteractionController) {
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
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            if let label = self.instagramLabel {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    label.alpha = 0
                }, completion: { (finishec) -> Void in
                    label.removeFromSuperview()
                    self.instagramLabel = nil
                })
            }
            if let scene = self.homeSceneView?.scene as? HomeScene {
                scene.reset()
            }
            
            if delay != 0 {
                self.doYouLikePicshot()
            }
        }
    }
    
    func doYouLikePicshot() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: "Do you like picshot?", message: nil, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Tell a Friend", style: .Default, handler: { (action) -> Void in
                if let url = NSURL(string: "https://itunes.apple.com/app/id\(AppId)") {
                    let viewController = UIActivityViewController(activityItems: [url, "I Like #picshot"], applicationActivities: nil)
                    viewController.popoverPresentationController?.sourceView = self.view
                    self.presentViewController(viewController, animated: true, completion: nil)
                }
            }))
            alertController.addAction(UIAlertAction(title: "Review on AppStore", style: .Default, handler: { (action) -> Void in
                if let url = ViewController.appStoreUrl(AppId) where UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }))
            alertController.addAction(UIAlertAction(title: "No, thanks", style: .Cancel, handler: nil))
            alertController.popoverPresentationController?.sourceView = self.view
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: App Store URL
    class func appStoreUrl(appId: String) -> NSURL? {
        var url: NSURL?
        let systemVersion = (UIDevice.currentDevice().systemVersion as NSString).doubleValue
        if systemVersion >= 7.1 {
            url = NSURL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + appId)
        }
        else if systemVersion >= 7.0 {
            url = NSURL(string: "itms-apps://itunes.apple.com/app/id" + appId)
        }
        else {
            url = NSURL(string: "itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=" + appId)
        }
        return url
    }
}


