//
//  CustomViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "CustomViewController.h"
#import "CustomProcessCell.h"
#import "FloorViewCell.h"
#import "ColorViewCell.h"

@interface CustomViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UITableView *processView;
@property(nonatomic,strong)UITableView *floorView;
@property(nonatomic,strong)UICollectionView *colorView;
@property(nonatomic,strong)NSMutableArray *processArr;
@property(nonatomic,strong)NSMutableArray *floorArr;
@property(nonatomic,strong)UIButton *numberButton;
@property(nonatomic,strong)UIButton *typeButton;
@property(nonatomic,strong)UIButton *timeButton;
@property(nonatomic,strong)UIButton *currentColor;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self loadUI];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    ColorViewCell *cell = (ColorViewCell *)[self.colorView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.colorButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma marl - 获取数据
-(void)createData{
    self.floorArr = [NSMutableArray array];
    self.processArr = [NSMutableArray array];
    if (self.game.playerData.length>0) {
        //编辑
        NSArray *stepArr = [Tool creatArrWithJSONString:self.game.playerData].firstObject;
        for (NSDictionary *dict in stepArr) {
            [self.processArr addObject:[StepModel dataModelWithDict:dict]];
        }
    }
}

#pragma mark - 加载UI
-(void)loadUI{
    self.navigationItem.title = @"课程编辑";
    
    UIImageView * bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"自定义背景"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    bgView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 35)];
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    finishButton.layer.borderWidth = 1;
    finishButton.layer.borderColor = [UIColor blackColor].CGColor;
    finishButton.layer.cornerRadius = 10;
    [finishButton addTarget:self action:@selector(finishClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *finishItem = [[UIBarButtonItem alloc] initWithCustomView:finishButton];
    self.navigationItem.rightBarButtonItem = finishItem;
    
    [bgView addSubview:self.processView];
    self.processView.sd_layout
    .topSpaceToView(bgView, 2)
    .leftSpaceToView(bgView, 2)
    .bottomSpaceToView(bgView, H_ADAPTER(200)+2)
    .rightSpaceToView(bgView, screenW/2+2);
    
    [bgView addSubview:self.floorView];
    self.floorView.sd_layout
    .topEqualToView(self.processView)
    .leftSpaceToView(self.processView, 4)
    .rightSpaceToView(bgView, 2)
    .bottomEqualToView(self.processView);
    
    [bgView addSubview:self.colorView];
    self.colorView.sd_layout
    .topSpaceToView(self.processView, 4)
    .leftEqualToView(self.processView)
    .bottomSpaceToView(bgView, 2)
    .rightEqualToView(self.processView);
    
    self.typeButton = [[UIButton alloc] init];
    self.typeButton.backgroundColor = [UIColor whiteColor];
    [self.typeButton setTitle:@"正常" forState:UIControlStateNormal];
    self.typeButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
    [self.typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.typeButton.layer.borderWidth = 1;
    self.typeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.typeButton.layer.cornerRadius = 10;
    [self.typeButton addTarget:self action:@selector(typeClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.typeButton];
    self.typeButton.sd_layout
    .topSpaceToView(self.floorView, H_ADAPTER(30))
    .leftSpaceToView(self.colorView, W_ADAPTER(80))
    .widthIs(W_ADAPTER(150))
    .heightIs(H_ADAPTER(60));
    
    self.timeButton = [[UIButton alloc] init];
    self.timeButton.backgroundColor = [UIColor whiteColor];
    [self.timeButton setTitle:@"0s" forState:UIControlStateNormal];
    self.timeButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
    [self.timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.timeButton.layer.borderWidth = 1;
    self.timeButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.timeButton.layer.cornerRadius = 10;
    [self.timeButton addTarget:self action:@selector(timeClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.timeButton];
    self.timeButton.sd_layout
    .topEqualToView(self.typeButton)
    .leftSpaceToView(self.typeButton, W_ADAPTER(60))
    .widthRatioToView(self.typeButton, 1)
    .heightRatioToView(self.typeButton, 1);
    
    self.numberButton = [[UIButton alloc] init];
    self.numberButton.backgroundColor = [UIColor whiteColor];
    if (self.game.number.length>0) {
        [self.numberButton setTitle:[NSString stringWithFormat:@"%@组",self.game.number] forState:UIControlStateNormal];
    }
    else {
        [self.numberButton setTitle:@"组数" forState:UIControlStateNormal];
    }
    self.numberButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
    [self.numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.numberButton.layer.borderWidth = 1;
    self.numberButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.numberButton.layer.cornerRadius = 10;
    [self.numberButton addTarget:self action:@selector(numberClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.numberButton];
    self.numberButton.sd_layout
    .topSpaceToView(self.typeButton, H_ADAPTER(20))
    .leftEqualToView(self.typeButton)
    .widthRatioToView(self.typeButton, 1)
    .heightRatioToView(self.typeButton, 1);
    
    UIButton *joinButton = [[UIButton alloc] init];
    joinButton.backgroundColor = [UIColor whiteColor];
    [joinButton setTitle:@"加入步骤" forState:UIControlStateNormal];
    joinButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(20)];
    [joinButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    joinButton.layer.borderWidth = 1;
    joinButton.layer.borderColor = [UIColor blackColor].CGColor;
    joinButton.layer.cornerRadius = 10;
    [joinButton addTarget:self action:@selector(joinClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:joinButton];
    joinButton.sd_layout
    .topEqualToView(self.numberButton)
    .leftEqualToView(self.timeButton)
    .widthRatioToView(self.typeButton, 1)
    .heightRatioToView(self.typeButton, 1);
}

-(UICollectionView *)colorView{
    if (!_colorView) {
        UICollectionViewFlowLayout * layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(W_ADAPTER(100), H_ADAPTER(100));
        
        _colorView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colorView.delegate = self;
        _colorView.dataSource = self;
        _colorView.showsVerticalScrollIndicator = NO;
        _colorView.showsHorizontalScrollIndicator = NO;
        _colorView.backgroundColor = [UIColor clearColor];
        _colorView.layer.borderWidth = 2;
        _colorView.layer.borderColor = [UIColor blackColor].CGColor;
        _colorView.layer.cornerRadius = 5;
        [_colorView registerClass:[ColorViewCell class] forCellWithReuseIdentifier:NSStringFromClass([ColorViewCell class])];
    }
    return _colorView;
}

-(UITableView *)processView{
    if (!_processView) {
        _processView = [[UITableView alloc] init];
        _processView.delegate = self;
        _processView.dataSource = self;
        _processView.showsVerticalScrollIndicator = NO;
        _processView.showsHorizontalScrollIndicator = NO;
        _processView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _processView.rowHeight = H_ADAPTER(80);
        _processView.backgroundColor = [UIColor clearColor];
        _processView.layer.borderWidth = 2;
        _processView.layer.borderColor = [UIColor blackColor].CGColor;
        _processView.layer.cornerRadius = 5;
    }
    return _processView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ColorViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ColorViewCell class]) forIndexPath:indexPath];
    [cell setCellWithIndex:(int)indexPath.row];
    [cell.colorButton addTarget:self action:@selector(colorClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(UITableView *)floorView{
    if (!_floorView) {
        _floorView = [[UITableView alloc] init];
        _floorView.delegate = self;
        _floorView.dataSource = self;
        _floorView.showsVerticalScrollIndicator = NO;
        _floorView.showsHorizontalScrollIndicator = NO;
        _floorView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _floorView.rowHeight = H_ADAPTER(95);
        _floorView.backgroundColor = [UIColor clearColor];
        _floorView.layer.borderWidth = 2;
        _floorView.layer.borderColor = [UIColor blackColor].CGColor;
        _floorView.layer.cornerRadius = 5;
    }
    return _floorView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenW/2, H_ADAPTER(40))];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
    sectionLabel.textColor = [UIColor blackColor];
    if (tableView == self.processView) {
        sectionLabel.text = @"课程顺序";
    }
    else {
        sectionLabel.text = @"地板选择";
    }
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return H_ADAPTER(40);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.processView) {
        return self.processArr.count;
    }
    else {
        return [self.game.floorCount intValue];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.processView) {
        CustomProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomProcessCell class])];
        if (cell == nil) {
            cell = [[CustomProcessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([CustomProcessCell class])];
        }
        [cell setCellWithModel:self.processArr[indexPath.row]];
        return cell;
    }
    else {
        FloorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FloorViewCell class])];
        if (cell == nil) {
            cell = [[FloorViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([FloorViewCell class])];
        }
        [cell setCellWithIndex:(int)indexPath.row Model:self.module Arr:self.floorArr];
        return cell;
    }
}

#pragma mark - 列表点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.processView) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该步骤?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.processArr removeObjectAtIndex:indexPath.row];
            [self.processView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        NSNumber *number = [NSNumber numberWithInt:(int)indexPath.row+1];
        if ([self.floorArr containsObject:number]) {
            [self.floorArr removeObject:number];
            [self.floorView reloadData];
        }
        else{
            [self.floorArr addObject:number];
            [self.floorView reloadData];
        }
    }
}

