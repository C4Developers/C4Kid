//
//  SurfaceViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/4/30.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "SurfaceViewController.h"
#import "SurfaceViewCell.h"
#import "LayerViewCell.h"
#import "CatogoryViewController.h"

#define ButtonWidth   screenW/5
#define ButtonHeight  H_ADAPTER(60)

@interface SurfaceViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property(nonatomic,strong)UITableView *surfaceView;
@property(nonatomic,strong)UITableView *layerView;
@property(nonatomic,strong)NSMutableArray *surfaceArr;
@property(nonatomic,assign)int currentIndex;
@property(nonatomic,strong)UIScrollView *sectionView;
@property(nonatomic,strong)UIView *slideView;
@property(nonatomic,strong)UIPageViewController *pageVC;
@property(nonatomic,strong)NSMutableArray *pageContent;
@property(nonatomic,assign)int currentPage;
@property(nonatomic,assign)int currentFloor;
@end

@implementation SurfaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 9999;
    [self createData];
    [self loadUI];
    
    
    @weakify(self);
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"selectCatogory" object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * noti) {
        @strongify(self);
        SurfaceModel *surfaceModel = self.surfaceArr[self.currentIndex];
        [[RLMRealm defaultRealm] beginWriteTransaction];
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:[Tool creatDicWithJSONString:surfaceModel.surfaceData]];
        [mDict setValue:noti.userInfo[@"name"] forKey:[NSString stringWithFormat:@"%d",self.currentFloor]];
        surfaceModel.surfaceData = [Tool createJson:mDict];
        [[RLMRealm defaultRealm] commitWriteTransaction];
        [self.layerView reloadData];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveLinear animations:^ {
            @strongify(self);
            self.sectionView.frame = CGRectMake(0, screenH, screenW, ButtonHeight);
            CGRect frame = self.view.bounds;
            frame.origin.y = screenH+ButtonHeight;
            self.pageVC.view.frame = frame;
        }completion:nil];
    }];
}

#pragma marl - 获取数据
-(void)createData{
    self.surfaceArr = [NSMutableArray array];
    for (SurfaceModel *model in [SurfaceModel objectsWhere:@"floorCount = %@",self.model.floorCount]) {
        [self.surfaceArr addObject:model];
    }
}

