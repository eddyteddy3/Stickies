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
    
    //initializing the uiView
    func initializeIU() {
        stickerEditingView.addCorner(cornerRadius: 20)
        backgroundView.addCorner(cornerRadius: 20)
        backgroundView.addDropShadow(color: .black, radius: 8, shadowOffset: .init(width: 0, height: 4), shadowOpacity: 0.4)
    }
    
    //adding gestures to the imageView for Drag and Pinch in & out
    func addGestures() {
        //adding pinch gesture to scale the image
        let pinchGesture = UIPinchGestureRecognizer.init()
        pinchGesture.addTarget(self, action: #selector(scaleImage(_:)))
        
        //adding pan gesture to drag the image
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragImage(_:)))
        
        croppedImage.addGestureRecognizer(pinchGesture)
        croppedImage.addGestureRecognizer(panGesture)
        croppedImage.isUserInteractionEnabled = true //enabling to make gesture functional
        
    }
    
    //function to drag the image from the recieving event
    @objc
    func dragImage(_ sender: UIPanGestureRecognizer) {
        print(sender.translation(in: backgroundView))
        let translation = sender.translation(in: self.backgroundView)
        croppedImage.center = CGPoint.init(x: croppedImage.center.x + translation.x, y: croppedImage.center.y + translation.y)
        sender.setTranslation(.zero, in: self.backgroundView)
    }
    
    //function to scale the image
    @objc
    func scaleImage(_ sender: UIPinchGestureRecognizer) {
        self.croppedImage.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale)
    }

}
