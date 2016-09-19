//
//  FKLChat.m
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLChat.h"
#import "NSString+YFTimestamp.h"
@interface FKLChat()
/** 文字聊天内容 */
@property (nonatomic, copy) NSString *contentText;
/** 详细大图 */
@property (nonatomic, strong) UIImage *contentIma;
/** 预览图 */
@property (nonatomic, strong) UIImage *contentThumbnailIma;
/** 详细大图的url */
@property (nonatomic, strong) NSURL *contentImaUrl;
/** 预览图的url */
@property (nonatomic, strong) NSURL *contentThumbnailImaUrl;
/** 是横预览还是竖预览 */
@property (nonatomic, assign, getter=isVertical) BOOL vertical;
/** 文字聊天背景 */
@property (nonatomic, strong) UIImage *contentTextBackgroundImage;
@property (nonatomic, strong) UIImage *contentTextBackgroundHLImage;
/** 头像urlStr */
@property (nonatomic, copy) NSString *userIcon;
/** timeStr */
@property (nonatomic, copy) NSString *timeStr;
/** 是否显示时间 */
@property (nonatomic, assign, getter=isShowTime) BOOL showTime;
/** 是我还是他 */
@property (nonatomic, assign, getter=isMe) BOOL me;
/** 聊天类型 */
@property (nonatomic, assign) FKLChatType chatType;
@end

@implementation FKLChat

+ (instancetype)fkl_chatWith:(EMMessage *)emsg preTimestamp:(long long)preTimestamp
{
    FKLChat *chat = [[FKLChat alloc] init];
    chat.preTimestamp = preTimestamp;
    chat.msg = emsg;
    return chat;
}

- (void)setMsg:(EMMessage *)msg
{
    _msg = msg;
    NSString *loginUser = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
    if ( [loginUser isEqualToString:msg.from] )
    {
        self.me = YES;
        self.userIcon = @"xhr";
        self.contentTextBackgroundImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
        self.contentTextBackgroundHLImage = [UIImage imageNamed:@"SenderTextNodeBkgHL"];
    }
    else
    {
        self.me = NO;
        self.userIcon = @"add_friend_icon_offical";
        self.contentTextBackgroundImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        self.contentTextBackgroundHLImage = [UIImage imageNamed:@"ReceiverTextNodeBkgHL"];
    }
    
    // 60 ＊ 1000 ＝ 1分钟
    self.showTime = ABS(msg.timestamp - self.preTimestamp) > 60000;
    self.timeStr = [NSString yf_convastionTimeStr:msg.timestamp];
    // 解析消息内容
    id<IEMMessageBody> msgBody = msg.messageBodies.firstObject;
    self.chatType = (FKLChatType)msgBody.messageBodyType;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 收到的文字消息
            NSString *txt = ((EMTextMessageBody *)msgBody).text;
            self.contentText = txt;
            break;
        }
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *body = (EMImageMessageBody *)msgBody;
            if ( [[NSFileManager defaultManager] fileExistsAtPath: body.localPath] )
            {
                self.contentIma = [UIImage imageWithContentsOfFile:body.localPath];
            }
            self.contentImaUrl = [NSURL URLWithString:body.remotePath];
            break;
        }
        case eMessageBodyType_File:
        {
            break;
        }
        default:
            break;
    }
}
@end