#pragma mark - 加载UI
-(void)loadUI{
    self.navigationItem.title = @"面层/音效";
    self.view.backgroundColor = [UIColor whiteColor];
 
    UIImageView * bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"面层设置背景"];
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
    
    UIButton *voiceButton = [[UIButton alloc] init];
    voiceButton.layer.cornerRadius = 10;
    voiceButton.backgroundColor = [UIColor whiteColor];
    [voiceButton setTitle:@"音效" forState:UIControlStateNormal];
    [voiceButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [voiceButton addTarget:self action:@selector(voiceClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:voiceButton];
    voiceButton.sd_layout
    .rightSpaceToView(deleteButton, W_ADAPTER(50))
    .bottomEqualToView(deleteButton)
    .widthRatioToView(deleteButton, 1)
    .heightRatioToView(deleteButton, 1);
    
    UIButton *selectButton = [[UIButton alloc] init];
    selectButton.layer.cornerRadius = 10;
    selectButton.backgroundColor = [UIColor whiteColor];
    [selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    @weakify(self);
    [[selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         @strongify(self);
         if (self.currentIndex != 9999) {
             [[RLMRealm defaultRealm] beginWriteTransaction];
             SurfaceModel *surfaceModel = self.surfaceArr[self.currentIndex];
             self.model.surface = surfaceModel;
             [[RLMRealm defaultRealm] commitWriteTransaction];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"finishGame" object:nil];
             [self.navigationController popViewControllerAnimated:YES];
         }
         else {
             [SVProgressHUD showInfoWithStatus:@"请选择方案"];
         }
     }];
    [bgView addSubview:selectButton];
    selectButton.sd_layout
    .leftEqualToView(voiceButton)
    .rightEqualToView(voiceButton)
    .bottomSpaceToView(deleteButton, H_ADAPTER(40))
    .heightRatioToView(deleteButton, 1);
    
    UIButton *createButton = [[UIButton alloc] init];
    createButton.layer.cornerRadius = 10;
    createButton.backgroundColor = [UIColor whiteColor];
    [createButton setTitle:@"创建" forState:UIControlStateNormal];
    [createButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [createButton addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:createButton];
    createButton.sd_layout
    .leftEqualToView(deleteButton)
    .rightEqualToView(deleteButton)
    .bottomSpaceToView(deleteButton, H_ADAPTER(40))
    .heightRatioToView(deleteButton, 1);
    
    [bgView addSubview:self.surfaceView];
    self.surfaceView.sd_layout
    .topSpaceToView(bgView, 0)
    .leftSpaceToView(bgView, 0)
    .bottomSpaceToView(bgView, 0)
    .widthIs(W_ADAPTER(400));
    
    [bgView addSubview:self.layerView];
    self.layerView.sd_layout
    .leftEqualToView(voiceButton)
    .rightEqualToView(deleteButton)
    .bottomSpaceToView(selectButton, H_ADAPTER(40))
    .topSpaceToView(bgView, H_ADAPTER(40));
    
    [bgView addSubview:self.sectionView];
    [self addChildViewController:self.pageVC];
    [bgView addSubview:self.pageVC.view];
}

-(UITableView *)surfaceView{
    if (!_surfaceView) {
        _surfaceView = [[UITableView alloc] init];
        _surfaceView.delegate = self;
        _surfaceView.dataSource = self;
        _surfaceView.showsVerticalScrollIndicator = NO;
        _surfaceView.showsHorizontalScrollIndicator = NO;
        _surfaceView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _surfaceView.rowHeight = H_ADAPTER(80);
        _surfaceView.backgroundColor = [UIColor clearColor];
        _surfaceView.layer.borderWidth = 2;
        _surfaceView.layer.borderColor = [UIColor whiteColor].CGColor;
        _surfaceView.layer.cornerRadius = 5;
    }
    return _surfaceView;
}

-(UITableView *)layerView{
    if (!_layerView) {
        _layerView = [[UITableView alloc] init];
        _layerView.delegate = self;
        _layerView.dataSource = self;
        _layerView.showsVerticalScrollIndicator = NO;
        _layerView.showsHorizontalScrollIndicator = NO;
        _layerView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _layerView.rowHeight = H_ADAPTER(95);
        _layerView.layer.cornerRadius = 10;
    }
    return _layerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return H_ADAPTER(40);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.surfaceView) {
        return self.surfaceArr.count;
    }
    else {
        if (self.currentIndex != 9999) {
            SurfaceModel *model = self.surfaceArr[self.currentIndex];
            return [model.floorCount intValue];
        }
        else {
            return 0;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, W_ADAPTER(400), H_ADAPTER(40))];
    sectionLabel.textAlignment = NSTextAlignmentCenter;
    sectionLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
    sectionLabel.textColor = [UIColor blackColor];
    if (tableView == self.surfaceView) {
        sectionLabel.text = @"面层方案";
    }
    else {
        sectionLabel.text = @"面层设置";
    }
    return sectionLabel;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.surfaceView) {
        SurfaceViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SurfaceViewCell class])];
        if (cell == nil) {
            cell = [[SurfaceViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([SurfaceViewCell class])];
        }
        SurfaceModel *model = self.surfaceArr[indexPath.row];
        [cell setCellWithName:model.surfaceName Index:(int)indexPath.row Current:self.currentIndex];
        return cell;
    }
    else {
        LayerViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LayerViewCell class])];
        if (cell == nil) {
            cell = [[LayerViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NSStringFromClass([LayerViewCell class])];
        }
        SurfaceModel *model = self.surfaceArr[self.currentIndex];
        [cell setCellWithModel:model Index:(int)indexPath.row+1];
        return cell;
    }
}

