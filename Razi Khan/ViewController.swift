//
//  ViewController.swift
//  Razi Khan
//
//  Created by Razi Khan on 15/03/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension UIViewController {
    
    //MARK:- convertToArray Function
    func convertToArray(text: String) -> Any? {
        if let data = text.data(using: .utf8) {
            do {return try JSONSerialization.jsonObject(with: data, options: [])}
            catch {print(error.localizedDescription)}
        }
        return nil
    }
}
