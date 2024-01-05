//
// DEPBootLoaderManager.m
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "DEPBootLoaderManager.h"
#import "DEPBootTask.h"

@interface DEPBootLoaderManager ()

@end

@implementation DEPBootLoaderManager

+ (instancetype)sharedManager
{
    static DEPBootLoaderManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DEPBootLoaderManager alloc] init];
    });
    return manager;
}

- (void)bootWifhTaskList:(DEPBootTaskList *)taskList;
{
    for (DEPBootTask task in [taskList tasks]) {
        [task execute];
    }
}

@end
