//
//  BaseViewController.swift
//  Iliad
//
//  Created by Luigi Aiello on 30/07/2019.
//  Copyright © 2019 Luigi Aiello. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Text Field Delegate
extension BaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField else {
            textField.resignFirstResponder()
            return true
        }
        
        nextField.becomeFirstResponder()
        
        return false
    }
}
