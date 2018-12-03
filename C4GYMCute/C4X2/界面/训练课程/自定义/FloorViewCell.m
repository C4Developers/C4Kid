//
//  FloorViewCell.m
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "FloorViewCell.h"

@interface FloorViewCell()
@property(nonatomic,strong)UIImageView *surfaceImage;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation FloorViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.clipsToBounds = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:W_ADAPTER(25)];
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _titleLabel.layer.cornerRadius = (self.contentView.size.height - H_ADAPTER(10))/2;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(self.contentView, W_ADAPTER(50))
        .rightSpaceToView(self.contentView, W_ADAPTER(200));
        
        _surfaceImage = [[UIImageView alloc] init];
        _surfaceImage.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_surfaceImage];
        _surfaceImage.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .rightSpaceToView(self.contentView, W_ADAPTER(75))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(_titleLabel, W_ADAPTER(45));
    }
    return self;
}

-(void)setCellWithIndex:(int)index Model:(ModuleModel *)model Arr:(NSMutableArray *)floorArr{
    self.titleLabel.text = [NSString stringWithFormat:@"地板ID:%d",index+1];
    NSDictionary *dict = [Tool creatDicWithJSONString:model.surface.surfaceData];
    NSString *surfaceName = dict[[NSString stringWithFormat:@"%d",index+1]];
    if (surfaceName.length>0) {
        self.surfaceImage.image = [UIImage imageNamed:surfaceName];
    }
    else {
        self.surfaceImage.image = nil;
    }
    
    if ([floorArr containsObject:[NSNumber numberWithInt:index+1]]) {
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
