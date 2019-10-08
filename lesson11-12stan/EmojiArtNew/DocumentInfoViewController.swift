//
//  DocumentInfoViewController.swift
//  EmojiArtV2
//
//  Created by Анастасия Распутняк on 05.10.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class DocumentInfoViewController: UIViewController {
    
    var document : EmojiArtDocument? {
        didSet {
            updateUI()
        }
    }
    
    private let shortDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var creationLabel: UILabel!
    @IBOutlet weak var topLevelView: UIStackView!
    @IBOutlet weak var returnButton: UIButton!
    
    @IBOutlet weak var thumbnailAspectRatio: NSLayoutConstraint!
    
    @IBAction func actionDone() {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let fittedSize = topLevelView?.sizeThatFits(UIView.layoutFittingCompressedSize) {
            preferredContentSize = CGSize(width: fittedSize.width + 30, height: fittedSize.height + 30)
        }
    }
    
    private func updateUI() {
        if sizeLabel != nil, creationLabel != nil,
        let url = document?.fileURL,
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) {
            sizeLabel.text = "\(attributes[.size] ?? 0) bytes"
            if let created = attributes[.creationDate] as? Date {
                creationLabel.text = shortDateFormatter.string(from: created)
            }
        }
        
        if thumbnailImageView != nil, thumbnailAspectRatio != nil, let thumbnail = document?.thumbnail {
            thumbnailImageView.image = thumbnail
            
            thumbnailImageView.removeConstraint(thumbnailAspectRatio)
            
            thumbnailAspectRatio = NSLayoutConstraint(
                item: thumbnailImageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: thumbnailImageView,
                attribute: .height,
                multiplier: thumbnail.size.width / thumbnail.size.height,
                constant: 0
            )
            
            thumbnailImageView.addConstraint(thumbnailAspectRatio)
        }
        
        if presentationController is UIPopoverPresentationController {
            thumbnailImageView?.isHidden = true
            returnButton?.isHidden = true
            view.backgroundColor = .clear
        }
    }
    
}
