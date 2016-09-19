//
//  FKLSettingController.m
//  EaseMob
//
//  Created by kun on 16/9/11.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLSettingController.h"
#import "FKLLogRegController.h"

@interface FKLSettingController ()

@end

@implementation FKLSettingController
- (IBAction)logout:(id)sender {
    [SVProgressHUD showWithStatus:@"登录中..."];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        [SVProgressHUD dismiss];
        if ( !error ) {
            NSLog(@"%s, line = %d", __func__, __LINE__);
            // 切换成登录注册控制器
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [FKLLogRegController fkl_logRegVC];
            // 登录成功
            [JDStatusBarNotification showWithStatus:@"账号已退出" dismissAfter:2.5 styleName:JDStatusBarStyleWarning];
        }
    } onQueue:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
