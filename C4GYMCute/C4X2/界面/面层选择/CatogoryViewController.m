//
//  CatogoryViewController.m
//  C4gym
//
//  Created by Hinwa on 2018/10/1.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "CatogoryViewController.h"
#import "CatogoryViewCell.h"

@interface CatogoryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation CatogoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    self.collectionView.sd_layout
    .topSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout*layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = W_ADAPTER(20);
        layout.minimumLineSpacing = H_ADAPTER(20);
        layout.sectionInset = UIEdgeInsetsMake(H_ADAPTER(30), W_ADAPTER(30), H_ADAPTER(30), W_ADAPTER(30));
        layout.itemSize = CGSizeMake(W_ADAPTER(200), H_ADAPTER(200));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CatogoryViewCell class] forCellWithReuseIdentifier:NSStringFromClass([CatogoryViewCell class])];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurfaceList" ofType:@"plist"]];
    NSArray *array = dict[self.catogory];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CatogoryViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CatogoryViewCell class]) forIndexPath:indexPath];
    [cell setCellWithIndex:(int)indexPath.row andCatogory:self.catogory];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SurfaceList" ofType:@"plist"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectCatogory" object:nil userInfo:@{@"name":dict[self.catogory][indexPath.row]}];
}

-(void)dealloc{
    NSLog(@"%@销毁",[self class]);
}

@end
