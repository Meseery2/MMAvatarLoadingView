//
//  MMCircleProgressBar.swift
//  MMAvatarLoadingView
//
//  Created by Mohamed EL Meseery on 7/21/18.
//

import UIKit

class MMCircleProgressBar : UIView {
    
    //MARK:- Public Vars
    public var progress : Float = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.shapeLayer?.strokeEnd = CGFloat(self.progress)
            }
        }
    }
    
    public var progressBarColor : UIColor = UIColor.blue {
        didSet {
            shapeLayer?.strokeColor = progressBarColor.cgColor
        }
    }
    
    public var progressBarWidth: CGFloat = 10 {
        didSet {
            shapeLayer?.lineWidth = progressBarWidth
        }
    }
    
    public var circleBackgroundColor : UIColor = UIColor.clear {
        didSet {
            shapeLayer?.fillColor = circleBackgroundColor.cgColor
        }
    }
    
    public var clockWise:Bool = true
    
    //MARK:- Private vars & Functions
    private var shapeLayer:CAShapeLayer?
    
    
    private func createLayer() -> CAShapeLayer {
        let startAngle = CGFloat(-.pi/2.0)
        let endAngle = CGFloat (2.0 * .pi - .pi/2.0)
        let circularPath = UIBezierPath(arcCenter:center,
                                        radius: radius,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: self.clockWise)
        let shape = CAShapeLayer()
        shape.path = circularPath.cgPath
        shape.lineCap = kCALineCapRound
        return shape
    }
    
    private func prepareLayers(){
        shapeLayer = createLayer()
        shapeLayer?.strokeEnd = 0
        shapeLayer?.fillColor = circleBackgroundColor.cgColor
        shapeLayer?.strokeColor = progressBarColor.cgColor
        shapeLayer?.lineWidth = progressBarWidth
        self.layer.addSublayer(shapeLayer!)
    }
    
    private var radius : CGFloat {
        return self.bounds.width > self.bounds.height ? self.bounds.width/2.0 : self.bounds.height/2.0
    }
    
    //MARK:- Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.prepareLayers()
    }
    
    init(frame: CGRect,clockWise: Bool) {
        super.init(frame: frame)
        self.clockWise = clockWise
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
