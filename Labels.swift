//
//  Labels.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 1/31/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit
import Darwin

class SpeedomoterView:UIView{
    
    
    let maxSpeed: Double =  8
    let minSpeed: Double = 0

    let startAngle: Double = 220
    let maxAngle: Double = 20
    
    required init(coder aDecoder: NSCoder) {
        self.bottomText = ""
        self.topText = ""
        self.endAngle = 220
        self.speed = 0
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()

    }
    
    
    var speed:Double{
        didSet{
            //determine what to draw based on the speed 
           var perc = self.speed / maxSpeed
            if(perc > 1){
                perc = 1
            }
            
            var angle = abs(startAngle - maxAngle) * perc
            self.endAngle = self.startAngle - angle
            self.setNeedsDisplay()        
        }
    }
    

    @IBInspectable var endAngle:Double {
        didSet{
            setNeedsDisplay()
        }
    }

    
    @IBInspectable var bottomText:String{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var topText:String {
        didSet{
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
   //    let pi = M_PI
    //convert to radians 
     //var start :CGFloat = CGFloat( self.startAngle / pi)
     // var end :CGFloat = CGFloat(self.endAngle / pi)
        
       SpeedometerStyleKit.drawSpeedometer(frame: rect, startPositionAngle: CGFloat(self.startAngle), endPositionAngle: CGFloat(self.endAngle), mainFrame: rect, topLabelText: self.topText, bottomLabelText: self.bottomText)
    }
}

class SingleLabel:UIView{

    required init(coder aDecoder: NSCoder) {
        self.text = ""

        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()

    }
    
    @IBInspectable var text:String {
        didSet{
            self.setNeedsDisplay()
        }
    }

    override func drawRect(rect: CGRect) {
        RunnerGraphicsStyleKit.drawSingleLabel(singleLabelText: self.text, mainFrame: rect)
        
    }

}

 class DoubleLabel:UIView{
    required init(coder aDecoder: NSCoder) {
        self.bottomText = ""
        self.topText = ""
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()

    }

    
    @IBInspectable var bottomText:String{
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable var topText:String {
        didSet{
            setNeedsDisplay()
        }
    }

    
    override func drawRect(rect: CGRect) {
     
        RunnerGraphicsStyleKit.drawTwoLabels(bottomLabelText: self.bottomText, mainFrame: rect, topLabelText: self.topText)
    }
    
}
