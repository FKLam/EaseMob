//
//  FKLChatController.m
//  EaseMob
//
//  Created by kun on 16/9/13.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLChatController.h"
#import "FKLInputView.h"
#import "FKLChatCell.h"
#import "FKLChat.h"
#import "FKLChatFrame.h"

#define kInputViewHeight 44.0

@interface FKLChatController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, EMChatManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FKLInputView *inputView;
@property (nonatomic, copy) NSMutableArray *chatMsgs;
@end

@implementation FKLChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加子控件
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputView];
    // 显示标题
    self.title = self.buddy.username;
    // 获取聊天记录
    [self fkl_reloadChatMsgs];
    // 监听键盘弹出，对相应的布局做修改
    [self fkl_addObserver];
    // 注册cell
    [self.tableView registerClass:[FKLChatCell class] forCellReuseIdentifier:NSStringFromClass([self class])];
    // 添加代理，监听收到消息
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 进入聊天页面就滚动到底部
    [self fkl_scrollToBottom];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMsgs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKLChatCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    FKLChatFrame *chatFrame = self.chatMsgs[indexPath.row];
    cell.chatFrame = chatFrame;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FKLChatFrame *chatFrame = self.chatMsgs[indexPath.row];
    return chatFrame.cellH;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 在此处发送消息
    // 构造EMChatText
    EMChatText *chatText = [[EMChatText alloc] initWithText:textField.text];
    // 构造body对象
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:chatText];
    // 构造消息
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.buddy.username bodies:@[body]];
    // 发送成功之后刷新列表
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        // 即将发送时的回调
        // 此处可以添加msg到数据中
        // 刷新列表
        // 等待发送成功后再重新刷新
        // 一般用于大图片／视频／音频传送的时候用到
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        // 发送结束时的回调
        if ( !error )
        {
            textField.text = nil;
            // 刷新界面
            [self fkl_reloadChatMsgs];
        }
    } onQueue:nil];
    return YES;
}
#pragma mark - EMChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [self fkl_reloadChatMsgs];
}
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    [self fkl_reloadChatMsgs];
}
#pragma mark - private methods
- (void)fkl_reloadChatMsgs
{
    // 首先刷新的时候要移除已有的对象
    [self.chatMsgs removeAllObjects];
    // 拿到当前会话对象
    EMConversation *conversaton = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    // 获取会话中聊天记录（从数据中加载消息）
    NSArray *msgs = [conversaton loadAllMessages];
    long long preTime = 0;
    for ( EMMessage *msg in msgs ) {
        if ( 0 < [self.chatMsgs count] )
        {
            FKLChatFrame *preChatFrame = self.chatMsgs.lastObject;
            preTime = preChatFrame.chat.msg.timestamp;
        }
        FKLChat *chat = [FKLChat fkl_chatWith:msg preTimestamp:preTime];
        FKLChatFrame *chatFrame = [[FKLChatFrame alloc] init];
        chatFrame.chat = chat;
        [self.chatMsgs addObject:chatFrame];
    }
    // 刷新表格
    [self.tableView reloadData];
    // 滚动到最后一行
    [self fkl_scrollToBottom];
}
- (void)fkl_scrollToBottom
{
    if ( self.chatMsgs.count == 0 )
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatMsgs.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)fkl_addObserver
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification
                                                      object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                                                          /**
                                                           {name = UIKeyboardWillChangeFrameNotification; userInfo = {
                                                           UIKeyboardAnimationCurveUserInfoKey = 7;
                                                           UIKeyboardAnimationDurationUserInfoKey = "0.25";
                                                           UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 258}}";
                                                           UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 796}";
                                                           UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 538}";
                                                           UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 258}}";
                                                           UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}";
                                                           UIKeyboardIsLocalUserInfoKey = 1;
                                                           }}
                                                           */
                                                          //                                                            NSLog(@"%s, line = %d, note = %@", __FUNCTION__, __LINE__, note);
                                                          CGFloat endY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
                                                          CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
                                                          CGFloat tempY = endY - self.view.bounds.size.height;
                                                          CGRect tempF = CGRectMake(0, tempY, self.view.bounds.size.width, self.view.bounds.size.height);
                                                          self.view.frame = tempF;
                                                          [UIView animateWithDuration:duration animations:^{
                                                              [self.view setNeedsLayout];
                                                          }];
                                                      }];
}
#pragma mark getter methods
- (UITableView *)tableView
{
    if ( nil == _tableView )
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kBackground243Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - kInputViewHeight);
    }
    return _tableView;
}
- (UIView *)inputView
{
    if ( nil == _inputView )
    {
        _inputView = [FKLInputView fkl_inputView];
        _inputView.textField.delegate = self;
        _inputView.frame = CGRectMake(0, self.view.bounds.size.height - kInputViewHeight, self.view.bounds.size.width, kInputViewHeight);
    }
    return _inputView;
}
- (NSMutableArray *)chatMsgs
{
    if ( nil == _chatMsgs ) {
        _chatMsgs = [NSMutableArray array];
    }
    return _chatMsgs;
}
@end
