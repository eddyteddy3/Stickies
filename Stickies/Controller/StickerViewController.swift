//
//  StickerViewController.swift
//  Stickies
//
//  Created by Moazzam Tahir on 30/01/2020.
//  Copyright © 2020 Moazzam Tahir. All rights reserved.
//

import UIKit

class StickerViewController: UIViewController, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate {

    //MARK:- IBOutlet Connections
    @IBOutlet var stickerEditingView: UIImageView!
    @IBOutlet var croppedImage: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var addBorderButton: UIButton!
    @IBOutlet var addTextButton: UIButton!
    @IBOutlet var saveImageButton: UIButton!
    
    //MARK:- Common Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        
        addBorderButton.addSoftUIEffectForButton()
    }
    
    //adding gestures to the imageView for Drag and Pinch in & out
    func addGestures() {
        //adding pinch gesture to scale the image
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(scaleImage(_:)))
        pinchGesture.delegate = self
        
        //adding pan gesture to drag the image
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(dragImage(_:)))
        panGesture.delegate = self
        
        //adding rotationGesture to rotate the image
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(rotateImage(_:)))
        rotateGesture.delegate = self
        
        //adding gestures to image that has been cropped
        croppedImage.addGestureRecognizer(pinchGesture)
        croppedImage.addGestureRecognizer(panGesture)
        croppedImage.addGestureRecognizer(rotateGesture)
        
        croppedImage.isUserInteractionEnabled = true //enabling to make gesture functional
        croppedImage.isMultipleTouchEnabled = true //to rotate the image
    }
    
    //function to drag the image from the recieving event
    @objc
    func dragImage(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.backgroundView)
        croppedImage.center = CGPoint.init(x: croppedImage.center.x + translation.x, y: croppedImage.center.y + translation.y)
        sender.setTranslation(.zero, in: self.backgroundView)
    }
    
    //function to scale the image
    @objc
    func scaleImage(_ sender: UIPinchGestureRecognizer) {
        self.croppedImage.transform = CGAffineTransform.init(scaleX: sender.scale, y: sender.scale)
    }
    
    //function to rotate the image
    @objc
    func rotateImage(_ sender: UIRotationGestureRecognizer) {
        //print(sender.rotation)
        //self.croppedImage.transform = croppedImage.transform.rotated(by: sender.rotation)
        
        if sender.state == .ended || sender.state == .changed {
            sender.view?.transform = sender.view!.transform.rotated(by: sender.rotation)
            //sender.rotation = 0
        } else {
            //sender.rotation = 0
        }
    }
    
    
    
    //to enable all gestures work simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    //MARK:- IBActions
    
    //funciton to addText in Canvas View
    @IBAction func addText(_ sender: Any) {
    }
    
    //function to add border to an image
    @IBAction func addBorder(_ sender: Any) {
        croppedImage.layer.borderWidth = 2
        croppedImage.layer.borderColor = UIColor.black.cgColor
    }
    
    //function to save the image
    @IBAction func saveImage(_ sender: Any) {
        guard let image = croppedImage.image else {return}
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("ERROR SAVING Image")
        } else {
            print("Successfully saved the image")
        }
    }
}
