//
// AppDelegate.m
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - UIApplication lifecycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    if (application.applicationState == UIApplicationStateBackground) {
        // mark background launch
    }
    BOOL result = [super application:application willFinishLaunchingWithOptions:launchOptions];
    return result;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [super application:application performFetchWithCompletionHandler:completionHandler];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [super applicationWillTerminate:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // mark enter foreground begin
    [super applicationWillEnterForeground:application];
    // mark enter foreground end
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [super applicationDidEnterBackground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [super applicationDidBecomeActive:application];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [super applicationWillResignActive:application];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [super applicationDidReceiveMemoryWarning:application];
}

@end
