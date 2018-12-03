//
//  LayerViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/9/15.
//  Copyright © 2018年 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "LayerViewCell.h"

@interface LayerViewCell()
@property(nonatomic,strong)UIImageView *floorImage;
@property(nonatomic,strong)UILabel *floorTitle;
@end

@implementation LayerViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.layer.borderColor = [UIColor blackColor].CGColor;
        bgView.layer.borderWidth = 1;
        bgView.clipsToBounds = YES;
        bgView.layer.cornerRadius = (self.contentView.size.height - H_ADAPTER(10))/2;
        [self.contentView addSubview:bgView];
        bgView.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(self.contentView, W_ADAPTER(50))
        .rightSpaceToView(self.contentView, W_ADAPTER(50));
        
        _floorImage = [[UIImageView alloc] init];
        [bgView addSubview:_floorImage];
        _floorImage.sd_layout.topSpaceToView(bgView, 0).bottomSpaceToView(bgView, 0).leftSpaceToView(bgView, W_ADAPTER(100)).widthIs(W_ADAPTER(80));
        
        _floorTitle = [[UILabel alloc] init];
        _floorTitle.textAlignment = NSTextAlignmentCenter;
        _floorTitle.font = [UIFont boldSystemFontOfSize:W_ADAPTER(25)];
        [bgView addSubview:_floorTitle];
        _floorTitle.sd_layout.topEqualToView(_floorImage).bottomEqualToView(_floorImage).leftSpaceToView(_floorImage, W_ADAPTER(50)).rightSpaceToView(bgView, W_ADAPTER(100));
    }
    return self;
}

-(void)setCellWithModel:(SurfaceModel *)model Index:(int)index{
    NSDictionary *dict = [Tool creatDicWithJSONString:model.surfaceData];
    NSString *floorName = dict[[NSString stringWithFormat:@"%d",index]];
    if (floorName.length>0) {
        self.floorTitle.text = floorName;
        self.floorImage.image = [UIImage imageNamed:floorName];
    }
    else {
        self.floorTitle.text = @"面层";
        self.floorImage.image = nil;
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
