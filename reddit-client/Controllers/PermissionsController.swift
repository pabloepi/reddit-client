//
//  PermissionsController.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/18/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit
import Photos

class PermissionsController: NSObject {

    public typealias PermissionsBlock = () -> Void

    static var statusPhotos: PHAuthorizationStatus {
        get { return PHPhotoLibrary.authorizationStatus() }
    }

    class func requestPhotosAuthorization(_ success: PermissionsBlock?, failure: PermissionsBlock?, denied: PermissionsBlock?) {
        switch statusPhotos {
        case .authorized: success?()
        case .denied: failure?()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    DispatchQueue.main.async(execute: { success?() })
                } else {
                    denied?()
                }
            })
        case .restricted: failure?()
        @unknown default: failure?()
        }
    }

}
