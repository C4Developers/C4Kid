//
//  DataViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/10/26.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "DataViewController.h"
#import "DataViewCell.h"


@interface DataViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,SendDataDelegate,AVAudioPlayerDelegate>
@property(nonatomic,strong)UICollectionView *dataView;
@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SendData shareData] addReceiveDelegate:self];
    [self loadUI];
}

#pragma mark - 加载UI
-(void)loadUI{
    self.navigationItem.title = @"数据显示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    @weakify(self);
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出该界面将无法接收数据,是否继续?" preferredStyle:UIAlertControllerStyleAlert];
         [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController popViewControllerAnimated:YES];
         }]];
         [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
         [self presentViewController:alert animated:YES completion:nil];
     }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self.view addSubview:self.dataView];
}

-(UICollectionView *)dataView{
    if (!_dataView) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(screenW/2, (screenH-topHeight)/2);
        
        _dataView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-topHeight) collectionViewLayout:layout];
        _dataView.dataSource = self;
        _dataView.delegate = self;
        _dataView.showsHorizontalScrollIndicator = NO;
        _dataView.showsVerticalScrollIndicator = NO;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"数据显示背景"]];
        bgImageView.frame = CGRectMake(0, 0, screenW, screenH-topHeight);
        _dataView.backgroundView = bgImageView;
        [_dataView registerClass:[DataViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DataViewCell class])];
    }
    return _dataView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DataViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DataViewCell class]) forIndexPath:indexPath];
    ModuleModel *module = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",(int)indexPath.row+1]].firstObject;
    [cell setCellWithIndex:(int)indexPath.row Module:module];
    [cell.controlButton addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 点击事件/指令接收
-(void)controlClick:(UIButton *)button{
    ModuleModel *module = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",(int)button.tag]].firstObject;
    if ([button.titleLabel.text isEqualToString:@"开始"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"指令" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *order in @[@"普通模式",@"认知模式"]) {
            [alert addAction:[UIAlertAction actionWithTitle:order style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([order isEqualToString:@"普通模式"]) {
                    [[SendData shareData] sendGamePackageInCha:module.cha Game:module.game mode:0];
                }
                else {
                    [[SendData shareData] sendGamePackageInCha:module.cha Game:module.game mode:1];
                }
            }]];
        }
        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if ([button.titleLabel.text isEqualToString:@"进行中"]) {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"指令" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        for (NSString *order in @[@"暂停",@"结束"]) {
            [alert addAction:[UIAlertAction actionWithTitle:order style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if ([order isEqualToString:@"暂停"]) {
                    [[SendData shareData] sendPauseGameInCha:module.cha];
                }
                else {
                    [[SendData shareData] sendStopGameInCha:module.cha];
                }
            }]];
        }
        UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
        popPresenter.sourceView = button;
        popPresenter.sourceRect = button.bounds;
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        //继续
        [[SendData shareData] sendStartGameInCha:module.cha];
    }
}

#pragma mark - 数据接收
-(void)receiveData:(NSDictionary *)data{
    ModuleModel *module = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%@",data[@"cha"]]].firstObject;
    DataViewCell *cell = (DataViewCell *)[self.dataView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[data[@"cha"] intValue]-1 inSection:0]];
    if ([data[@"api"] isEqualToString:@"setGamePag"]) {
        if ([data[@"flag"] isEqualToString:@"true"]) {
            [cell resetCell];
            [[SendData shareData] sendStartGameInCha:module.cha];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"游戏包错误"];
        }
    }
    else if ([data[@"api"] isEqualToString:@"startGame"]) {
        if ([data[@"flag"] isEqualToString:@"true"]) {
            [cell.controlButton setTitle:@"进行中" forState:UIControlStateNormal];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"模组%@游戏开始",module.cha]];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"游戏开始失败"];
        }
    }
    else if ([data[@"api"] isEqualToString:@"pauseGame"]) {
        if ([data[@"flag"] isEqualToString:@"true"]) {
            [cell.controlButton setTitle:@"继续" forState:UIControlStateNormal];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"游戏暂停失败"];
        }
    }
    else if ([data[@"api"] isEqualToString:@"stopGame"]) {
        if ([data[@"flag"] isEqualToString:@"true"]) {
            [cell.controlButton setTitle:@"开始" forState:UIControlStateNormal];
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"模组%@游戏结束",module.cha]];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"游戏结束失败"];
        }
    }
    else {
        [cell reloadCellWithModule:module Data:data];
    }
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
