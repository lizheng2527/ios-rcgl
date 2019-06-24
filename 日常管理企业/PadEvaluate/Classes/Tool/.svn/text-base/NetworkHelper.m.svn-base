//
//  NetworkHelper.m
//  PadEvaluate
//
//  Created by hzth-mac3 on 15/12/16.
//  Copyright © 2015年 hzth-mac3. All rights reserved.
//

#import "NetworkHelper.h"
#import "Reachability.h"

@implementation NetworkHelper

+ (BOOL)connectedToNetwork {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            //NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            //NSLog(@"正在使用3G网络");
            return YES;
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            //NSLog(@"正在使用wifi网络");
            return YES;
            break;
    }
    return NO;
}


@end
