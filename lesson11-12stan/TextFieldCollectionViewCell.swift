//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Анастасия Распутняк on 02.10.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell {
    
    var resignationHandler : (() -> Void)?
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
}


extension TextFieldCollectionViewCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
}
