//
//  StickerViewController.swift
//  Stickies
//
//  Created by Moazzam Tahir on 30/01/2020.
//  Copyright © 2020 Moazzam Tahir. All rights reserved.
//

import UIKit

class StickerViewController: UIViewController {

    @IBOutlet var stickerEditingView: UIImageView!
    @IBOutlet var croppedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func initializeIU() {
        stickerEditingView.addCorner(cornerRadius: 20)
        
    }

}
