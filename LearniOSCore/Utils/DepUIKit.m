//
// DepUIKit.m
// LearniOSCore-Core-InHouse-Playground-Utils
//
// Created by DEEP on 2024/1/15
// Copyright © 2024 DEEP. All rights reserved.
//
        

#import "DepUIKit.h"

#import <YYKit/UIView+YYAdd.h>

@implementation UIWindow (DepUIKit)

+ (nullable UIWindow *)dep_keyWindow
{
    if (@available(iOS 13.0, *)) {
        // iOS 13.0+
        UIWindow *keyWindow = nil; {
            UIWindowScene *uniqueActiveScene; {
                for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
                    if (scene.activationState == UISceneActivationStateForegroundActive
                        && [scene isKindOfClass:UIWindowScene.class]) {
                        if (uniqueActiveScene != nil) {
                            uniqueActiveScene = nil;
                            break;
                        }
                        UIWindowScene *windowScene = (UIWindowScene *)scene;
                        uniqueActiveScene = windowScene;
                    }
                }
            }
            UIWindowScene *keyWindowScene = uniqueActiveScene ?: [UIApplication sharedApplication].keyWindow.windowScene;
            keyWindow = [self p_keyWindowForScene:keyWindowScene];
        }
        
        if (!keyWindow) {
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.isKeyWindow) {
                    keyWindow = window;
                    break;
                }
            }
        }
        
        // 如果还没有，就兜底 [UIApplication sharedApplication].keyWindow
        // ……
        
        // 如果还没有，[UIApplication sharedApplication].delegate 可能 responds @sel(window)
        // ……
        
        return keyWindow;
    } else {
        return [UIApplication sharedApplication].keyWindow;
    }
    
}

+ (nullable UIWindow *)p_keyWindowForScene:(UIWindowScene *)scene API_AVAILABLE(ios(13.0))
{
    if (@available(iOS 13.0, *)) {
        for (UIWindow *window in scene.windows) {
            if (window.isKeyWindow) {
                return window;
            }
        }
    }
    return nil;
}

@end

@implementation DepUIKit

+ (nullable UIViewController *)topViewController
{
    return [self topViewControllerForController:[UIWindow dep_keyWindow].rootViewController];
}

+ (nullable UIViewController *)topViewControllerForController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerForController:[navigationController.viewControllers lastObject]];
    }
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabController = (UITabBarController *)rootViewController;
        return [self topViewControllerForController:tabController.selectedViewController];
    }
    if (rootViewController.presentedViewController) {
        return [self topViewControllerForController:rootViewController.presentedViewController];
    }
    return rootViewController;
}

+ (nullable UIViewController *)topViewControllerForView:(UIView *)view
{
    UIViewController *responder = view.viewController ?: [UIWindow dep_keyWindow].rootViewController;
    return [self topViewControllerForController:(UIViewController *)responder];
}

@end
