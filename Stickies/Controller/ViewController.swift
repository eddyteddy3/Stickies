//
//  ViewController.swift
//  Stickies
//
//  Created by Moazzam Tahir on 26/01/2020.
//  Copyright © 2020 Moazzam Tahir. All rights reserved.
//

import UIKit
import LiveValues
import PixelKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK:- Outlet Connections
    @IBOutlet var bottomView: UIView!
    @IBOutlet var cameraView: UIView!
    @IBOutlet var cameraShutterButton: UIButton!
    @IBOutlet var flipCamera: UIButton!
    
    //common variables
    let model = DeepLabV3()
    let picker = UIImagePickerController()
    var pickedImage = UIImage()
    var croppedImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        //functions to call
        initializeUIView() //initializing the view
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flipCamera.addSoftUIEffectForButton(cornerRadius: 10, themeColor: UIColor.init(named: "white")!)
        cameraShutterButton.addSoftUIEffectForButton(cornerRadius: 14, themeColor: UIColor.init(named: "white")!)
    }
    
    //initializing during the launch
    func initializeUIView() {
        
        //camera view UI modifications
        cameraView.backgroundColor = UIColor.init(named: "modifiedDarkYellow")
        
        //bottom view UI modifications
        bottomView.addCorner(cornerRadius: 20)
        bottomView.backgroundColor = UIColor.init(named: "white")
        bottomView.addDropShadow(color: .black, radius: 6, shadowOffset: .init(width: 0, height: 8), shadowOpacity: 3)
        
    }
    
    @IBAction func cameraShutter(_ sender: Any) {
        self.present(self.picker, animated: true)
    }
    
    @IBAction func flipCamera(_ sender: Any) {
    }
    
    //present the view with full screen to sticker view controller
    func pushToStickerVC(image: UIImage) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "Sticker") as! StickerViewController
        storyboard.modalPresentationStyle = .fullScreen
        self.present(storyboard, animated: true, completion: nil)
        storyboard.croppedImage.image = image
    }
    
    func addBorder(image: UIImage) {
        let imagePix = ImagePIX()
        imagePix.image = image
        
        let background = ColorPIX.init(at: .fullscreen)
        background.color = .clear
        
        let imageOverBackground: BlendPIX = background & imagePix
        
        let mask: ReorderPIX = ReorderPIX()
        mask.inputA = imageOverBackground
        mask.inputB = imageOverBackground
        mask.redChannel = .alpha
        mask.greenChannel = .alpha
        mask.blueChannel = .alpha
        mask.alphaChannel = .one
        
        let expandMask = mask._blur(0.1)._threshold(0.1)
        
        let borderColor: LiveColor = .red
        
        let colorEdge = expandMask._lumaToAlpha() * borderColor
        
        let final: PIX = colorEdge & imagePix
        let ciImage = final.renderedCIImage!
        let finalImage = UIImage.init(ciImage: ciImage)
            //pushToStickerVC(image: final)
        print(finalImage.size)
        
        //final.view.frame = view.bounds
        //view.addSubview(final.view)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //function to select the photoes from gallery.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let possibleImage = info[.originalImage] as? UIImage {
            self.pickedImage = possibleImage
        } else if let possibleImage = info[.editedImage] as? UIImage {
            self.pickedImage = possibleImage
        } else {
            print("Failed to pick the image from gallery.")
            return
        }
        
        dismiss(animated: true) {
            print(self.pickedImage.size)
            self.removeBackground(image: self.pickedImage)
            print(self.croppedImage.size)
            //self.pushToStickerVC()
            self.addBorder(image: self.croppedImage)
        }
    }
}

extension ViewController {
    func removeBackground(image: UIImage) {
        let resizedImage = image.resized(to: CGSize(width: 513, height: 513))
        if let pixelBuffer = resizedImage.pixelBuffer(width: Int(resizedImage.size.width), height: Int(resizedImage.size.height)) {
            if let outputImage = (try? model.prediction(image: pixelBuffer))?.semanticPredictions.image(min: 0, max: 1, axes: (0,0,1)), let outputCIImage = CIImage(image: outputImage) {
                if let maskImage = removeWhitePixels(image: outputCIImage), let resizedCIImage = CIImage(image: resizedImage), let compositeImage = composite(image: resizedCIImage, mask: maskImage) {
                    let croppedImage = UIImage(ciImage: compositeImage).resized(to: CGSize(width: image.size.width, height: image.size.height))
                    self.croppedImage = croppedImage
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
