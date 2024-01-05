//
// DEPBootTask.m
// Pods
//
// Created by DEEP on 2023/12/28
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "DEPBootTask.h"


@interface DEPBootTaskList ()

@property (nonatomic, strong, readwrite) NSMutableArray<DEPBootTask> *taskList;

@end

@implementation DEPBootTaskList

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
    if ([taskClass conformsToProtocol:@protocol(DEPBootTaskProtocol)]) {
        [self.taskList addObject:taskClass];
    }
}

- (NSArray<DEPBootTask> *)tasks
{
    return self.taskList.copy;
}

@end
