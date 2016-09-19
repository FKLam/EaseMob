//
//  FKLWeChatController.m
//  EaseMob
//
//  Created by kun on 16/9/11.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLWeChatController.h"

static NSString * const FKLWeChatTitleNormal = @"微信";
static NSString * const FKLWeChatTitleWillConnect = @"连接中...";
static NSString * const FKLWeChatTitleDisconnect = @"微信(未连接)";
static NSString * const FKLWeChatTitleWillReceiveMsg = @"收取中...";

@interface FKLWeChatController ()<EMChatManagerDelegate>

@end

@implementation FKLWeChatController

+ (instancetype)fkl_weChatController
{
    return [MainStoryBoard(@"Chat") instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = FKLWeChatTitleNormal;
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

#pragma mark - EMChatManagerDelegate
// 即将自动重连
- (void)willAutoReconnect
{
    
}
// 自动重连
- (void)didAutoReconnectFinishedWithError:(NSError *)error
{
    if ( !error ) {
        // success
        self.title = FKLWeChatTitleNormal;
    } else {
        // faild
        self.title = FKLWeChatTitleDisconnect;
    }
}
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    switch (connectionState) {
        case eEMConnectionConnected:
        {
            self.title = FKLWeChatTitleNormal;
            break;
        }
        case eEMConnectionDisconnected:
        {
            self.title = FKLWeChatTitleDisconnect;
            break;
        }
        default:
            break;
    }
}
@end
