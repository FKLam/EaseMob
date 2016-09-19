//
//  FKLInputView.m
//  EaseMob
//
//  Created by kun on 16/9/13.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLInputView.h"

@implementation FKLInputView

+ (instancetype)fkl_inputView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

@end
