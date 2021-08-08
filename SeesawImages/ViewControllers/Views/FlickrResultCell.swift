//
//  FlickrResultCell.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

class FlickrResultCell: UICollectionViewCell {
    
    static let cellId = "FlickrResultCell"
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    var viewModel: FlickrImage? {
        didSet {
            updateContent()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func updateContent() {
        guard let viewModel = viewModel else { return}
        ImageDownloader.downloadImage(from: viewModel) { [weak self] image in
            self?.thumbnailImageView.image = image
            self?.titleLable.text = viewModel.title
        }
    }
}

