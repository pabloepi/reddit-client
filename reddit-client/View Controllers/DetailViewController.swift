//
//  DetailViewController.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    @objc class func defaultIdentifier() -> String { return String(describing: self) }

    private lazy var gesture: UITapGestureRecognizer! = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(saveImageAction(_:)))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        return gesture
    }()

    var post: Post? {
        didSet {
            if UI_USER_INTERFACE_IDIOM() == .pad {
                configureView()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initGUI()
    }

    // MARK: Private Methods

    private func initGUI() {
        configureView()
        thumbnailImageView.addGestureRecognizer(gesture)
    }

    private func configureView() {
        if let post = post {
            titleLabel.text = post.title
            authorLabel.text = post.author
            ImageCacheController.shared.downloadImage(stringUrl: post.url) { (image, error) in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil else {
                        return
                    }
                    self?.thumbnailImageView.image = image
                }
            }
        }
    }

    @objc private func saveImageAction(_ gesture: UITapGestureRecognizer) {
        guard let post = post else {
            return
        }
        PermissionsController.requestPhotosAuthorization({
            ImageCacheController.shared.downloadImage(stringUrl: post.url) { (image, error) in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil, image != nil else {
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
                }
            }
        }, failure: { [weak self] in
            let alert = UIAlertController.blockedFeatureAlert(NSLocalizedString("photos", comment: ""))
            self?.present(alert, animated: true, completion: nil)
        }, denied: nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        guard error == nil else {
            let alert = UIAlertController.alert(NSLocalizedString("Save error", comment: ""), nil, NSLocalizedString("OK", comment: ""), nil)
            present(alert, animated: true)
            return
        }
        let alert = UIAlertController.alert(NSLocalizedString("Saved!", comment: ""), nil, NSLocalizedString("OK", comment: ""), nil)
        present(alert, animated: true)
    }

}

