//
// DEPInMainBootTask.m
// Pods
//
// Created by DEEP on 2023/12/28
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "DEPInMainBootTask.h"


@interface DEPInMainBootTaskList ()

@property (nonatomic, strong, readwrite) NSMutableArray<DEPInMainBootTask> *taskList;

@end

@implementation DEPInMainBootTaskList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _taskList = [NSMutableArray array];
    }
    return self;
}

- (void)addTaskByName:(NSString *)taskName
{
    Class taskClass = NSClassFromString(taskName);
    NSAssert([taskClass conformsToProtocol:@protocol(DEPInMainBootTaskProtocol)], @"未实现 @protocol(DEPInMainBootTaskProtocol)");
    [self.taskList addObject:taskClass];
}

- (NSArray<DEPInMainBootTask> *)tasks
{
    return self.taskList.copy;
}

@end