#pragma mark - 创建点击
-(void)createClick{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"创建" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
    }];
    alert.textFields.firstObject.placeholder = @"请输入方案名称";
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        if (alert.textFields.firstObject.text.length>0) {
            RLMResults * results = [SurfaceModel objectsWhere:@"floorCount = %@ AND surfaceName = %@",self.model.floorCount,alert.textFields.firstObject.text];
            if (results.count>0) {
                [SVProgressHUD showInfoWithStatus:@"已存在该方案名称"];
            }
            else {
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] addObject:[[SurfaceModel alloc] initWithFloorCount:self.model.floorCount SurfaceName:alert.textFields.firstObject.text]];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                [self createData];
                [self.surfaceView reloadData];
            }
        }
        else {
            [SVProgressHUD showInfoWithStatus:@"请输入正确方案名称"];
        }
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark 删除点击
-(void)deleteClick{
    if (self.currentIndex != 9999) {
        SurfaceModel * surfaceModel = self.surfaceArr[self.currentIndex];
        if ([self.model.surface.surfaceName isEqualToString:surfaceModel.surfaceName]) {
            [SVProgressHUD showInfoWithStatus:@"该方案正在使用，无法删除"];
        }
        else {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该方案?" preferredStyle:UIAlertControllerStyleAlert];
            @weakify(self);
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                @strongify(self);
                [[RLMRealm defaultRealm] beginWriteTransaction];
                [[RLMRealm defaultRealm] deleteObject:surfaceModel];
                [[RLMRealm defaultRealm] commitWriteTransaction];
                self.currentIndex = 9999;
                [self createData];
                [self.surfaceView reloadData];
                [self.layerView reloadData];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择方案"];
    }
}

#pragma mark 音效点击
-(void)voiceClick{
    if (self.currentIndex != 9999) {
        SurfaceModel * surfaceModel = self.surfaceArr[self.currentIndex];
        UIAlertController *soundAlert = [UIAlertController alertControllerWithTitle:@"请选择音效" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [soundAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        for (NSString *sound in [SendData shareData].soundArr) {
            [soundAlert addAction:[UIAlertAction actionWithTitle:sound style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[RLMRealm defaultRealm] beginWriteTransaction];
                surfaceModel.soundName = sound;
                [[RLMRealm defaultRealm] commitWriteTransaction];
            }]];
        }
        [self presentViewController:soundAlert animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"请选择方案"];
    }
}

#pragma mark - 方案点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.surfaceView) {
        self.currentIndex = (int)indexPath.row;
        [self.surfaceView reloadData];
        [self.layerView reloadData];
    }
    else {
        @weakify(self);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveLinear animations:^ {
            @strongify(self);
            self.currentFloor = (int)indexPath.row+1;
            self.sectionView.frame = CGRectMake(0, 0, screenW, ButtonHeight);
            CGRect frame = self.view.bounds;
            frame.origin.y = ButtonHeight;
            self.pageVC.view.frame = frame;
        }completion:nil];
    }
}

#pragma mark - pageVC
-(UIView *)slideView{
    if (!_slideView){
        _slideView = [[UIView alloc]initWithFrame:CGRectMake(self.currentPage*W_ADAPTER(80)+(ButtonWidth-W_ADAPTER(80))/2, H_ADAPTER(45), W_ADAPTER(80), H_ADAPTER(5))];
        _slideView.layer.cornerRadius = 2;
        _slideView.backgroundColor = [UIColor redColor];
    }
    return _slideView;
}


