//
// DEPMainWindowInitTask.m
// Pods
//
// Created by DEEP on 2023/12/28
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "DEPMainWindowInitTask.h"
#import "DEPAppContext.h"
#import "DEPBootAppDelegate.h"
#import <LearniOSCore/LearniOSCore-Swift.h>
#import <SnapKit/SnapKit-Swift.h>

@implementation DEPMainWindowInitTask

+ (void)execute
{
    MainWindow *window = [[MainWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]; {
        MainTabBarViewController *tabBarController = [[MainTabBarViewController alloc] init];
        window.rootViewController = tabBarController;
        [window makeKeyAndVisible];
    }
    DEPCurrentAppContext().appDelegate.window = window;
    
}

@end
