//
//  WormholeMessanger.swift
//  RunnerApp
//
//  Created by Janusz Chudzynski on 2/20/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

import Foundation

class WormholeMessanger{
    var wormhole = MMWormhole()

    init(){
//        self = super.init()
        self.wormhole = MMWormhole(applicationGroupIdentifier: "group.com.izotx.runnerApp", optionalDirectory: "shared_directory")
    
    }

    
    func passMessage(message:String, key:String){
        self.wormhole.passMessageObject(message, identifier: key)
    }
    
    
    func listenForMessages(key:NSString){
        self.wormhole.listenForMessageWithIdentifier(key as! String, listener: {(object:AnyObject!) -> Void in
           println("\(object)")
            
        })
    }
    
    
    
    
    
}