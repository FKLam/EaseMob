//
//  FKLChatCell.m
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLChatCell.h"
#import "FKLLongPressBtn.h"
#import "FKLChatFrame.h"
#import "FKLChat.h"
#import "UIImage+YFResizing.h"

@interface FKLChatCell()
/** timeLabel */
@property (nonatomic, strong) UILabel *timeLab;
/** 头像 */
@property (nonatomic, strong) FKLLongPressBtn *userIconBtn;
/** 聊天内容 */
@property (nonatomic, strong) FKLLongPressBtn *contentBtn;
@end

@implementation FKLChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.contentView.backgroundColor = kBackground243Color;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 添加子控件
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.userIconBtn];
        [self.contentView addSubview:self.contentBtn];
    }
    return self;
}

- (void)setChatFrame:(FKLChatFrame *)chatFrame
{
    _chatFrame = chatFrame;
    FKLChat *chat = chatFrame.chat;
    
    self.timeLab.text = chat.timeStr;
    // 如果时真实开发，此处应该使用SDWebImage根据URL取图片
    [self.userIconBtn setImage:[UIImage imageNamed:chat.userIcon] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage yf_resizingWithIma:chat.contentTextBackgroundImage] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage yf_resizingWithIma:chat.contentTextBackgroundHLImage] forState:UIControlStateHighlighted];
    switch (chat.chatType) {
        case FKLChatTypeText:
        {
            
        }
            break;
        case FKLChatTypeImage:
        {
            
        }
            break;
        default:
            break;
    }
    if ( chat.contentThumbnailIma )
    {
        [self.contentBtn setImage:chat.contentThumbnailIma forState:UIControlStateNormal];
    }
    else
    {
        // 用SDWebImage进行btn的赋值
    }
    [self.contentBtn setTitle:chat.contentText forState:UIControlStateNormal];
}
- (void)fkl_showDetailUserInfo
{
    
}
- (void)fkl_contentChatTouchUpInside
{
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLab.frame = self.chatFrame.timeFrame;
    self.userIconBtn.frame = self.chatFrame.iconFrame;
    self.contentBtn.frame = self.chatFrame.contentFrame;
}

- (UILabel *)timeLab
{
    if ( nil == _timeLab )
    {
        _timeLab = [[UILabel alloc] init];
        _timeLab.backgroundColor = [UIColor grayColor];
        _timeLab.textColor = [UIColor whiteColor];
        _timeLab.font = kTimeFont;
        _timeLab.layer.cornerRadius = 5;
        _timeLab.clipsToBounds = YES;
        _timeLab.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLab;
}
- (FKLLongPressBtn *)userIconBtn
{
    if ( nil == _userIconBtn )
    {
        _userIconBtn = [[FKLLongPressBtn alloc] init];
        _userIconBtn.longPressBlock = ^(FKLLongPressBtn *btn) {
            // 长按时的业务逻辑处理
        };
        [_userIconBtn addTarget:self action:@selector(fkl_showDetailUserInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userIconBtn;
}
- (FKLLongPressBtn *)contentBtn
{
    if ( nil == _contentBtn )
    {
        _contentBtn = [[FKLLongPressBtn alloc] init];
        _contentBtn.longPressBlock = ^(FKLLongPressBtn *btn) {
            // 长按时的业务逻辑处理
        };
        _contentBtn.titleLabel.font = kContentTextFont;
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _contentBtn.titleLabel.numberOfLines = 0;
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentEdgeTop, kContentEdgeLeft, kContentEdgeBottom, kContentEdgeRight);
        [_contentBtn addTarget:self action:@selector(fkl_contentChatTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentBtn;
}
@end
