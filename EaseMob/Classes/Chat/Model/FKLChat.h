//
//  FKLChat.h
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    FKLChatTypeText = eMessageBodyType_Text,
    FKLChatTypeImage = eMessageBodyType_Image,
    FKLChatTypeLocation = eMessageBodyType_Location,
    FKLChatTypeVoice = eMessageBodyType_Voice,
    FKLChatTypeVideo = eMessageBodyType_Video,
    FKLChatTypeFile = eMessageBodyType_File,
} FKLChatType;

@interface FKLChat : NSObject

+ (instancetype)fkl_chatWith:(EMMessage *)emsg preTimestamp:(long long)preTimestamp;

/** 聊天消息对象 */
@property (nonatomic, strong) EMMessage *msg;
/** 上一条聊天记录的时间 */
@property (nonatomic, assign) long long preTimestamp;
/** 文字聊天内容 */
@property (nonatomic, copy, readonly) NSString *contentText;

/** 详细大图 */
@property (nonatomic, strong, readonly) UIImage *contentIma;
/** 预览图 */
@property (nonatomic, strong, readonly) UIImage *contentThumbnailIma;
/** 详细大图的url */
@property (nonatomic, strong, readonly) NSURL *contentImaUrl;
/** 预览图的url */
@property (nonatomic, strong, readonly) NSURL *contentThumbnailImaUrl;
/** 是横预览还是竖预览 */
@property (nonatomic, assign, getter=isVertical, readonly) BOOL vertical;

/** 文字聊天背景 */
@property (nonatomic, strong, readonly) UIImage *contentTextBackgroundImage;
@property (nonatomic, strong, readonly) UIImage *contentTextBackgroundHLImage;
/** 头像urlStr */
@property (nonatomic, copy, readonly) NSString *userIcon;
/** timeStr */
@property (nonatomic, copy, readonly) NSString *timeStr;
/** 是否显示时间 */
@property (nonatomic, assign, getter=isShowTime, readonly) BOOL showTime;
/** 是我还是他 */
@property (nonatomic, assign, getter=isMe, readonly) BOOL me;
/** 聊天类型 */
@property (nonatomic, assign, readonly) FKLChatType chatType;
@end
