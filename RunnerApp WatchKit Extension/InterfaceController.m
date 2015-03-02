//
//  InterfaceController.m
//  RunnerApp WatchKit Extension
//
//  Created by Janusz Chudzynski on 2/20/15.
//  Copyright (c) 2015 Janusz Chudzynski. All rights reserved.
//

#import "InterfaceController.h"
#import "MMWormhole.h"


@interface InterfaceController()
@property (nonatomic,strong) MMWormhole * wormhole;
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    self.wormhole = [[MMWormhole alloc]initWithApplicationGroupIdentifier:@"group.com.izotx.runnerApp" optionalDirectory:@"shared_directory"];
}
  
- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}
    
- (IBAction)sendMessage {
    [self.wormhole passMessageObject:@{@"message":@"content of the message"} identifier:@"key"];
    NSLog(@"Send Message");
}

@end



