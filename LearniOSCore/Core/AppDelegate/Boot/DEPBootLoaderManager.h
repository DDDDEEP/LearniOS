//
// DEPBootLoaderManager.h
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import <UIKit/UIKit.h>

@class DEPBootTaskList;

@interface DEPBootLoaderManager : NSObject

+ (instancetype)sharedManager;

- (void)bootWifhTaskList:(DEPBootTaskList *)taskList;

@end
