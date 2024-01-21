//
// DepUIKit.h
// LearniOSCore-Core-InHouse-Playground-Utils
//
// Created by DEEP on 2024/1/15
// Copyright © 2024 DEEP. All rights reserved.
//
        

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (DepUIKit)

+ (nullable UIWindow *)dep_keyWindow;

@end

@interface DepUIKit : NSObject

+ (nullable UIViewController *)topViewController;
+ (nullable UIViewController *)topViewControllerForController:(UIViewController *)rootViewController;
+ (nullable UIViewController *)topViewControllerForView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
