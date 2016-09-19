//
//  FKLContactCell.h
//  EaseMob
//
//  Created by kun on 16/9/12.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FKLContactCell : UITableViewCell
@property (nonatomic, strong) EMBuddy *buddy;
+ (instancetype)fkl_contactCellWithTableView:(UITableView *)tableView;

@end
