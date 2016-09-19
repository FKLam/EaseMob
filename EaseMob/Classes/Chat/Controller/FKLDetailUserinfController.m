//
//  FKLDetailUserinfController.m
//  EaseMob
//
//  Created by kun on 16/9/12.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLDetailUserinfController.h"
#import "UIImage+YFResizing.h"
#import "FKLWeChatController.h"
#import "FKLTabBarController.h"
#import "FKLChatController.h"

@interface FKLDetailUserinfController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation FKLDetailUserinfController

+ (instancetype)fkl_detailUserinfVC
{
    return [[UIStoryboard storyboardWithName:NSStringFromClass(self) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fkl_addBtns];
    self.userName.text = self.buddy.username;
}

#pragma mark - 添加发消息按钮
- (void)fkl_addBtns
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    self.tableView.tableFooterView = footerView;
    UIButton *sendMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendMsgBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    [sendMsgBtn setBackgroundImage:[UIImage yf_imageWithColor:[UIColor greenColor]] forState:UIControlStateNormal];
    [sendMsgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendMsgBtn setTitle:@"发消息" forState:UIControlStateNormal];
    sendMsgBtn.frame = CGRectMake(30, 0, self.view.bounds.size.width - 60, 44);
    [footerView addSubview:sendMsgBtn];
}
- (void)sendMsg
{
    [self.navigationController popViewControllerAnimated:NO];
    // 修改tabbar
    FKLTabBarController *tabBarVC = (FKLTabBarController *)[[UIApplication sharedApplication].keyWindow rootViewController];
    tabBarVC.selectedViewController = tabBarVC.viewControllers[0];
    
    FKLChatController *chatVC = [[FKLChatController alloc] init];
    chatVC.buddy = self.buddy;
    [(UINavigationController *)tabBarVC.viewControllers[0] pushViewController:chatVC animated:YES];
}
@end