#pragma mark - 颜色点击
-(void)colorClick:(UIButton *)button{
    self.currentColor.selected = NO;
    button.selected = YES;
    self.currentColor = button;
}

#pragma mark 亮灯类型
-(void)typeClick:(UIButton *)button{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"正常" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    for (NSString *type in @[@"正常",@"呼吸灯",@"常亮"]) {
//        [alert addAction:[UIAlertAction actionWithTitle:type style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [self.typeButton setTitle:type forState:UIControlStateNormal];
//        }]];
//    }
    for (NSString *type in @[@"正常",@"呼吸灯"]) {
        [alert addAction:[UIAlertAction actionWithTitle:type style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.typeButton setTitle:type forState:UIControlStateNormal];
        }]];
    }
    UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 间隔时间
-(void)timeClick:(UIButton *)button{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"间隔时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i <= 10; i++) {
        NSString *title = [NSString stringWithFormat:@"%ds",i];
        [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.timeButton setTitle:title forState:UIControlStateNormal];
        }]];
    }
    UIPopoverPresentationController * popPresenter = [alert popoverPresentationController];
    popPresenter.sourceView = button;
    popPresenter.sourceRect = button.bounds;
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 组数设置
-(void)numberClick:(UIButton *)button{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"组数设置" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
    }];
    alert.textFields.firstObject.placeholder = @"请输入组数";
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (alert.textFields.firstObject.text.length>0) {
            [button setTitle:[NSString stringWithFormat:@"%@组",alert.textFields.firstObject.text] forState:UIControlStateNormal];
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"请输入正确组数"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 加入步骤
-(void)joinClick{
    if (self.floorArr.count>0) {
        if ([self.typeButton.titleLabel.text isEqualToString:@"呼吸灯"]&&self.floorArr.count>1) {
            [SVProgressHUD showInfoWithStatus:@"呼吸灯不可多选"];
        }
        else{
            [self.processArr addObject:[StepModel addStepWithColor:(int)self.currentColor.tag Type:self.typeButton.titleLabel.text Time:self.timeButton.titleLabel.text FloorID:self.floorArr]];
            [self.processView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.processArr.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.processView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.processArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            [self.floorArr removeAllObjects];
            [self.floorView reloadData];
        }
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择地板"];
    }
}

#pragma mark - 完成点击
-(void)finishClick{
    if (self.processArr.count>0) {
        if (![self.numberButton.titleLabel.text isEqualToString:@"组数"]) {
            if (self.game.playerData.length>0) {
                [self.game createGameWithName:self.game.gameName Number:[self.numberButton.titleLabel.text substringToIndex:self.numberButton.titleLabel.text.length-1] Process:self.processArr];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishEdit" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    textField.returnKeyType = UIReturnKeyDone;
                    textField.delegate = self;
                }];
                alert.textFields.firstObject.placeholder = @"请输入训练名";
                [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (alert.textFields.firstObject.text.length>0) {
                        RLMResults * results = [GameModel objectsWhere:@"floorCount = %@ AND gameName = %@",self.game.floorCount,alert.textFields.firstObject.text];
                        if (results.count>0) {
                            [SVProgressHUD showInfoWithStatus:@"已存在该训练名"];
                        }
                        else {
                            [self.game createGameWithName:alert.textFields.firstObject.text Number:[self.numberButton.titleLabel.text substringToIndex:self.numberButton.titleLabel.text.length-1] Process:self.processArr];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"finishEdit" object:nil];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                    else {
                        [SVProgressHUD showInfoWithStatus:@"请输入正确训练名"];
                    }
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"请输入正确组数"];
        }
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请编辑自定义步骤"];
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
