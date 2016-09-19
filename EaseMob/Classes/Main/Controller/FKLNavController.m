//
//  FKLNavController.m
//  EaseMob
//
//  Created by kun on 16/9/10.
//  Copyright © 2016年 kun. All rights reserved.
//

/**
 1,navBar 背景色 － 黑色
 2，标题颜色 左右按钮 为白色
 3，修改状态栏显示为白色
 */

#import "FKLNavController.h"
#import "UINavigationBar+Awesome.h"

@interface FKLNavController ()

@end

@implementation FKLNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationBar lt_setBackgroundColor:[UIColor blackColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
