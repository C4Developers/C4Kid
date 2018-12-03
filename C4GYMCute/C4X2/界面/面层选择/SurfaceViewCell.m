//
//  SurfaceViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/9/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "SurfaceViewCell.h"

@interface SurfaceViewCell()
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation SurfaceViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.clipsToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.font = [UIFont systemFontOfSize:W_ADAPTER(25)];
        _titleLabel.layer.cornerRadius = 10;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(self.contentView, W_ADAPTER(50))
        .rightSpaceToView(self.contentView, W_ADAPTER(50));
    }
    return self;
}

-(void)setCellWithName:(NSString *)name Index:(int)index Current:(int)current{
    self.titleLabel.text = name;
    if (index == current) {
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
