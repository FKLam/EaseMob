//
//  FKLLongPressBtn.m
//  EaseMob
//
//  Created by kun on 16/9/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLongPressBtn.h"

@implementation FKLLongPressBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if ( self )
    {
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPressGR.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPressGR];
    }
    return self;
}
- (void)longPress:(UILongPressGestureRecognizer *)sender
{
    if ( self.longPressBlock )
    {
        self.longPressBlock(self);
    }
}
@end
