//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Анастасия Распутняк on 13.09.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit
import  MobileCoreServices

class EmojiArtViewController: UIViewController {

    @IBOutlet weak var dropZone: UIView! {
        didSet {
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var embeddedDocInfoHeight: NSLayoutConstraint!
    @IBOutlet weak var embeddedDocInfoWidth: NSLayoutConstraint!
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.delegate = self
            emojiCollectionView.dataSource = self
            emojiCollectionView.dragDelegate = self
            emojiCollectionView.dropDelegate = self
            emojiCollectionView.dragInteractionEnabled = true
        }
    }
    @IBOutlet weak var cameraButton: UIBarButtonItem! {
        didSet {
            cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    }
    @IBAction func actionAddEmoji(_ sender: UIButton) {
        addingEmoji = true
        emojiCollectionView.reloadSections(IndexSet(integer: 0))
    }
    @IBAction func actionDone(_ sender: UIBarButtonItem? = nil) {
        if let observer = emojiArtViewObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        if document?.emojiArt != nil {
            document?.thumbnail = emojiArtView.snapshot
        }
        dismiss(animated: true) {
            self.document?.close() { success in
                if let observer = self.documentObserver {
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        }
    }
    @IBAction func takeBackgroundPhoto(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @IBAction func close(bySegue : UIStoryboardSegue) {
        actionDone()
    }
    
    var imageFetcher : ImageFetcher!
    var emojiArtView = EmojiArtView()
    private var _emojiArtBackgroundURL : URL?
    
    enum ImageSource {
        case remote(URL, UIImage)
        case local(Data, UIImage)
        
        var image : UIImage {
            switch self {
            case .remote(_, let image):
                return image
            case .local(_, let image):
                return image
            }
        }
    }
    
    var emojiArtBackgroundImage : ImageSource? {
        didSet {
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = emojiArtBackgroundImage?.image
            let size = emojiArtBackgroundImage?.image.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin: CGPoint.zero, size: size)
            scrollView.contentSize = size
            scrollViewHeight?.constant = size.height
            scrollViewWidth?.constant = size.width
            if let dropZone = self.dropZone, size.width > 0, size.height > 0 {
                scrollView.zoomScale = max(dropZone.bounds.size.width / size.width, dropZone.bounds.size.height / size.height)
            }
        }
    }
    
    var emojies = "🧚🏽‍♀️🧜🏽‍♀️🐙🦖🦕🐋🦅🦉🌝🌚☀️✈️⛵️🚗💗💖".map { String($0) }
    
    private var addingEmoji = false
    
    var emojiArt : EmojiArt? {
        get {
            if let imageSource = emojiArtBackgroundImage {
                let emojies = emojiArtView.subviews.compactMap { $0 as? UILabel }.compactMap { EmojiArt.EmojiInfo(label: $0) }
                switch imageSource {
                case .remote(let url, _):
                    return EmojiArt(url: url, emojies: emojies)
                case .local(let imageData, _):
                    return EmojiArt(imageData: imageData, emojies: emojies)
                }
            }
            return nil
        }
        
        set {
            emojiArtBackgroundImage = nil
            emojiArtView.subviews.compactMap { $0 as? UILabel }.forEach { $0.removeFromSuperview() }
            let imageData = newValue?.imageData
            let image = (imageData != nil) ? UIImage(data: imageData!) : nil
            if let url = newValue?.url {
                imageFetcher = ImageFetcher() { (url, image) in
                    DispatchQueue.main.async {
                        if image == self.imageFetcher.backup {
                            self.emojiArtBackgroundImage = .local(imageData!, image)
                        } else {
                            self.emojiArtBackgroundImage = .remote(url, image)
                        }
                        newValue?.emojies.forEach {
                            let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                            self.emojiArtView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                        }
                    }
                }
                imageFetcher.backup = image
                imageFetcher.fetch(url)
            } else if image != nil {
                emojiArtBackgroundImage = .local(imageData!, image!)
                newValue?.emojies.forEach {
                    let attributedText = $0.text.attributedString(withTextStyle: .body, ofSize: CGFloat($0.size))
                    self.emojiArtView.addLabel(with: attributedText, centeredAt: CGPoint(x: $0.x, y: $0.y))
                }
            }
        }
    }
    
    var document : EmojiArtDocument?
    
    private var suppressBadURLWarnings = false
    
    private var documentObserver : NSObjectProtocol?
    private var emojiArtViewObserver : NSObjectProtocol?
    
    private var embeddedDocInfo : DocumentInfoViewController?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if document?.documentState != .normal {
            documentObserver = NotificationCenter.default.addObserver(
                forName: UIDocument.stateChangedNotification,
                object: document,
                queue: OperationQueue.main,
                using: { notification in
                    print("Document state changed to \(self.document!.documentState)")
                    if self.document?.documentState == .normal, let docInfoVC = self.embeddedDocInfo {
                        docInfoVC.document = self.document
                        self.embeddedDocInfoWidth.constant = docInfoVC.preferredContentSize.width
                        self.embeddedDocInfoHeight.constant = docInfoVC.preferredContentSize.height
                    }
            })
            
            document?.open { success in
                if success {
                    self.title = self.document?.localizedName
                    self.emojiArt = self.document?.emojiArt
                    
                    self.emojiArtViewObserver = NotificationCenter.default.addObserver(
                        forName: .EmojiArtViewDidChange,
                        object: self.emojiArtView,
                        queue: OperationQueue.main,
                        using: { notification in
                            self.saveDocument()
                    })
                }
            }
        }
    }
    
    func saveDocument(_ sender: UIBarButtonItem? = nil) {
        document?.emojiArt = emojiArt
        if document?.emojiArt != nil {
            document?.updateChangeCount(.done)
        }
    }
    
    // MARK: - Navigation -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Document Info" {
            if let destination = segue.destination.contents as? DocumentInfoViewController {
                document?.thumbnail = emojiArtView.snapshot
                destination.document = document
                if let ppc = destination.popoverPresentationController {
                    ppc.delegate = self
                }
            }
        } else if segue.identifier == "Embed Document Segue" {
            embeddedDocInfo = segue.destination.contents as? DocumentInfoViewController
        }
    }

}


