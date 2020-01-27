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
    
    //common variables
    let model = DeepLabV3()
    
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
    
    @IBAction func cameraShutter(_ sender: Any) {
    }
    
    @IBAction func flipCamera(_ sender: Any) {
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

extension ViewController {
    func removeBackground(image: UIImage) {
        let resizedImage = image.resized(to: CGSize(width: 513, height: 513))
        if let pixelBuffer = resizedImage.pixelBuffer(width: Int(resizedImage.size.width), height: Int(resizedImage.size.height)) {
            if let outputImage = (try? model.prediction(image: pixelBuffer))?.semanticPredictions.image(min: 0, max: 1, axes: (0,0,1)), let outputCIImage = CIImage(image: outputImage) {
                if let maskImage = removeWhitePixels(image: outputCIImage), let resizedCIImage = CIImage(image: resizedImage), let compositeImage = composite(image: resizedCIImage, mask: maskImage) {
                    let image = UIImage(ciImage: compositeImage).resized(to: CGSize(width: image.size.width, height: image.size.height))
                    DispatchQueue.main.async {
                        //self.outputView.isHidden = false
                        //self.imageView!.image = image
                        //imageView?.image?.rotate(radians: )
                        //imageView?.image?.imageOrientation = .up
                    }
                }
            }
        }
    }
    
    func removeWhitePixels(image: CIImage) -> CIImage? {
        let chromaCIFilter = chromaKeyFilter()
        chromaCIFilter?.setValue(image, forKey: kCIInputImageKey)
        return chromaCIFilter?.outputImage
    }
    func composite(image: CIImage, mask: CIImage) -> CIImage? {
        return CIFilter(name:"CISourceOutCompositing",parameters:
            [kCIInputImageKey: image,kCIInputBackgroundImageKey: mask])?.outputImage
    }
    func chromaKeyFilter() -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()
        
        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)
                    let brightness = getBrightness(red: red, green: green, blue: blue)
                    let alpha: CGFloat = brightness == 1 ? 0 : 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))
        
        let colorCubeFilter = CIFilter(name: "CIColorCube", parameters: ["inputCubeDimension": size, "inputCubeData": data])
        return colorCubeFilter
    }
    func getBrightness(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat? {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var brightness: CGFloat = 0
        color.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return brightness
    }
}
