//
//  AppDelegate.m
//  EaseMob
//
//  Created by kun on 16/9/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "AppDelegate.h"
#import "FKLTabBarController.h"
#import "FKLLogRegController.h"

#define kEaseMobAppKey @"seemygo11#suibiantian"

@interface AppDelegate ()<EMChatManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 注册Appkey
    [[EaseMob sharedInstance] registerSDKWithAppKey:kEaseMobAppKey apnsCertName:nil otherConfig:@{kSDKConfigEnableConsoleLogger : @NO}];
    // 跟踪app生命周期
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    // 添加监听代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    // 判断是否是自动登录状态
    if ( [[EaseMob sharedInstance].chatManager isAutoLoginEnabled] ) {
        // 显示正在自动登录
        [SVProgressHUD showWithStatus:@"正在自动登录中..."];
        // 切换tabbarVC为根控制器
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 自动重连
// 环信在断开连接后，会自动重连

// 将要发起自动重连操作
- (void)willAutoReconnect
{
    NSLog(@"%s, line = %d", __func__, __LINE__);
}
// 自动重连操作完成后的回调（成功的话，error为nil，失败的话，查看error的错误信息）
- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if ( !error ) {
        NSLog(@"%s, line = %d", __func__, __LINE__);
    }
}

#pragma mark - 监听被动退出
- (void)didRemovedFromServer{
    [self fkl_logOffBeidong];
}

- (void)didLoginFromOtherDevice
{
    [self fkl_logOffBeidong];
}

#pragma mark - 自动登录
- (void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    [SVProgressHUD dismiss];
    if ( error ) {
        // 显示错误
        [JDStatusBarNotification showWithStatus:error.description dismissAfter:2.5];
    } else {
        // 切换控制器
        FKLTabBarController *tbc = [FKLTabBarController fkl_tabBarController];
        self.window.rootViewController = tbc;
    }
}

#pragma mark - 被动logOff
- (void)fkl_logOffBeidong
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO completion:^(NSDictionary *info, EMError *error) {
        // 被动退出后回调
        if ( !error )
        {
            // 切换控制器
            self.window.rootViewController = [FKLLogRegController fkl_logRegVC];
        }
    } onQueue:nil];
}

@end
