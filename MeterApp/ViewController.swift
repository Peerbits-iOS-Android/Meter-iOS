//
//  ViewController.swift
//  MeterApp
//
//  Created by Pathan Mushrankhan on 14/08/20.
//  Copyright © 2020 Khan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var viewMainMeterView : UIView!
    
    @IBOutlet weak var viewBackGradient : UIView!
    @IBOutlet weak var viewMeterLightTransparent    : UIView!
    @IBOutlet weak var viewMeter        : UIView!
    @IBOutlet weak var imgViewArrow     : UIImageView!
    @IBOutlet weak var lblCurrentValue  : UILabel!
    @IBOutlet weak var slider           : UISlider!
    
    let maxValue = 3200
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewMainMeterView.backgroundColor = .clear
        self.viewMeterLightTransparent.backgroundColor = .clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let gradient: CAGradientLayer = CAGradientLayer()

        let c1 = #colorLiteral(red: 1, green: 0.6274509804, blue: 0, alpha: 1)
        let c2 = #colorLiteral(red: 1, green: 0.4156862745, blue: 0, alpha: 1)
        gradient.colors = [c1.cgColor, c2.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.viewBackGradient.frame.size.width, height: self.viewBackGradient.frame.size.height)

        self.viewBackGradient.layer.insertSublayer(gradient, at: 0)
        
        let layer:CAShapeLayer = CAShapeLayer()
        let mainPath = getMeterGraphPath()
        layer.path = resizepath(Fitin: self.viewMeterLightTransparent.frame, path: mainPath)
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.white.cgColor
        layer.fillRule = .evenOdd
        self.viewMeter.layer.addSublayer(layer)
        
        setupBackTransparentMeterPath()
        
        let APPLY_THIS_VALUE : Float = 75 //75 percentage
        
        self.slider.value = APPLY_THIS_VALUE
        self.assignMeterValue(value0to100: APPLY_THIS_VALUE)
        
    }
    
     func setupBackTransparentMeterPath() {
         let layer:CAShapeLayer = CAShapeLayer()
         let mainPath = getMeterGraphPath()
        layer.path = resizepath(Fitin: self.viewMeterLightTransparent.frame, path: mainPath)
         layer.strokeColor = UIColor.clear.cgColor
         layer.fillColor = UIColor.white.withAlphaComponent(0.4).cgColor
         layer.fillRule = .evenOdd
        self.viewMeterLightTransparent.layer.addSublayer(layer)
     }
    
    
    
 
    func assignMeterValue(value0to100:Float) {
        
        let value = Float(value0to100)/Float(100)*Float(180)
        imgViewArrow.layer.anchorPoint = .init(x: 0.5, y: 0.88)
        imgViewArrow.transform = CGAffineTransform.init(rotationAngle: -CGFloat(90-value) * CGFloat.pi/180)
        
        let layer2:CAShapeLayer = CAShapeLayer()
        let color2 = UIColor(red: 0.296, green: 0.341, blue: 0.916, alpha: 1.000)
        
        let ovalRect = CGRect(x: 0, y: 0, width: self.viewMeterLightTransparent.frame.width, height: self.viewMeterLightTransparent.frame.height)
        let ovalPath = UIBezierPath()
        ovalPath.addArc(withCenter: CGPoint(x: ovalRect.midX, y: ovalRect.maxY), radius: ovalRect.width / 2, startAngle: -180 * CGFloat.pi/180, endAngle: -CGFloat(180-(value)) * CGFloat.pi/180, clockwise: true)
        ovalPath.addLine(to: CGPoint(x: ovalRect.midX, y: ovalRect.maxY))
        ovalPath.close()
        
        color2.setFill()
        ovalPath.fill()
        
        let mainPath2 = ovalPath.cgPath
        layer2.path = mainPath2//resizepath(Fitin: viewMeter.frame, path: mainPath2)
        layer2.fillColor = UIColor.white.cgColor
        viewMeter.layer.mask = layer2
        
        let finalResultValue = slider.value/slider.maximumValue*Float.init(self.maxValue)
        self.lblCurrentValue.text = "\(Int(finalResultValue))"
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        
        let slider = (sender as! UISlider)
        self.assignMeterValue(value0to100: slider.value)
    }

}




