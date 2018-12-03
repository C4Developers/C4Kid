//
//  ConnectionViewController.m
//  C4gym
//
//  Created by Hinwa on 2017/9/26.
//  Copyright © 2017年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ConnectionViewController.h"
#import "ModuleViewController.h"

@interface ConnectionViewController ()
@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    //测试
//    ModuleViewController *moduleVC = [[ModuleViewController alloc] init];
//    [self.navigationController pushViewController:moduleVC animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 加载UI
-(void)loadUI{
    UIImageView * bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"连接背景"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    bgView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    UIButton *connection = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, W_ADAPTER(300), H_ADAPTER(80))];
    connection.layer.cornerRadius = 20;
    connection.center = CGPointMake(screenW/2, screenH/1.5);
    connection.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    [connection setTitle:@"连接" forState:UIControlStateNormal];
    @weakify(self);
    [[connection rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         [[SendData shareData] connectSocket:^(NSDictionary *data) {
             if ([data[@"connect"] isEqualToString:@"true"]) {
                 ModuleViewController *moduleVC = [[ModuleViewController alloc] init];
                 [self.navigationController pushViewController:moduleVC animated:YES];
                 [SVProgressHUD showInfoWithStatus:@"连接成功"];
             }
             else {
                 [SVProgressHUD showInfoWithStatus:@"连接失败"];
             }
         }];
     }];
    [bgView addSubview:connection];
}

-(void)dealloc{
    NSLog(@"%@销毁",[self class]);
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
