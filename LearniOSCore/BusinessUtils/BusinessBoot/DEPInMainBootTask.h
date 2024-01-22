//
// DEPInMainBootTask.h
// Pods
//
// Created by DEEP on 2023/12/28
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DEPInMainBootTaskProtocol

+ (void)execute;

@end

typedef Class<DEPInMainBootTaskProtocol> DEPInMainBootTask;

@interface DEPInMainBootTaskList : NSObject

- (void)addTaskByName:(NSString *)taskName;

- (NSArray<DEPInMainBootTask> *)tasks;

@end

NS_ASSUME_NONNULL_END
