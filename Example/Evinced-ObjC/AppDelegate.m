//
//  AppDelegate.m
//  Example-ObjC
//
//  Created by Indragie Karunaratne on 4/20/19.
//  Copyright © 2019 Indragie Karunaratne. All rights reserved.
//

#import "AppDelegate.h"

#ifdef DEBUG
@import EvincedSDKiOS;
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Other code if needed
    
    #ifdef DEBUG
    [EvincedEngine start];
    #endif
    
    return YES;
}

@end
