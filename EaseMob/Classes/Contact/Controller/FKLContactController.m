//
//  FKLContactController.m
//  EaseMob
//
//  Created by kun on 16/9/11.
//  Copyright © 2016年 kun. All rights reserved.
//

/**
 接收好友请求
 1，不管在哪个界面，都会看到好友请求（登录状态）
 2，会在tabBar做一个badgeValue提醒
 3，对我们的好友请求做处理
 */

#import "FKLContactController.h"
#import "FKLContactCell.h"
#import "FKLDetailUserinfController.h"

@interface FKLContactController ()<EMChatManagerDelegate>
@property (nonatomic, copy) NSMutableArray *friends;
@end

@implementation FKLContactController

+ (instancetype)fkl_contactController
{
    return [MainStoryBoard(@"Contact") instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置标题
    self.title = @"通讯录";
    
    // 设置添加好友按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"contacts_add_friend"] style:UIBarButtonItemStylePlain target:self action:@selector(addFrined)];
    // 注册cell
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    self.tableView.rowHeight = 50.0;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    // 监听好友列表的刷新
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKLContactCell *cell = [FKLContactCell fkl_contactCellWithTableView:tableView];
    
    EMBuddy *buddy = self.friends[indexPath.row];
    cell.buddy = buddy;
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( editingStyle == UITableViewCellEditingStyleDelete ) {
        EMBuddy *buddy = [self.friends objectAtIndex:indexPath.row];
        EMError *error = nil;
        [[EaseMob sharedInstance].chatManager removeBuddy:buddy.username removeFromRemote:YES error:&error];
        if ( !error ) {
            NSLog(@"Delete successful");
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMBuddy *buddy = self.friends[indexPath.row];
    FKLDetailUserinfController *detailVC = [FKLDetailUserinfController fkl_detailUserinfVC];
    detailVC.buddy = buddy;
    detailVC.hidesBottomBarWhenPushed = YES;
//    FKLWeChatController *weChatVC = [FKLWeChatController fkl_weChatController];
//    self.navigationController.tabBarController.selectedViewController = weChatVC;
//    [weChatVC.navigationController pushViewController:detailVC animated:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mmark - 添加好友操作
- (void)addFrined
{
    // 微信中，它是直接push到一个搜索界面，然后再做相应的处理，我们这里为了方便，直接弹框
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"好友申请" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"填写username";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"填写理由";
    }];
    [ac addAction:[UIAlertAction actionWithTitle:@"发送"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * _Nonnull action) {
                                             // 发送好友请求(同步)
                                             EMError *error = nil;
                                             BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:ac.textFields.firstObject.text message:ac.textFields.lastObject.text error:&error];
                                             if ( !error ) {
                                                 NSLog(@"Success %d", isSuccess);
                                             }
                                         }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:ac animated:YES completion:^{
        //
    }];

}
#pragma mark - getter methods
- (NSMutableArray *)friends
{
    if ( nil == _friends ) {
        _friends = [NSMutableArray array];
        // 好友列表（由EMBuddy对象组成）
        NSArray *buddies = [[EaseMob sharedInstance].chatManager buddyList];
        if ( buddies.count > 0 ) {
            [_friends addObjectsFromArray:buddies];
        }
    }
    return _friends;
}

#pragma mark - EMChatManagerDelegate
- (void)didUpdateBuddyList:(NSArray *)buddyList changedBuddies:(NSArray *)changedBuddies isAdd:(BOOL)isAdd
{
    // 改变模型数组
    [self.friends removeAllObjects];
    [self.friends addObjectsFromArray:buddyList];
    // 刷新表格
    [self.tableView reloadData];
}
@end
