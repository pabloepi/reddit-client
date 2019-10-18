//
//  PostCell.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    var didTapDismissPost: ((PostCell) -> Void)?

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var commentsLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var statusView: UIView!

    @objc class func rowHeight() -> CGFloat { return 156.0 }
    @objc class func defaultIdentifier() -> String { return String(describing: self) }

    var post: Post? {
        didSet {
            configureView()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }

    // MARK: Private Methods

    private func configureView() {
        if let post = post {
            titleLabel.text = post.title
            authorLabel.text = post.author
            commentsLabel.text = "\(post.numComments) comments"
            dateLabel.text = post.createdUtc.timeAgoDisplay()
            statusView.isHidden = post.read
            ImageCacheController.shared.downloadImage(stringUrl: post.thumbnail) { (image, error) in
                DispatchQueue.main.async { [weak self] in
                    guard error == nil else {
                        return
                    }
                    self?.thumbnailImageView.image = image
                }
            }
        }
    }

    @IBAction private func dismissPost(_ sender: Any) {
        didTapDismissPost?(self)
    }

}
