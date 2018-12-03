//
//  CustomProcessCell.m
//  C4gym
//
//  Created by Hinwa on 2018/10/24.
//  Copyright © 2018 Zhongshan Marvel Electronic Technology Co., Ltd. All rights reserved.
//

#import "CustomProcessCell.h"

@interface CustomProcessCell()
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation CustomProcessCell

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
        _titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.borderWidth = 1;
        [self.contentView addSubview:_titleLabel];
        _titleLabel.sd_layout
        .topSpaceToView(self.contentView, H_ADAPTER(10))
        .bottomSpaceToView(self.contentView, H_ADAPTER(10))
        .leftSpaceToView(self.contentView, W_ADAPTER(50))
        .rightSpaceToView(self.contentView, W_ADAPTER(50));
    }
    return self;
}

-(void)setCellWithModel:(StepModel *)stepModel{
    if (stepModel.floorID.count == 1) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",stepModel.floorID.firstObject];
    }
    else {
        self.titleLabel.text = [stepModel.floorID componentsJoinedByString:@"-"];
    }
    
    if (stepModel.time>0) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@     %ds",self.titleLabel.text,stepModel.time];
    }
    else {
        self.titleLabel.text = [NSString stringWithFormat:@"%@     等待",self.titleLabel.text];
    }
    
    switch (stepModel.type) {
        case 0:
            self.titleLabel.text = [NSString stringWithFormat:@"%@     正常",self.titleLabel.text];
            break;
        case 1:
            self.titleLabel.text = [NSString stringWithFormat:@"%@     呼吸灯",self.titleLabel.text];
            break;
        default:
            self.titleLabel.text = [NSString stringWithFormat:@"%@     常亮",self.titleLabel.text];
            break;
    }
    
    if ([stepModel.color isEqualToString:@"red"]) {
        self.titleLabel.backgroundColor = [UIColor redColor];
    }
    else if ([stepModel.color isEqualToString:@"orange"]) {
        self.titleLabel.backgroundColor = [UIColor orangeColor];
    }
    else if ([stepModel.color isEqualToString:@"yellow"]) {
        self.titleLabel.backgroundColor = [UIColor yellowColor];
    }
    else if ([stepModel.color isEqualToString:@"blue"]) {
        self.titleLabel.backgroundColor = [UIColor blueColor];
    }
    else if ([stepModel.color isEqualToString:@"green"]) {
        self.titleLabel.backgroundColor = [UIColor greenColor];
    }
    else if ([stepModel.color isEqualToString:@"purple"]) {
        self.titleLabel.backgroundColor = [UIColor purpleColor];
    }
    else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
