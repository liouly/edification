//
//  ReadNewsCell.m
//  MyOne
//
//  Created by 林辉武 on 2018/10/6.
//  Copyright © 2018年 melody. All rights reserved.
//

#import "ReadNewsCell.h"

@implementation ReadNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.authorLabel];
    }
    return self;
}

- (UIImageView *)iconView
{
    if (nil == _iconView) {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _iconView.contentMode = UIViewContentModeCenter;
        _iconView.layer.masksToBounds = YES;
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, SCREEN_WIDTH - self.iconView.frame.size.width - 15*2, 40)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}

- (UILabel *)authorLabel
{
    if (nil == _authorLabel) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, SCREEN_WIDTH - self.iconView.frame.size.width - 15*2, 20)];
        _authorLabel.font = [UIFont systemFontOfSize:12];
        _authorLabel.textColor = [UIColor grayColor];
    }
    return _authorLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
