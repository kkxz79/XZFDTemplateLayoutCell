//
//  XZFeedCell.m
//  XZFDTemplateLayoutCell
//
//  Created by kkxz on 2018/12/10.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZFeedCell.h"
#import "Masonry.h"

static const CGFloat Interval_Right_Size = 60.0f;

@interface XZFeedCell ()
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *contentLabel;
@property(nonatomic,strong) UIImageView *contentImageView;
@property(nonatomic,strong) UILabel *usernameLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@end

@implementation XZFeedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createSubViews];
        [self createAutoLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)createSubViews {
     [self.contentView addSubview:self.titleLabel];
     [self.contentView addSubview:self.contentLabel];
     [self.contentView addSubview:self.contentImageView];
     [self.contentView addSubview:self.usernameLabel];
     [self.contentView addSubview:self.timeLabel];
}

-(void)createAutoLayout {
    __weak __typeof(self)myself = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(myself.contentView.mas_top).offset(5.0f);
        make.left.mas_equalTo(myself.contentView.mas_left).offset(15.0f);
        make.right.mas_equalTo(myself.contentView.mas_right).offset(-Interval_Right_Size);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(myself.titleLabel);
        make.top.mas_equalTo(myself.titleLabel.mas_bottom).offset(5.0f);
    }];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myself.titleLabel.mas_left);
        make.top.mas_equalTo(myself.contentLabel.mas_bottom).offset(5.0f);
    }];
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(myself.contentImageView.mas_bottom).offset(5.0f);
        make.bottom.mas_equalTo(myself.contentView.mas_bottom).offset(-5.0f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.top.equalTo(myself.usernameLabel);
        make.right.equalTo(myself.titleLabel.mas_right);
    }];
    
}

- (void)setEntity:(XZFeedEntity *)entity {
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    self.contentImageView.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;

}

#pragma mark - lazy init
@synthesize titleLabel = _titleLabel;
-(UILabel *)titleLabel {
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blueColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _timeLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

@synthesize contentLabel = _contentLabel;
-(UILabel *)contentLabel {
    if(!_contentLabel){
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.font = [UIFont systemFontOfSize:13];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@synthesize contentImageView = _contentImageView;
-(UIImageView *)contentImageView {
    if(!_contentImageView){
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor clearColor];
    }
    return _contentImageView;
}

@synthesize usernameLabel = _usernameLabel;
-(UILabel *)usernameLabel {
    if(!_usernameLabel){
        _usernameLabel = [[UILabel alloc] init];
        _usernameLabel.textAlignment = NSTextAlignmentLeft;
        _usernameLabel.backgroundColor = [UIColor clearColor];
        _usernameLabel.textColor = [UIColor lightGrayColor];
        _usernameLabel.font = [UIFont systemFontOfSize:13];
        _usernameLabel.numberOfLines = 0;
    }
    return _usernameLabel;
}

@synthesize timeLabel = _timeLabel;
-(UILabel *)timeLabel {
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}
@end
