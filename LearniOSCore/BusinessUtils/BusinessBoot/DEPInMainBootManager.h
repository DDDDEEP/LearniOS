//
// DEPInMainBootManager.h
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import <UIKit/UIKit.h>

@class DEPInMainBootTaskList;

/// 执行 after-main 的任务
@interface DEPInMainBootManager : NSObject

+ (instancetype)sharedManager;

- (void)bootWifhTaskList:(DEPInMainBootTaskList *)taskList;

@end
