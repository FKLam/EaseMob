//
//  FKLMeController.m
//  EaseMob
//
//  Created by kun on 16/9/11.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLMeController.h"

@interface FKLMeController ()
// 静态cell中如果自定义cell的类，是不可以直接拖线的，但是你可以写好拖线代码，从文件中反向拖入xib／storyboard中
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation FKLMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.userName.text = [[EaseMob sharedInstance].chatManager loginInfo][@"username"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
