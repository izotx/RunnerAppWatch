//
//  Buttons.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 1/26/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation
import UIKit

protocol customButtonState{
    func buttonSelected (button: CustomButton);
    func buttonUnselected(button: CustomButton);
}

/**Used as a parent of the */
 class CustomButton:UIButton{
    var delegate :customButtonState?
    
    
    override  init(frame: CGRect) {
        self.userSelected = false
    
        super.init(frame: frame)
    }
    
    var userSelected:Bool{
        didSet{
            self.setNeedsDisplay();
        }
    }
    
    required init(coder aDecoder: NSCoder) {
         self.userSelected = false
        
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
        self.setBackgroundImage(nil, forState: UIControlState.Normal)
        
        self.setImage(nil, forState: UIControlState.Normal)
        self.addObserver(self, forKeyPath: "selected", options:.New, context: nil);
        self.addObserver(self, forKeyPath: "highlighted", options:.New, context: nil);
        self.addObserver(self, forKeyPath: "userSelected", options:.New, context: nil);
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        if(keyPath == "selected"){
            self.setNeedsDisplay();            
        }
        if(keyPath == "highlighted"){
            self.setNeedsDisplay();
        }
        if(keyPath == "userSelected"){
            self.setNeedsDisplay();
        }
    }
    
    
    deinit{
        self.removeObserver(self, forKeyPath: "selected");
        self.removeObserver(self, forKeyPath: "highlighted");
        self.removeObserver(self, forKeyPath: "userSelected");
    }
    

//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesBegan(touches, withEvent: event)
//        super.touchesBegan(touches, withEvent: event)
//        self.setNeedsDisplay()
//    }
//    
//    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
//        super.touchesCancelled(touches, withEvent: event)
//        self.setNeedsDisplay()
//    }
//    

//    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesEnded(touches, withEvent: event)
//        super.touchesCancelled(touches, withEvent: event)
//
//        
//        self.setNeedsDisplay()
//    }
//
//    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//        self.nextResponder()?.touchesMoved(touches, withEvent: event)
//        super.touchesMoved(touches, withEvent: event)
//        //             StyleKitName.drawSelectedStartButton(frame: self.frame)
//        self.setNeedsDisplay()
//    }
}

 class stopButton:CustomButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        if self.state == UIControlState.Highlighted || self.state == UIControlState.Selected
        {
            RunnerGraphicsStyleKit.drawSelectedStopButton(frame: rect);
        }
        else{
            RunnerGraphicsStyleKit.drawStopButton(frame: rect);
            
        }
        
    }

}

class startButton:CustomButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        if self.state == UIControlState.Highlighted || self.state == UIControlState.Selected || self.userSelected == true
        {
            RunnerGraphicsStyleKit.drawSelectedStartButton(frame: rect);
        }
        else{
            RunnerGraphicsStyleKit.drawStartButton(frame: rect);
            
        }
        
    }
    
}


class pauseButton:CustomButton{
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        if self.state == UIControlState.Highlighted || self.state == UIControlState.Selected  || self.userSelected == true
        {
            RunnerGraphicsStyleKit.drawSelectedPauseButton(frame: rect);
        }
        else{
            RunnerGraphicsStyleKit.drawPauseButton(frame: rect);
            
        }

    }
    
}




class mphButton:CustomButton{
    override  init(frame: CGRect) {
        text = "kph"
        super.init(frame: frame)

    }
    
    var text:String{
        didSet{
            self.setNeedsDisplay()
        }
    }

    required init(coder aDecoder: NSCoder) {
        text = "kph"
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = UIColor.clearColor()
        if self.state == UIControlState.Highlighted || self.state == UIControlState.Selected
        {

           RunnerGraphicsStyleKit.drawSelectedSingleLabel(singleLabelText: self.text, mainFrame: rect)
        }
        else
        {
            RunnerGraphicsStyleKit.drawSingleLabel(singleLabelText: self.text, mainFrame: rect)
        }
    }
}