func resizepath(Fitin frame : CGRect , path : CGPath) -> CGPath{
    
    
    let boundingBox = path.boundingBox
    let boundingBoxAspectRatio = boundingBox.width / boundingBox.height
    let viewAspectRatio = frame.width  / frame.height
    var scaleFactor : CGFloat = 1.0
    if (boundingBoxAspectRatio > viewAspectRatio) {
        // Width is limiting factor
        
        scaleFactor = frame.width / boundingBox.width
    } else {
        // Height is limiting factor
        scaleFactor = frame.height / boundingBox.height
    }
    
    
    var scaleTransform = CGAffineTransform.identity
    scaleTransform = scaleTransform.scaledBy(x: scaleFactor, y: scaleFactor)
    scaleTransform.translatedBy(x: -boundingBox.minX, y: -boundingBox.minY)
    
    let scaledSize = boundingBox.size.applying(CGAffineTransform (scaleX: scaleFactor, y: scaleFactor))
    let centerOffset = CGSize(width: (frame.width - scaledSize.width ) / scaleFactor * 2.0, height: (frame.height - scaledSize.height) /  scaleFactor * 2.0 )
    scaleTransform = scaleTransform.translatedBy(x: centerOffset.width, y: centerOffset.height)
    let  scaledPath = path.copy(using: &scaleTransform)
    
    
    return scaledPath!
}


