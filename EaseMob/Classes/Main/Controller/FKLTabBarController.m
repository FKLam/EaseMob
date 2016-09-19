//
//  FKLTabBarController.m
//  EaseMob
//
//  Created by kun on 16/9/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLTabBarController.h"
#import "FKLContactController.h"

@interface FKLTabBarController ()<EMChatManagerDelegate>

@end

@implementation FKLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *selColor = [UIColor colorWithRed:0
                                        green:190 / 255.0
                                         blue:12 / 255.0
                                        alpha:1];
    for ( UINavigationController *nav in self.childViewControllers ) {
        [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : selColor} forState:UIControlStateSelected];
    }
    self.tabBar.tintColor = selColor;
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self = [MainStoryBoard(@"Main") instantiateViewControllerWithIdentifier:NSStringFromClass([FKLTabBarController class])];
    }
    return self;
}
+ (instancetype)fkl_tabBarController
{
    return [MainStoryBoard(@"Main") instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EMChatManagerDelegate
// 接收到好友请求
- (void)didReceiveBuddyRequest:(NSString *)username message:(NSString *)message
{
    // 显示badgeValue的改变
    [self fkl_changeBadgeValue];
    
    // 弹窗询问是否接受，如果同意，我们就跳转到通讯录界面
    [self fkl_askForBuddyAccept:username message:message];
    // 刷新通讯录界面（直接可以设置通讯录为chatManager的代理，然后做处理）buddyList更新方法中进行
}
#pragma mark - private method
- (void)fkl_changeBadgeValue
{
    FKLContactController *contactVC = [FKLContactController fkl_contactController];
    NSString *badgeValue = contactVC.navigationController.tabBarItem.badgeValue;
    NSInteger badgeNum = badgeValue.integerValue;
    badgeNum += 1;
    contactVC.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd", badgeNum];
}
// 弹窗询问
- (void)fkl_askForBuddyAccept:(NSString *)userName message:(NSString *)message
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@要添加您为好友", userName]
                                                                message:[NSString stringWithFormat:@"理由:%@", message]
                                                         preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        // 拒绝会发生的事情
        // 告诉环信，拒绝了好友请求
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:userName reason:message error:&error];
        if ( !error )
        {
            NSLog(@"Reject successful");
        }
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"接受" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 接受好友请求
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager acceptBuddyRequest:userName error:&error];
        if ( !error )
        {
            // 跳转控制器到通讯录
//            self.tabBar.selectedItem = [FKLContactController fkl_contactController].navigationController.tabBarItem;
            self.selectedViewController = self.childViewControllers[1];
            // 刷新通讯录界面
        }
    }]];
    [self presentViewController:ac animated:YES completion:nil];
}
@end
