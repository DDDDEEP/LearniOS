//
// DEPAppContext.h
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import <UIKit/UIKit.h>

@class DEPInMainBootAppDelegate;

#pragma mark - Sub Context Class

@interface DEPAppOpenURLContext : NSObject

@property (nonatomic, strong, readonly, nullable) NSURL *openURL;
@property (nonatomic, copy, readonly, nullable) NSDictionary *options;
@property (nonatomic, copy, readonly, nullable) NSString *sourceApplication;
@property (nonatomic, strong, readonly, nullable) id annotation;

@end


#pragma mark - Main Context Class

@interface DEPAppContext : NSObject

@property (nonatomic, copy, readonly, nullable) NSDictionary *launchOptions;
@property (nonatomic, strong, readonly, nullable) UIApplication *application;
@property (nonatomic, strong, readonly, nullable) DEPInMainBootAppDelegate *appDelegate;
@property (nonatomic, strong, readonly, nullable) DEPAppOpenURLContext *urlContext;
//notificationContext;
//userActivityContext;
//backgroundFetchContext;
//shortcutContext;
//bgURLSessionContext;
//handleNotificationContext;
@property (nonatomic, assign, readonly) BOOL isInForeground;

@end

FOUNDATION_EXPORT DEPAppContext * _Nonnull DEPCurrentAppContext(void);
