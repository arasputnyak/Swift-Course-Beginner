//
//  DocumentBrowserViewController.swift
//  EmojiArtV2
//
//  Created by Анастасия Распутняк on 04.10.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var template : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = false
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // to not allow users to create a new document on iPhone
        if UIDevice.current.userInterfaceIdiom == .pad {
            template = try? FileManager.default.url(
                for: .applicationDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Untitled.json")
            if template != nil {
                allowsDocumentCreation = FileManager.default.createFile(atPath: template!.path, contents: Data())
            }
        }
        
    }
    
    
    // MARK: - UIDocumentBrowserViewControllerDelegate -
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        importHandler(template, .copy)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentVC = storyBoard.instantiateViewController(withIdentifier: "DocumentVC")
        if let emojiArtVC = documentVC.contents as? EmojiArtViewController {
            emojiArtVC.document = EmojiArtDocument(fileURL : documentURL)
        }
        
        present(documentVC, animated: true)
    }
}

