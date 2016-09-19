//
//  FKLChatFrame.m
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

/**
 1，修改背景色
 
 2，将cell的选中状态和分隔线取消
 
 3，整改内容button的边距
 
 */

#import "FKLChatFrame.h"
#import "FKLChat.h"

@interface FKLChatFrame()

/** timeLabel */
@property (nonatomic, assign) CGRect timeFrame;
/** 头像frame */
@property (nonatomic, assign) CGRect iconFrame;
/** 内容frame */
@property (nonatomic, assign) CGRect contentFrame;
/** cell的高度 */
@property (nonatomic, assign) CGFloat cellH;
@end
@implementation FKLChatFrame

- (void)setChat:(FKLChat *)chat
{
    _chat = chat;
    
    CGFloat screenW = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat margin = 5;
    
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    CGFloat timeW = 0;
    CGFloat timeH = chat.isShowTime ? 20.0 : 0;
    CGSize timeStrSize = [chat.timeStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, timeH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kTimeFont} context:nil].size;
    timeW = timeStrSize.width + 5;
    timeX = (screenW - timeW) * 0.5;
    self.timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat iconX = 0;
    CGFloat iconY = margin + CGRectGetMaxY(self.timeFrame);
    CGFloat iconW = 44;
    CGFloat iconH = iconW;
    
    CGFloat contentX = 0;
    CGFloat contentY = iconY;
    CGFloat contentW = 0;
    CGFloat contentH = 0;
    switch (chat.chatType) {
        case FKLChatTypeText:
        {
            CGFloat contentMaxW = screenW - 2 * (margin + iconW);
            CGSize contentStrSize = [chat.contentText boundingRectWithSize:CGSizeMake(contentMaxW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kContentTextFont} context:nil].size;
            contentW = contentStrSize.width + kContentEdgeLeft + kContentEdgeRight;
            contentH = contentStrSize.height + kContentEdgeTop + kContentEdgeBottom;
            break;
        }
        case FKLChatTypeImage:
        {
            if ( chat.isVertical )
            {
                contentW = 200;
                contentH = 100;
            }
            else
            {
                contentW = 100;
                contentH = 200;
            }
            break;
        }
        case FKLChatTypeVoice:
        {
            break;
        }
        case FKLChatTypeLocation:
        {
            break;
        }
        case FKLChatTypeVideo:
        {
            break;
        }
        case FKLChatTypeFile:
        {
            break;
        }
            
        default:
            break;
    }
    if ( chat.isMe )
    {
        iconX = screenW - iconW - margin;
        contentX = iconX - margin - contentW;
    }
    else
    {
        iconX = margin;
        contentX = iconX + iconW + margin;
    }
    self.iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    self.contentFrame = CGRectMake(contentX, contentY, contentW, contentH);
    
    self.cellH = ( contentH > iconH ) ? CGRectGetMaxY(self.contentFrame) + margin : CGRectGetMaxY(self.iconFrame) + margin;
}

@end
