//
// DEPBootTask.h
// Pods
//
// Created by DEEP on 2023/12/28
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DEPBootTaskProtocol

+ (void)execute;

@end

typedef Class<DEPBootTaskProtocol> DEPBootTask;

@interface DEPBootTaskList : NSObject

- (void)addTaskByName:(NSString *)taskName;

- (NSArray<DEPBootTask> *)tasks;

@end

NS_ASSUME_NONNULL_END
