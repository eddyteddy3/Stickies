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

        initializeIU()
    }
    
    func initializeIU() {
        stickerEditingView.addCorner(cornerRadius: 20)
        stickerEditingView.addDropShadow(color: .black, radius: 10, shadowOffset: .init(width: 0, height: 10), shadowOpacity: 2)
    }

}