func getMeterGraphPath() -> CGPath {
    
    //// Bezier 2 Drawing
    let bezier2Path = UIBezierPath()
    bezier2Path.move(to: CGPoint(x: 284.07, y: 11.4))
    bezier2Path.addCurve(to: CGPoint(x: 266.54, y: 57.21), controlPoint1: CGPoint(x: 278.6, y: 25.69), controlPoint2: CGPoint(x: 272.64, y: 41.26))
    bezier2Path.addCurve(to: CGPoint(x: 213.64, y: 43.56), controlPoint1: CGPoint(x: 250.01, y: 50.15), controlPoint2: CGPoint(x: 232.23, y: 45.46))
    bezier2Path.addCurve(to: CGPoint(x: 213.64, y: 9.61), controlPoint1: CGPoint(x: 213.64, y: 31.91), controlPoint2: CGPoint(x: 213.64, y: 20.49))
    bezier2Path.addCurve(to: CGPoint(x: 213.64, y: 0), controlPoint1: CGPoint(x: 213.64, y: 6.35), controlPoint2: CGPoint(x: 213.64, y: 3.15))
    bezier2Path.addCurve(to: CGPoint(x: 214.98, y: 0), controlPoint1: CGPoint(x: 214.09, y: 0), controlPoint2: CGPoint(x: 214.53, y: 0))
    bezier2Path.addCurve(to: CGPoint(x: 284.07, y: 11.4), controlPoint1: CGPoint(x: 239.15, y: 0), controlPoint2: CGPoint(x: 262.39, y: 4.01))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 206.84, y: 9.3))
    bezier2Path.addCurve(to: CGPoint(x: 206.84, y: 42.99), controlPoint1: CGPoint(x: 206.84, y: 20.1), controlPoint2: CGPoint(x: 206.84, y: 31.43))
    bezier2Path.addCurve(to: CGPoint(x: 194.78, y: 42.6), controlPoint1: CGPoint(x: 202.85, y: 42.73), controlPoint2: CGPoint(x: 198.84, y: 42.6))
    bezier2Path.addCurve(to: CGPoint(x: 156.43, y: 46.63), controlPoint1: CGPoint(x: 181.63, y: 42.6), controlPoint2: CGPoint(x: 168.8, y: 43.99))
    bezier2Path.addCurve(to: CGPoint(x: 151.28, y: 31.64), controlPoint1: CGPoint(x: 154.69, y: 41.57), controlPoint2: CGPoint(x: 152.97, y: 36.57))
    bezier2Path.addCurve(to: CGPoint(x: 144.5, y: 11.88), controlPoint1: CGPoint(x: 148.96, y: 24.87), controlPoint2: CGPoint(x: 146.69, y: 18.26))
    bezier2Path.addCurve(to: CGPoint(x: 159.77, y: 7.19), controlPoint1: CGPoint(x: 149.51, y: 10.13), controlPoint2: CGPoint(x: 154.6, y: 8.57))
    bezier2Path.addCurve(to: CGPoint(x: 191.18, y: 1.31), controlPoint1: CGPoint(x: 169.96, y: 4.48), controlPoint2: CGPoint(x: 180.45, y: 2.5))
    bezier2Path.addCurve(to: CGPoint(x: 206.84, y: 0.15), controlPoint1: CGPoint(x: 196.34, y: 0.74), controlPoint2: CGPoint(x: 201.57, y: 0.35))
    bezier2Path.addCurve(to: CGPoint(x: 206.84, y: 9.3), controlPoint1: CGPoint(x: 206.84, y: 3.15), controlPoint2: CGPoint(x: 206.84, y: 6.21))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 362.86, y: 59.23))
    bezier2Path.addCurve(to: CGPoint(x: 324.48, y: 96.42), controlPoint1: CGPoint(x: 350.96, y: 70.76), controlPoint2: CGPoint(x: 337.87, y: 83.45))
    bezier2Path.addCurve(to: CGPoint(x: 272.76, y: 60), controlPoint1: CGPoint(x: 309.54, y: 81.48), controlPoint2: CGPoint(x: 292.07, y: 69.1))
    bezier2Path.addCurve(to: CGPoint(x: 290.47, y: 13.69), controlPoint1: CGPoint(x: 278.92, y: 43.88), controlPoint2: CGPoint(x: 284.95, y: 28.13))
    bezier2Path.addCurve(to: CGPoint(x: 362.86, y: 59.23), controlPoint1: CGPoint(x: 317.64, y: 23.93), controlPoint2: CGPoint(x: 342.19, y: 39.54))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 143.54, y: 30.03))
    bezier2Path.addCurve(to: CGPoint(x: 149.77, y: 48.18), controlPoint1: CGPoint(x: 145.58, y: 35.96), controlPoint2: CGPoint(x: 147.66, y: 42.03))
    bezier2Path.addCurve(to: CGPoint(x: 111.19, y: 62.77), controlPoint1: CGPoint(x: 136.25, y: 51.6), controlPoint2: CGPoint(x: 123.33, y: 56.52))
    bezier2Path.addCurve(to: CGPoint(x: 107.07, y: 64.95), controlPoint1: CGPoint(x: 109.81, y: 63.48), controlPoint2: CGPoint(x: 108.43, y: 64.21))
    bezier2Path.addCurve(to: CGPoint(x: 82.19, y: 81.31), controlPoint1: CGPoint(x: 98.32, y: 69.74), controlPoint2: CGPoint(x: 90, y: 75.21))
    bezier2Path.addCurve(to: CGPoint(x: 63.59, y: 62.65), controlPoint1: CGPoint(x: 75.79, y: 74.89), controlPoint2: CGPoint(x: 69.56, y: 68.64))
    bezier2Path.addCurve(to: CGPoint(x: 81.92, y: 46.35), controlPoint1: CGPoint(x: 69.39, y: 56.88), controlPoint2: CGPoint(x: 75.51, y: 51.43))
    bezier2Path.addCurve(to: CGPoint(x: 85.53, y: 43.55), controlPoint1: CGPoint(x: 83.11, y: 45.4), controlPoint2: CGPoint(x: 84.31, y: 44.47))
    bezier2Path.addCurve(to: CGPoint(x: 114.1, y: 25.21), controlPoint1: CGPoint(x: 94.53, y: 36.71), controlPoint2: CGPoint(x: 104.08, y: 30.58))
    bezier2Path.addCurve(to: CGPoint(x: 115.88, y: 24.27), controlPoint1: CGPoint(x: 114.7, y: 24.9), controlPoint2: CGPoint(x: 115.29, y: 24.58))
    bezier2Path.addCurve(to: CGPoint(x: 134.32, y: 15.72), controlPoint1: CGPoint(x: 121.87, y: 21.14), controlPoint2: CGPoint(x: 128.02, y: 18.29))
    bezier2Path.addCurve(to: CGPoint(x: 138.12, y: 14.22), controlPoint1: CGPoint(x: 135.58, y: 15.21), controlPoint2: CGPoint(x: 136.84, y: 14.71))
    bezier2Path.addCurve(to: CGPoint(x: 143.54, y: 30.03), controlPoint1: CGPoint(x: 139.88, y: 19.35), controlPoint2: CGPoint(x: 141.69, y: 24.64))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 76.87, y: 85.62))
    bezier2Path.addCurve(to: CGPoint(x: 34.84, y: 136.22), controlPoint1: CGPoint(x: 60.03, y: 99.78), controlPoint2: CGPoint(x: 45.76, y: 116.92))
    bezier2Path.addCurve(to: CGPoint(x: 18.11, y: 129.1), controlPoint1: CGPoint(x: 29.13, y: 133.79), controlPoint2: CGPoint(x: 23.54, y: 131.41))
    bezier2Path.addCurve(to: CGPoint(x: 58.85, y: 67.53), controlPoint1: CGPoint(x: 28.13, y: 106.22), controlPoint2: CGPoint(x: 41.98, y: 85.43))
    bezier2Path.addCurve(to: CGPoint(x: 76.87, y: 85.62), controlPoint1: CGPoint(x: 64.64, y: 73.34), controlPoint2: CGPoint(x: 70.68, y: 79.4))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 411, y: 127.17))
    bezier2Path.addCurve(to: CGPoint(x: 360.64, y: 147.58), controlPoint1: CGPoint(x: 395.47, y: 133.47), controlPoint2: CGPoint(x: 378.27, y: 140.44))
    bezier2Path.addCurve(to: CGPoint(x: 329.2, y: 101.33), controlPoint1: CGPoint(x: 352.52, y: 130.56), controlPoint2: CGPoint(x: 341.88, y: 114.98))
    bezier2Path.addCurve(to: CGPoint(x: 367.72, y: 64), controlPoint1: CGPoint(x: 342.64, y: 88.3), controlPoint2: CGPoint(x: 355.78, y: 75.57))
    bezier2Path.addCurve(to: CGPoint(x: 411, y: 127.17), controlPoint1: CGPoint(x: 385.64, y: 82.18), controlPoint2: CGPoint(x: 400.37, y: 103.54))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 429.97, y: 213))
    bezier2Path.addLine(to: CGPoint(x: 378.08, y: 213))
    bezier2Path.addCurve(to: CGPoint(x: 363.47, y: 153.8), controlPoint1: CGPoint(x: 376.48, y: 192.1), controlPoint2: CGPoint(x: 371.41, y: 172.17))
    bezier2Path.addCurve(to: CGPoint(x: 413.7, y: 133.43), controlPoint1: CGPoint(x: 381.05, y: 146.67), controlPoint2: CGPoint(x: 398.21, y: 139.71))
    bezier2Path.addCurve(to: CGPoint(x: 429.97, y: 213), controlPoint1: CGPoint(x: 423.83, y: 158), controlPoint2: CGPoint(x: 429.58, y: 184.85))
    bezier2Path.close()
    bezier2Path.move(to: CGPoint(x: 31.58, y: 142.24))
    bezier2Path.addCurve(to: CGPoint(x: 11.49, y: 213), controlPoint1: CGPoint(x: 20.48, y: 163.71), controlPoint2: CGPoint(x: 13.43, y: 187.64))
    bezier2Path.addLine(to: CGPoint(x: 0, y: 213))
    bezier2Path.addCurve(to: CGPoint(x: 15.48, y: 135.38), controlPoint1: CGPoint(x: 0.38, y: 185.59), controlPoint2: CGPoint(x: 5.84, y: 159.42))
    bezier2Path.addCurve(to: CGPoint(x: 31.58, y: 142.24), controlPoint1: CGPoint(x: 20.7, y: 137.61), controlPoint2: CGPoint(x: 26.09, y: 139.9))
    bezier2Path.close()
    UIColor.gray.setFill()
    bezier2Path.fill()

    
    return bezier2Path.cgPath
}