-(UIScrollView *)sectionView {
    if (!_sectionView) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurfaceList" ofType:@"plist"]];
        NSMutableArray *sectionArr = [NSMutableArray array];
        for (NSString *keyName in dict.allKeys) {
            [sectionArr addObject:keyName];
        }
        _sectionView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, screenH, screenW, ButtonHeight)];
        _sectionView.contentSize = CGSizeMake(sectionArr.count*ButtonWidth, ButtonHeight);
        _sectionView.showsHorizontalScrollIndicator = NO;
        _sectionView.backgroundColor = [UIColor whiteColor];
        
        for (int i = 0; i < sectionArr.count; i++) {
            UIButton *catogoryButton = [[UIButton alloc] initWithFrame:CGRectMake(ButtonWidth * i, 0, ButtonWidth, ButtonHeight)];
            catogoryButton.tag = i;
            catogoryButton.selected = i == self.currentPage ? YES:NO;
            catogoryButton.backgroundColor = [UIColor whiteColor];
            catogoryButton.titleLabel.font = [UIFont boldSystemFontOfSize:W_ADAPTER(19)];
            [catogoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [catogoryButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [catogoryButton setTitle:sectionArr[i] forState:UIControlStateNormal];
            [catogoryButton addTarget:self action:@selector(catogoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sectionView addSubview:catogoryButton];
        }
        UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.sectionView.height - 1, sectionArr.count*ButtonWidth, 1)];
        line2.backgroundColor = [UIColor blackColor];
        [_sectionView addSubview:line2];
        //划线
        [_sectionView addSubview:self.slideView];
    }
    return _sectionView;
}

-(UIPageViewController *)pageVC {
    if (!_pageVC) {
        NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        CGRect frame = self.view.bounds;
        frame.origin.y = screenH+ButtonHeight;
        frame.size.height -= ButtonHeight;
        _pageVC.view.frame = frame;
        [_pageVC setViewControllers:@[self.pageContent[self.currentPage]]
                          direction:UIPageViewControllerNavigationDirectionForward
                           animated:YES
                         completion:nil];
    }
    return _pageVC;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = (int)[self.pageContent indexOfObject:viewController];
    if (index<1) {
        self.sectionView.contentOffset = CGPointMake(0, 0);
    }
    if (index <= 0) {
        return nil;
    }
    else {
        index --;
        return self.pageContent[index];
    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    int index = (int)[self.pageContent indexOfObject:viewController];
    if (index>4) {
        self.sectionView.contentOffset = CGPointMake(ButtonWidth, 0);
    }
    if (index >= self.pageContent.count - 1) {
        return nil;
    }
    else {
        index ++;
        return self.pageContent[index];
    }
}

-(NSArray *)pageContent {
    if(!_pageContent) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurfaceList" ofType:@"plist"]];
        _pageContent = [NSMutableArray array];
        for (NSString *keyName in dict.allKeys) {
            CatogoryViewController *catogoryVC = [[CatogoryViewController alloc] init];
            catogoryVC.catogory = keyName;
            [_pageContent addObject:catogoryVC];
        }
    }
    return _pageContent;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    self.currentPage = (int)[self.pageContent indexOfObject:pendingViewControllers.firstObject];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveLinear animations:^ {
            CGRect frame = self.slideView.frame;
            frame.origin.x = self.currentPage*ButtonWidth+(ButtonWidth-W_ADAPTER(80))/2;
            self.slideView.frame = frame;
            
            for (UIView * view in self.sectionView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    UIButton * button = (UIButton *)view;
                    button.selected = button.tag == self.currentPage? YES:NO;
                }
            }
        }completion:nil];
    }
}

-(void)catogoryButtonClick:(UIButton *)button{
    if (self.currentPage < (int)button.tag) {
        self.currentPage = (int)button.tag;
        [self.pageVC setViewControllers:@[self.pageContent[self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    else {
        self.currentPage = (int)button.tag;
        [self.pageVC setViewControllers:@[self.pageContent[self.currentPage]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    }
    @weakify(self);
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:5.0f options:UIViewAnimationOptionCurveLinear animations:^ {
        @strongify(self);
        CGRect frame = self.slideView.frame;
        frame.origin.x = self.currentPage*ButtonWidth+(ButtonWidth-W_ADAPTER(80))/2;
        self.slideView.frame = frame;
        for (UIView * view in self.sectionView.subviews){
            if ([view isKindOfClass:[UIButton class]]){
                UIButton * button = (UIButton *)view;
                button.selected = button.tag == self.currentPage? YES:NO;
            }
        }
    }completion:nil];
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
