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
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeIU()
    }
    
    func initializeIU() {
        stickerEditingView.addCorner(cornerRadius: 20)
        backgroundView.addCorner(cornerRadius: 20)
        backgroundView.addDropShadow(color: .black, radius: 8, shadowOffset: .init(width: 0, height: 4), shadowOpacity: 0.4)
    }

}
