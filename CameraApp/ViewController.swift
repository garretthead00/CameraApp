//
//  ViewController.swift
//  CameraApp
//
//  Created by Garrett Head on 1/25/19.
//  Copyright © 2019 Garrett Head. All rights reserved.
//

import UIKit
import AVFoundation
//import ImagePicker

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
private var videoUrl : URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func libraryButton_TouchUpInside(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func photoButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    @IBAction func videoButton_TouchUpInside(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.mediaTypes = ["public.movie"]
            imagePickerController.cameraCaptureMode = .video
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//        imageView.image = image
//        picker.dismiss(animated: true, completion: nil)
        
        
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        // fires after an image has been selected from the Image Picker
        
        if let videoUrl = info["UIImagePickerControllerMediaURL"] as? URL {
            if let thumbnail = self.generateVideoThumbnail(videoUrl) {
                imageView.image = thumbnail
                self.videoUrl = videoUrl
            }
            dismiss(animated: true, completion: nil)
        }
        
        if let selectedProfileImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = selectedProfileImage
            picker.dismiss(animated: true, completion: nil)
//            dismiss(animated: true, completion: {
//                self.performSegue(withIdentifier: "Filter", sender: nil)
//            })
        }
    }
    
    private func generateVideoThumbnail(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 6, timescale: 3), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        return nil
    }
        
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}


