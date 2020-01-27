//
//  ViewController.swift
//  Stickies
//
//  Created by Moazzam Tahir on 26/01/2020.
//  Copyright © 2020 Moazzam Tahir. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- Outlet Connections
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var cameraShutterButton: UIButton!
    @IBOutlet var flipCamera: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUIView() //initializing the view
    }

    
    func initializeUIView() {
        
        //camera view UI modifications
        cameraView.backgroundColor = UIColor.init(named: "modifiedDarkYellow")
        
        //bottom view UI modifications
        bottomView.addCorner(cornerRadius: 20)
        bottomView.backgroundColor = UIColor.init(named: "modifiedGray")
        bottomView.addDropShadow(color: .black, radius: 6, shadowOffset: .init(width: 0, height: 8), shadowOpacity: 0.8)
    }

}

extension UIView {
    //to add drop down shadow to any specific view
    func addDropShadow(color: UIColor, radius: CGFloat, shadowOffset: CGSize, shadowOpacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
    }
    
    //to add the corner to any particular view
    func addCorner(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        //self.layer.cornerCurve
    }
}
