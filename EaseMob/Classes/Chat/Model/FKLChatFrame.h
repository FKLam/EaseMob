//
//  FKLChatFrame.h
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTimeFont [UIFont systemFontOfSize:13.0]
#define kContentTextFont [UIFont systemFontOfSize:15.0]
#define kContentEdgeTop 15
#define kContentEdgeLeft 20
#define kContentEdgeBottom 25
#define kContentEdgeRight 20

@class FKLChat;
@interface FKLChatFrame : NSObject
/**  */
@property (nonatomic, strong) FKLChat *chat;

/** timeLabel */
@property (nonatomic, assign, readonly) CGRect timeFrame;
/** 头像frame */
@property (nonatomic, assign, readonly) CGRect iconFrame;
/** 内容frame */
@property (nonatomic, assign, readonly) CGRect contentFrame;
/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellH;
@end
