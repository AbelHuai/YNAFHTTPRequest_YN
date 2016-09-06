//
//  ViewController.m
//  YNAFHTTPRequest
//
//  Created by Abel on 16/9/5.
//  Copyright © 2016年 杨南. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequest.h"
#import "UIViewController+HUD.h"

#define TIMEOUT 20

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableDictionary *jsonData = [[NSMutableDictionary alloc]init];
    [self showHudInView:self.view hint:@""];
    [[AFHTTPRequest sharedInstance] ASyncPOST:@"" andParameters:jsonData andUserInfo:nil andTimeOut:TIMEOUT success:^(BOOL success, NSString *msg,id responseObject) {
        NSLog(@"data = %@",responseObject);
        [self hideHud];
        if (success) {
            [self showHint:@"成功"  yOffset:-150];
        }else{
            [self showHint:msg];
        }
    } failure:^(NSString *msg) {
        [self hideHud];
        [self showHint:msg];
      
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
