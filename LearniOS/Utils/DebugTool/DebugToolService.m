//
// DebugToolService.m
// LearniOS
//
// Created by DEEP on 2022/3/16
// Copyright © 2022 DEEP. All rights reserved.
//
        

#import "DebugToolService.h"

#import "ANYMethodLog.h"

#import <QuartzCore/QuartzCore.h>

@interface CALayer (DEdAdditions)

@end

@implementation CALayer (DEdAdditions)

- (void)dep_addAnimation:(CAAnimation *)anim forKey:(nullable NSString *)key
{
    [self dep_addAnimation:anim forKey:key];
}

@end


static void dep_initSwizzle()
{
//    Class customClass;
//    customClass = NSClassFromString(@"CALayer");
//    [customClass dep_swizzleInstanceMethod:@selector(addAnimation:forKey:) with:@selector(dep_addAnimation:forKey:)];
    
    NSArray *debugList = @[
        @"setAdditive:",
        @"display",
    ];
    NSArray *methodList = @[
        @"addAnimation:forKey:",
        @"setdosition:",
        @"setFromValue:",
        @"setToValue:",
    ];
    NSArray *whiteList = [debugList arrayByAddingObjectsFromArray:methodList];
    [ANYMethodLog logMethodWithClass:NSClassFromString(@"CALayer") condition:^BOOL(SEL sel) {
        return [whiteList containsObject:NSStringFromSelector(sel)];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        if ([debugList containsObject:NSStringFromSelector(sel)]) {
            id a = nil;
        }
    } after:nil];
    
    [ANYMethodLog logMethodWithClass:NSClassFromString(@"CABasicAnimation") condition:^BOOL(SEL sel) {
        return [whiteList containsObject:NSStringFromSelector(sel)];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        if ([debugList containsObject:NSStringFromSelector(sel)]) {
            id a = nil;
        }
    } after:nil];
    
    [ANYMethodLog logMethodWithClass:NSClassFromString(@"CAdropertyAnimation") condition:^BOOL(SEL sel) {
        return [whiteList containsObject:NSStringFromSelector(sel)];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        if ([debugList containsObject:NSStringFromSelector(sel)]) {

            id a = nil;
        }
    } after:nil];
    
    [ANYMethodLog logMethodWithClass:NSClassFromString(@"NSDictionary") condition:^BOOL(SEL sel) {
        return [@[@"valueForKey:"] containsObject:NSStringFromSelector(sel)];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        if ([@[@"countOfabc", @"objectInabcAtIndex:", @"abcAtIndexes:", @"objectForKey:"] containsObject:NSStringFromSelector(sel)]) {
            id a = nil;
        }
    }];
    
    [ANYMethodLog logMethodWithClass:NSClassFromString(@"UIView") condition:^BOOL(SEL sel) {
        return [@[@"drawRect"] containsObject:NSStringFromSelector(sel)];
    } before:^(id target, SEL sel, NSArray *args, int deep) {
        id a = nil;
    } after:^(id target, SEL sel, NSArray *args, NSTimeInterval interval, int deep, id retValue) {
        
    }];
    
    CAKeyframeAnimation *a = [[CAKeyframeAnimation alloc] init];
    a.additive = NO;
    [a setValue:@"123" forKey:@"123"];
    
}

@implementation DebugToolService

static void __attribute__((constructor)) DebugToolServiceBootstrapLoad(void)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dep_initSwizzle();
    });
}


@end
