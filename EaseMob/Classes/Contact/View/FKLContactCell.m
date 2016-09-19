//
//  FKLContactCell.m
//  EaseMob
//
//  Created by kun on 16/9/12.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLContactCell.h"

@interface FKLContactCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation FKLContactCell

+ (instancetype)fkl_contactCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = nil;
    if ( nil == ID ) {
        ID = [NSString stringWithFormat:@"%@ID", NSStringFromClass(self)];
    }
    static UITableView *tableV = nil;
    if ( ![tableView isEqual:tableV] ) {
        tableV = tableView;
    }
    FKLContactCell *cell = [tableV dequeueReusableCellWithIdentifier:ID];
    if ( !cell )
    {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setBuddy:(EMBuddy *)buddy
{
    _buddy = buddy;
    self.userName.text = buddy.username;
    self.userIcon.image = [UIImage imageNamed:@"xhr"];
}

@end