extension EmojiArtViewController : UIDropInteractionDelegate {
    
    private func presentBadURLWarning(for url : URL?) {
        
        if suppressBadURLWarnings {
            let alert = UIAlertController(
                title: "Image Transfer Failed",
                message: "Couldn't transfer the dropped image from its source.\nShow this warning in the future?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: "Keep Warning",
                style: .default
            ))
            
            alert.addAction(UIAlertAction(
                title: "Stop Warning",
                style: .destructive,
                handler: { action in
                    self.suppressBadURLWarnings = true
            }))
            
            present(alert, animated: true)
        }
        
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                
                if image == self.imageFetcher.backup {
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        self.emojiArtBackgroundImage = .local(imageData, image)
                        self.actionDone()
                    } else {
                        self.presentBadURLWarning(for: url)
                    }
                } else {
                    self.emojiArtBackgroundImage = .remote(url, image)
                    self.actionDone()
                }
            }
        }
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in // type = NSItemProviders
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in // type = NSItemProviders
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        }
    }
    
}


extension EmojiArtViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight.constant = scrollView.contentSize.height
        scrollViewWidth.constant = scrollView.contentSize.width
    }
    
}


extension EmojiArtViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var font : UIFont {
        return UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.preferredFont(forTextStyle: .body).withSize(64))
    }
    
    // MARK: - UICollectionViewDataSource -
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return emojies.count
        switch section {
        case 0:
            return 1
        case 1:
            return emojies.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath)
            
            if let emojiCell = cell as? EmojiCollectionViewCell {
                let text = NSAttributedString(string: emojies[indexPath.item], attributes: [.font : font])
                emojiCell.emojiLabel.attributedText = text
            }
            
            return cell
        } else if addingEmoji {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiInputCell", for: indexPath)
            
            if let inputCell = cell as? TextFieldCollectionViewCell {
                inputCell.resignationHandler = { [weak self, unowned inputCell] in
                    if let text = inputCell.textField.text {
                        self?.emojies = (text.map({ String($0) }) + self!.emojies).uniquified
                    }
                    self?.addingEmoji = false
                    self?.emojiCollectionView.reloadData()  // reload textfield to "+" also!!
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addEmojiCell", for: indexPath)
            return cell
        }
        
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout -
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if addingEmoji && indexPath.section == 0 {
            return CGSize(width: 300, height: 80)
        } else {
            return CGSize(width: 80, height: 80)
        }
    }
    
    // MARK: - UICollectionViewDelegate -
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let inputCell = cell as? TextFieldCollectionViewCell {
            inputCell.textField.becomeFirstResponder()
        }
    }
    
}


extension EmojiArtViewController : UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    private func dragItems(at indexPath : IndexPath) -> [UIDragItem] {
        if !addingEmoji, let attributedString = (emojiCollectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.emojiLabel.attributedText {
            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: attributedString))
            dragItem.localObject = attributedString
            return [dragItem]
        } else {
            return []
        }
    }
    
    // MARK: - UICollectionViewDragDelegate -
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }
    
    // MARK: - UICollectionViewDropDelegate -
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if let indexPath = destinationIndexPath, indexPath.section == 1 {
            let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
            return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        
        for item in coordinator.items {
            if let sourceIndexPath = item.sourceIndexPath {
                if let attributedString = item.dragItem.localObject as? NSAttributedString {
                    
                    collectionView.performBatchUpdates({
                        // do updates as ONE operation
                        emojies.remove(at: sourceIndexPath.item)
                        emojies.insert(attributedString.string, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }, completion: nil)
                    
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            } else {
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "dropPlaceholderCell"))
                item.dragItem.itemProvider.loadObject(ofClass: NSAttributedString.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let attributedString = provider as? NSAttributedString {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.emojies.insert(attributedString.string, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
}


extension EmojiArt.EmojiInfo {
    init?(label : UILabel) {
        if let attributedText = label.attributedText, let font = attributedText.font {
            x = Int(label.center.x)
            y = Int(label.center.y)
            text = attributedText.string
            size = Int(font.pointSize)
        } else {
            return nil
        }
    }
}


extension EmojiArtViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}


extension EmojiArtViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = ((info[UIImagePickerController.InfoKey.editedImage] ?? info[UIImagePickerController.InfoKey.originalImage]) as? UIImage)?.scaled(by: 0.25) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                emojiArtBackgroundImage = .local(imageData, image)
                actionDone()
            } else {
                #warning("Alert user of bad camera input")
            }
        }
        
        picker.presentingViewController?.dismiss(animated: true)
    }
}
