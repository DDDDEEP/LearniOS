//
// DEPInMainBootAppDelegate.m
// LearniOSCore
//
// Created by DEEP on 2023/12/5
// Copyright © 2023 DEEP. All rights reserved.
//
        

#import "DEPInMainBootAppDelegate.h"
#import "DEPAppContext.h"
#import "DEPInMainBootManager.h"
#import "DEPInMainBootTask.h"

#pragma mark - DEPAppContext

@interface DEPAppOpenURLContext ()

@property (nonatomic, strong, readwrite) NSURL *openURL;
@property (nonatomic, copy, readwrite) NSDictionary *options;
@property (nonatomic, copy, readwrite) NSString *sourceApplication;
@property (nonatomic, strong, readwrite) id annotation;

@end

@implementation DEPAppOpenURLContext

@end


@interface DEPAppContext()

@property (nonatomic, copy, readwrite, nullable) NSDictionary *launchOptions;
@property (nonatomic, strong, readwrite, nullable) UIApplication *application;
@property (nonatomic, strong, readwrite, nullable) DEPInMainBootAppDelegate *appDelegate;
@property (nonatomic, strong, readwrite, nullable) DEPAppOpenURLContext *urlContext;
@property (nonatomic, assign, readwrite) BOOL isInForeground;

@end

@implementation DEPAppContext

+ (instancetype)sharedContext
{
    static DEPAppContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[DEPAppContext alloc] init];
    });
    return context;
}

@end

extern inline DEPAppContext * DEPCurrentAppContext(void)
{
    return [DEPAppContext sharedContext];
}



#pragma mark - DEPInMainBootAppDelegate

@interface DEPInMainBootAppDelegate ()

@end

@implementation DEPInMainBootAppDelegate
@synthesize supportOrientation = _supportOrientation;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _supportOrientation = UIInterfaceOrientationMaskPortrait;
    }
    return self;
}

#pragma mark - UIApplication lifecycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DEPCurrentAppContext().application = application;
    DEPCurrentAppContext().appDelegate = self;
    DEPCurrentAppContext().launchOptions = launchOptions;
    
    // 由主模块控制其他模块的加载任务，保证启动流程的维护性
    DEPInMainBootTaskList *taskList = [[DEPInMainBootTaskList alloc] init]; {
        [taskList addTaskByName:@"DEPMainWindowInitTask"];
//        [taskList addTaskByName:@"DEPRouterInitTask"];
    }
    [[DEPInMainBootManager sharedManager] bootWifhTaskList:taskList];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    
}


#pragma mark - Schemes

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    DEPAppOpenURLContext *context =  [[DEPAppOpenURLContext alloc] init]; {
        context.openURL = url;
        context.options = options;
        context.annotation = options[UIApplicationOpenURLOptionsAnnotationKey];
        context.sourceApplication = options[UIApplicationOpenURLOptionsSourceApplicationKey];
    }
    DEPCurrentAppContext().urlContext = context;
    return YES;
}


#pragma mark - Screen Orientation

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window
{
    return self.supportOrientation;
}

@end
