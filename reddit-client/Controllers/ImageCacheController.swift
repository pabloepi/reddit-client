//
//  ImageCacheController.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/18/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

public enum ImageCacheControllerError: Error {
    case downloadError
    case invalidUrl
}

class ImageCacheController {

    static let shared = ImageCacheController()

    private let imageCache = NSCache<NSString, UIImage>()

    func downloadImage(stringUrl: String, completion: ((_ image: UIImage?, _ error: ImageCacheControllerError? ) -> Void)?) {
        guard let url = URL(string: stringUrl) else {
            completion?(nil, .invalidUrl)
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion?(cachedImage, nil)
        } else {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let sself = self else { return }
                var image: UIImage!
                do {
                    image = UIImage(data: try Data(contentsOf: url, options: .mappedIfSafe))
                    sself.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion?(image, nil)
                } catch {
                    completion?(nil, .downloadError)
                }
            }
        }
    }

}
