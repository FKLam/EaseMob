//
//  ViewController.m
//  EaseMob
//
//  Created by kun on 16/9/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "FKLLogRegController.h"
#import "FKLTabBarController.h"

@interface FKLLogRegController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

@end

@implementation FKLLogRegController

+ (instancetype)fkl_logRegVC
{
    return [MainStoryBoard(@"Main") instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

#pragma mark - Register
- (IBAction)testRegister:(id)sender {
    [self test2];
}
- (void)test2 {
    [SVProgressHUD showWithStatus:@"注册中..."];
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.userName.text
                                                         password:self.passWord.text
                                                   withCompletion:^(NSString *username, NSString *password, EMError *error) {
                                                       [SVProgressHUD dismiss];
                                                       NSLog(@"%s, line = %d", __func__, __LINE__);
                                                       if ( !error )
                                                       {
                                                           // 注册成功
                                                           [JDStatusBarNotification showWithStatus:@"注册成功，请点击登陆" dismissAfter:2.5 styleName:JDStatusBarStyleSuccess];
                                                       }
                                                   }
                                                          onQueue:nil]; // 设置在哪个线程中执行
}

#pragma mark - Login
- (IBAction)testLogin:(id)sender {
    [SVProgressHUD showWithStatus:@"登录中..."];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.userName.text password:self.passWord.text completion:^(NSDictionary *loginInfo, EMError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"%s, line = %d", __func__, __LINE__);
        if ( !error ) {
            // 记录用户名
            [[NSUserDefaults standardUserDefaults] setObject:[[EaseMob sharedInstance].chatManager loginInfo][@"username"] forKey:@"username"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            // 在自动登录成功后设置自动登录
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
            // 切换根控制器为：tabVC
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [FKLTabBarController fkl_tabBarController];
            // 登录成功
            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:2.5 styleName:JDStatusBarStyleSuccess];
        }
    } onQueue:nil];
}


#pragma mark - Lift Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *lastUserName = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    if ( lastUserName )
        self.userName.text = lastUserName;
}

@end
