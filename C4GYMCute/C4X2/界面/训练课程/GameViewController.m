//
//  GameViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "GameViewController.h"
#import "GameViewCell.h"
#import "CustomViewController.h"
#import "GameProcessCell.h"

@interface GameViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *gameView;
@property(nonatomic,strong)UITableView *processView;
@property(nonatomic,strong)NSMutableArray *gameArr;
@property(nonatomic,assign)int currenIndex;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currenIndex = 9999;
    [self createData];
    [self loadUI];
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"finishEdit" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self);
        [self createData];
        [self.gameView reloadData];
        [self.processView reloadData];
    }];
}

#pragma mark - 获取数据
-(void)createData{
    self.gameArr = [NSMutableArray array];
    for (GameModel *model in [GameModel objectsWhere:@"floorCount = %@",self.model.floorCount]) {
        [self.gameArr addObject:model];
    }
}

#pragma mark - 加载UI
-(void)loadUI{
    self.navigationItem.title = @"训练课程";
    
    UIImageView * bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"训练课程背景"];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    bgView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    UIButton *deleteButton = [[UIButton alloc] init];
    deleteButton.layer.cornerRadius = 10;
    deleteButton.backgroundColor = [UIColor whiteColor];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleteButton];
    deleteButton.sd_layout
    .bottomSpaceToView(bgView, H_ADAPTER(30))
    .rightSpaceToView(bgView, W_ADAPTER(40))
    .widthIs(W_ADAPTER(250))
    .heightIs(H_ADAPTER(60));
    
    UIButton *editButton = [[UIButton alloc] init];
    editButton.layer.cornerRadius = 10;
    editButton.backgroundColor = [UIColor whiteColor];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    @weakify(self);
    [[editButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.currenIndex != 9999) {
             CustomViewController *customVC = [[CustomViewController alloc] init];
             customVC.game = self.gameArr[self.currenIndex];
             customVC.module = self.model;
             [self.navigationController pushViewController:customVC animated:YES];
         }
         else {
             [SVProgressHUD showInfoWithStatus:@"请选择课程"];
         }
     }];
    [bgView addSubview:editButton];
    editButton.sd_layout
    .rightSpaceToView(deleteButton, W_ADAPTER(50))
    .bottomEqualToView(deleteButton)
    .widthRatioToView(deleteButton, 1)
    .heightRatioToView(deleteButton, 1);
    
    UIButton *selectButton = [[UIButton alloc] init];
    selectButton.layer.cornerRadius = 10;
    selectButton.backgroundColor = [UIColor whiteColor];
    [selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.currenIndex == 9999) {
             [SVProgressHUD showInfoWithStatus:@"请选择课程"];
         }
         else {
             [[RLMRealm defaultRealm] beginWriteTransaction];
             GameModel *gameModel = self.gameArr[self.currenIndex];
             self.model.game = gameModel;
             [[RLMRealm defaultRealm] commitWriteTransaction];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGame" object:nil];
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
    [bgView addSubview:selectButton];
    selectButton.sd_layout
    .leftEqualToView(editButton)
    .rightEqualToView(editButton)
    .bottomSpaceToView(deleteButton, H_ADAPTER(40))
    .heightRatioToView(deleteButton, 1);
    
    UIButton *createButton = [[UIButton alloc] init];
    createButton.layer.cornerRadius = 10;
    createButton.backgroundColor = [UIColor whiteColor];
    [createButton setTitle:@"创建" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [[createButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         CustomViewController *customVC = [[CustomViewController alloc] init];
         customVC.game = [[GameModel alloc] initWithFloorCount:self.model.floorCount];
         customVC.module = self.model;
         [self.navigationController pushViewController:customVC animated:YES];
     }];
    [bgView addSubview:createButton];
    createButton.sd_layout
    .leftEqualToView(deleteButton)
    .rightEqualToView(deleteButton)
    .bottomSpaceToView(deleteButton, H_ADAPTER(40))
    .heightRatioToView(deleteButton, 1);
    
    [bgView addSubview:self.gameView];
    self.gameView.sd_layout
    .topSpaceToView(bgView, 0)
    .leftSpaceToView(bgView, 0)
    .bottomSpaceToView(bgView, 0)
    .widthIs(W_ADAPTER(400));

    [bgView addSubview:self.processView];
    self.processView.sd_layout
    .leftEqualToView(editButton)
    .rightEqualToView(deleteButton)
    .bottomSpaceToView(selectButton, H_ADAPTER(40))
    .topSpaceToView(bgView, H_ADAPTER(40));
}

-(UITableView *)gameView{
    if (!_gameView) {
        _gameView = [[UITableView alloc] init];
        _gameView.delegate = self;
        _gameView.dataSource = self;
        _gameView.showsVerticalScrollIndicator = NO;
        _gameView.showsHorizontalScrollIndicator = NO;
        _gameView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _gameView.rowHeight = H_ADAPTER(80);
        _gameView.backgroundColor = [UIColor clearColor];
        _gameView.layer.borderWidth = 2;
        _gameView.layer.borderColor = [UIColor whiteColor].CGColor;
        _gameView.layer.cornerRadius = 5;
    }
    return _gameView;
}

-(UITableView *)processView{
    if (!_processView) {
        _processView = [[UITableView alloc] init];
        _processView.delegate = self;
        _processView.dataSource = self;
        _processView.showsVerticalScrollIndicator = NO;
        _processView.showsHorizontalScrollIndicator = NO;
        _processView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _processView.rowHeight = H_ADAPTER(95);
        _processView.layer.cornerRadius = 10;
    }
    return _processView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return H_ADAPTER(40);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W_ADAPTER(400), H_ADAPTER(40))];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
    sectionLabel.textColor = [UIColor blackColor];
    if (tableView == self.gameView) {
        sectionLabel.text = @"自定义课程";
    }
    else {
        sectionLabel.text = @"课程内容";
    }
    return sectionLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.gameView) {
        return self.gameArr.count;
    }
    else {
        if (self.currenIndex != 9999) {
            GameModel *model = self.gameArr[self.currenIndex];
            NSArray *stepArr = [Tool creatArrWithJSONString:model.playerData].firstObject;
            return stepArr.count;
        }
        else {
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.gameView) {
        GameViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GameViewCell class])];
        if (cell == nil) {
            cell = [[GameViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([GameViewCell class])];
        }
        GameModel *model = self.gameArr[indexPath.row];
        [cell setCellWithName:model.gameName Index:(int)indexPath.row Current:self.currenIndex];
        return cell;
    }
    else {
        GameProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GameProcessCell class])];
        if (cell == nil) {
            cell = [[GameProcessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([GameProcessCell class])];
        }
        GameModel *model = self.gameArr[self.currenIndex];
        NSArray *stepArr = [Tool creatArrWithJSONString:model.playerData].firstObject;
        [cell setCellWithModel:[StepModel dataModelWithDict:stepArr[indexPath.row]]];
        return cell;
    }
}

#pragma mark - 删除点击
-(void)deleteClick{
    if (self.currenIndex != 9999) {
        GameModel * gameModel = self.gameArr[self.currenIndex];
        if ([self.model.game.gameName isEqualToString:gameModel.gameName]) {
            [SVProgressHUD showInfoWithStatus:@"该课程正在使用，无法删除"];
        }
        else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该训练?" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObject:gameModel];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                [self createData];
                self.currenIndex = 9999;
                [self.gameView reloadData];
                [self.processView reloadData];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择课程"];
    }
}

#pragma mark - 课程点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currenIndex = (int)indexPath.row;
    [self.gameView reloadData];
    [self.processView reloadData];
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
