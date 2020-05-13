//
//  AppDelegate.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/15.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "AppDelegate.h"
#import "Public.h"

//集成蒲公英
#import <PgySDK/PgyManager.h>
#import <PgyUpdate/PgyUpdateManager.h>

@interface AppDelegate ()
//<UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    
    return NO;
}

-(void)initURL
{
    if (![self isBlankString: [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_BASEURL]]) {
        
    }
    else
        //http://58.132.43.217/dc
    {
//        [[NSUserDefaults standardUserDefaults]setValue:@"http://www.zdhx-edu.com/dc-teachingplatform" forKey:USER_DEFAULT_BASEURL];
        //学校
        [[NSUserDefaults standardUserDefaults]setValue:@"http://58.132.43.217/dc" forKey:USER_DEFAULT_BASEURL];
        
//        [[NSUserDefaults standardUserDefaults]setValue:@"http://192.168.1.121:8888/dc-teachingplatform" forKey:USER_DEFAULT_BASEURL];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    
    if (![self isBlankString: [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_IMAGE_BASEURL]]) {
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"http://58.132.43.217" forKey:USER_DEFAULT_IMAGE_BASEURL];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self initURL];
    
    //启动检查更新
    [[PgyManager sharedPgyManager] startManagerWithAppId:@"008e60bd70ba877199d1064ac4766cb6"];
    //启动更新检查SDK
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"008e60bd70ba877199d1064ac4766cb6"];
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    
//    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
//    splitViewController.delegate = self;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}

@end
