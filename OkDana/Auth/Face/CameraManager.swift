//
//  CameraManager.swift
//  OkDana
//
//  Created by Scott Reed on 2025/12/15.
//

import UIKit
import AVFoundation
import Photos

class CameraManager: NSObject {
    
    static let shared = CameraManager()
    private override init() {}
    
    typealias CaptureCompletion = (UIImage?) -> Void
    typealias PermissionCompletion = (Bool) -> Void
    
    private var captureCompletion: CaptureCompletion?
    private var imagePicker: UIImagePickerController?
    private var targetSizeKB: Int = 700
    
    func takePhoto(with type: String, completion: @escaping CaptureCompletion) {
        self.captureCompletion = completion
        
        checkCameraPermission { [weak self] granted in
            guard let self = self else { return }
            
            if granted {
                DispatchQueue.main.async {
                    self.openCamera(with: type)
                }
            } else {
                DispatchQueue.main.async {
                    self.showPermissionAlert()
                }
            }
        }
    }
    
    private func checkCameraPermission(completion: @escaping PermissionCompletion) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            completion(true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
            
        case .denied, .restricted:
            completion(false)
            
        @unknown default:
            completion(false)
        }
    }
    
    private func openCamera(with type: String) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "提示", message: "您的设备不支持相机功能")
            return
        }
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .camera
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = false
        imagePicker?.cameraDevice = type == "1" ? .rear : .front
        if let picker = imagePicker {
            getTopViewController()?.present(picker, animated: true)
        }
    }
    
    private func showPermissionAlert() {
        let alert = UIAlertController(
            title: LanguageManager.localizedString(for: "Permission Required"),
            message: LanguageManager.localizedString(for: "Camera permission is disabled. Please enable it in Settings to allow your loan application to be processed."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: LanguageManager.localizedString(for: "Cancel"), style: .default) { _ in
            self.captureCompletion?(nil)
        }
        
        let settingsAction = UIAlertAction(title: LanguageManager.localizedString(for: "Go to Settings"), style: .cancel) { _ in
            self.openAppSettings()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        
        getTopViewController()?.present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "确定", style: .default)
        alert.addAction(okAction)
        
        getTopViewController()?.present(alert, animated: true)
    }
    
    private func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(settingsURL) else {
            return
        }
        
        UIApplication.shared.open(settingsURL)
    }
    
    private func compressImage(_ image: UIImage, targetKB: Int) -> Data? {
        var compression: CGFloat = 1.0
        let maxCompression: CGFloat = 0.1
        let minFileSize = targetKB * 1024
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        if imageData.count <= minFileSize {
            return imageData
        }
        
        while imageData.count > minFileSize && compression > maxCompression {
            compression -= 0.1
            if let data = image.jpegData(compressionQuality: compression) {
                imageData = data
            }
        }
        
        if imageData.count > minFileSize {
            return compressByResizing(image, targetKB: targetKB)
        }
        
        return imageData
    }
    
    private func compressByResizing(_ image: UIImage, targetKB: Int) -> Data? {
        let originalSize = image.size
        let targetSize = CGSize(
            width: originalSize.width * 0.7,
            height: originalSize.height * 0.7
        )
        
        UIGraphicsBeginImageContext(targetSize)
        image.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let compressedImage = resizedImage else { return nil }
        
        return compressImage(compressedImage, targetKB: targetKB)
    }
    
    private func getTopViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topController = window.rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension CameraManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true) {
            guard let originalImage = info[.originalImage] as? UIImage else {
                self.captureCompletion?(nil)
                return
            }
            
            if let compressedData = self.compressImage(originalImage, targetKB: self.targetSizeKB),
               let compressedImage = UIImage(data: compressedData) {
                
                let fileSizeKB = Double(compressedData.count) / 1024.0
                
                self.captureCompletion?(compressedImage)
            } else {
                self.captureCompletion?(originalImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.captureCompletion?(nil)
        }
    }
}
