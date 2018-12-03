//
//  ModuleViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/10/22.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "ModuleViewController.h"
#import "ModuleViewCell.h"
#import "SurfaceViewController.h"
#import "GameViewController.h"
#import "DataViewController.h"

@interface ModuleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *moduleView;
@end

@implementation ModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self loadUI];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"finishGame" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self.moduleView reloadData];
    }];
}

-(void)createData{
    if ([ModuleModel allObjects].count<=0) {
        [[RLMRealm defaultRealm] beginWriteTransaction];
        for(int i = 0; i < 4; i++){
            NSString * cha = [NSString stringWithFormat:@"%d",i+1];
            ModuleModel * model = [[ModuleModel alloc] initWithCha:cha];
            [[RLMRealm defaultRealm] addOrUpdateObject:model];
        }
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

-(void)loadUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"C4GYM";
    
    UIButton * settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    settingButton.layer.borderWidth = 1;
    settingButton.layer.borderColor = [UIColor blackColor].CGColor;
    settingButton.layer.cornerRadius = 10;
    settingButton.titleLabel.font = [UIFont systemFontOfSize:W_ADAPTER(15)];
    [settingButton setTitle:@"设置" forState:UIControlStateNormal];
    [settingButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[settingButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         UIAlertController * resetAlert = [UIAlertController alertControllerWithTitle:@"设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
         [resetAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
         for (int i = 0; i<4; i++) {
             [resetAlert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"模组%d",i+1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [[SendData shareData] sendSetIDInCha:[NSString stringWithFormat:@"%d",i+1] Receive:^(NSDictionary *data) {
                     if ([data[@"api"] isEqualToString:@"setId"]&&
                         [data[@"flag"] isEqualToString:@"true"]) {
                         [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"重置模组%d成功",i+1]];
                     }
                     else {
                         [SVProgressHUD showInfoWithStatus:@"重置模组失败"];
                     }
                 }];
             }]];
         }
         [self presentViewController:resetAlert animated:YES completion:nil];
     }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    
    UIButton * showButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    showButton.layer.borderWidth = 1;
    showButton.layer.borderColor = [UIColor blackColor].CGColor;
    showButton.layer.cornerRadius = 10;
    showButton.titleLabel.font = [UIFont systemFontOfSize:W_ADAPTER(15)];
    [showButton setTitle:@"数据" forState:UIControlStateNormal];
    [showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[showButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         DataViewController *dataVC = [[DataViewController alloc] init];
         [self.navigationController pushViewController:dataVC animated:YES];
     }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:showButton];
    
    [self.view addSubview:self.moduleView];
}

#pragma mark - 模组视图
-(UICollectionView *)moduleView{
    if (!_moduleView) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(screenW/2, (screenH-topHeight)/2);
        
        _moduleView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenW, screenH-topHeight) collectionViewLayout:layout];
        _moduleView.dataSource = self;
        _moduleView.delegate = self;
        _moduleView.showsHorizontalScrollIndicator = NO;
        _moduleView.showsVerticalScrollIndicator = NO;
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"模组设置背景"]];
        bgImageView.frame = CGRectMake(0, 0, screenW, screenH-topHeight);
        _moduleView.backgroundView = bgImageView;
        [_moduleView registerClass:[ModuleViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ModuleViewCell class])];
    }
    return _moduleView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ModuleViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ModuleViewCell class]) forIndexPath:indexPath];
    [cell setCellWithIndex:(int)indexPath.row];
    [cell.moduleButton addTarget:self action:@selector(moduleClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.surfaceButton addTarget:self action:@selector(surfaceClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.gameButton addTarget:self action:@selector(gameClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 模组点击
-(void)moduleClick:(UIButton *)button{
    ModuleModel *model = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",(int)button.tag+1]].firstObject;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请输入地板个数" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    alert.textFields.firstObject.placeholder = @"请输入地板个数";
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.length>0) {
            [[RLMRealm defaultRealm] beginWriteTransaction];
            model.floorCount = alert.textFields.firstObject.text;
            [[RLMRealm defaultRealm] commitWriteTransaction];
            [self.moduleView reloadData];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"请输入正确地板个数"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 面层点击
-(void)surfaceClick:(UIButton *)button{
    ModuleModel *model = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",(int)button.tag+1]].firstObject;
    if ([model.floorCount intValue] >0) {
        SurfaceViewController *surfaceVC = [[SurfaceViewController alloc] init];
        surfaceVC.model = model;
        [self.navigationController pushViewController:surfaceVC animated:YES];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请输入地板个数"];
    }
}

#pragma mark 课程点击
-(void)gameClick:(UIButton *)button{
    ModuleModel *model = [ModuleModel objectsWhere:@"cha = %@",[NSString stringWithFormat:@"%d",(int)button.tag+1]].firstObject;
    if ([model.floorCount intValue] >0) {
        GameViewController *gameVC = [[GameViewController alloc] init];
        gameVC.model = model;
        [self.navigationController pushViewController:gameVC animated:YES];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请输入地板个数"];
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
