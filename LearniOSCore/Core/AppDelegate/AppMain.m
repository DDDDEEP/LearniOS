//
// AppMain.m
// LearniOS
//
// Created by DEEP on 2023/12/27
// Copyright © 2023 DEEP. All rights reserved.
//
        
#import "AppMain.h"

#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#include <unistd.h>
#include <dlfcn.h>

#if !IS_IN_HOUSE && !DEBUG
static __attribute__((always_inline))
void prevent_debugger() {
#ifdef __arm64__
    asm volatile (
        "mov x0, #26\n" // ptrace syscall (26 in XNU)
        "mov x1, #31\n" // PT_DENY_ATTACH (0x1f) - first arg
        "mov x2, #0\n"
        "mov x3, #0\n"
        "mov x16, #0\n"
        "svc #128\n"    // make syscall
    );
#endif
}
#endif


int AppMain(int argc, char * argv[]) {
    @autoreleasepool {
        
#if DEBUG
        NSLog(@"[appMain] start from func: %s", __func__);
#endif

        // 可以使用其他安全模式的 delegate
        // ...
        
#if !IS_IN_HOUSE && !DEBUG
        prevent_debugger();
#endif
        
        NSLog(@"[appMain] mark as excute Main");
        return UIApplicationMain(argc, argv, nil, @"AppDelegate");
    }
}
