//
//  LBSAppDelegate.m
//  LoafBottleStick
//
//  Created by Joshua Caswell on 8/19/16.
//  Copyright © 2016 Josh Caswell. All rights reserved.
//

#import "LBSAppDelegate.h"
#import "LBSCollectionViewController.h"

@implementation LBSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    
    LBSCollectionViewController * controller = [LBSCollectionViewController controllerUsingFrame:windowFrame];
    
    UIWindow * window = [[UIWindow alloc] initWithFrame:windowFrame];
    
    [self setWindow:window];
    
    [[self window] setRootViewController:controller];
    [[self window] makeKeyAndVisible];
    
    return YES;
}

@end
