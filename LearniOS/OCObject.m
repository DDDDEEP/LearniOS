//
// OCObject.m
// LearniOS
//
// Created by DEEP on 2021/9/30
// Copyright © 2021 DEEP. All rights reserved.
//
        

#import "OCObject.h"

@interface OCObject ()

@end

@implementation OCObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableArray *abc = [NSMutableArray array];
        NSArray *a1 = @[abc];
        NSArray *a2 = [a1 copy];
        NSArray *a3 = [[NSArray alloc] initWithArray:a1 copyItems:YES];
        [abc addObject:@"123"];
        NSLog(@"123");
    }
    return self;
}

@end
