//
//  FlickrDetailViewController.swift
//  SeesawImages
//
//  Created by Larry Nguyen on 7/6/21.
//

import UIKit

class FlickrDetailViewController: UIViewController {
    
    var viewModel: FlickrImage?
    
    lazy var coverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        update()
    }
    
    // MARK: - Setup Views
    
    func setupConstraints() {
        view.addSubview(coverImageView)
        var constraints: [NSLayoutConstraint] = []
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[coverImageView]|", options: [], metrics: nil, views: ["coverImageView": coverImageView]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[coverImageView]|", options: [], metrics: nil, views: ["coverImageView": coverImageView]))
        NSLayoutConstraint.activate(constraints)
    }
    
    func update() {
        guard let viewModel = viewModel else { return}
        ImageDownloader.downloadImage(from: viewModel) { [weak self] image in
            self?.coverImageView.image = image
        }
    }
    
}

