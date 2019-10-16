//
//  PostCell.swift
//  reddit-client
//
//  Created by Pablo Epíscopo on 10/16/19.
//  Copyright © 2019 Pablo Epíscopo. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @objc class func rowHeight() -> CGFloat { return 156.0 }
    @objc class func defaultIdentifier() -> String { return String(describing: self) }

    var post: Post? {
        didSet {
            configureView()
        }
    }

    private func configureView() {
        if let post = post {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
