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

        
        //functions to call
        //initializeIU()
        addGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeIU()
    }
    
    //adding gestures to the imageView for Drag and Pinch in & out
    func addGestures() {
        let pinchGesture = UIPinchGestureRecognizer.init()
        pinchGesture.addTarget(self, action: #selector(scaleImage(_:)))
        croppedImage.addGestureRecognizer(pinchGesture)
        croppedImage.isUserInteractionEnabled = true //enabling to make gesture functional
    }
    
    @objc
    func scaleImage(_ sender: UIPinchGestureRecognizer) {
        self.croppedImage.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale)
    }
    
    //initializing the uiView
    func initializeIU() {
        stickerEditingView.addCorner(cornerRadius: 20)
        backgroundView.addCorner(cornerRadius: 20)
        backgroundView.addDropShadow(color: .black, radius: 8, shadowOffset: .init(width: 0, height: 4), shadowOpacity: 0.4)
    }

}
