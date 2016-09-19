//
//  FKLLongPressBtn.h
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FKLLongPressBtn;
typedef void(^FKLLongPressBlock)(FKLLongPressBtn *btn);
@interface FKLLongPressBtn : UIButton
/** 长按block */
@property (nonatomic, strong) FKLLongPressBlock longPressBlock;
@end
