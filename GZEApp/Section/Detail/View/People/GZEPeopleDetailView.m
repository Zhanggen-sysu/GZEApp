//
//  GZEPeopleDetailView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/7.
//

#import "GZEPeopleDetailView.h"
#import "GZEPeopleDetailRsp.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"
#import "GZEWrappingLabel.h"

@interface GZEPeopleDetailView ()

@property (nonatomic, strong) UIImageView *profileImg;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) GZEWrappingLabel *overviewLabel;

@end

@implementation GZEPeopleDetailView

- (void)updateWithModel:(GZEPeopleDetailRsp *)model
{
    [self.profileImg sd_setImageWithURL:[GZECommonHelper getProfileUrl:model.profilePath size:GZEProfileSize_h632] placeholderImage:kGetImage(@"default-poster")];
    NSMutableString *name = [[NSMutableString alloc] initWithString:model.name];
    [model.alsoKnownAs enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([GZECommonHelper isChinese:obj isContain:YES]) {
            [name appendFormat:@" (%@)", obj];
            *stop = YES;
        }
    }];
    self.nameLabel.text = name;
    NSMutableString *detail = [[NSMutableString alloc] initWithFormat:@"Department: %@", model.knownForDepartment];
    if (model.placeOfBirth.length > 0) {
        [detail appendFormat:@"\nBirthplace: %@", model.placeOfBirth];
    }
    if (model.birthday.length > 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        NSInteger beginYear = [model.birthday substringToIndex:4].integerValue;
        NSInteger endYear = model.deathday.length > 0 ? [model.deathday substringToIndex:4].integerValue : [formatter stringFromDate:[NSDate date]].integerValue;
        [detail appendFormat:@"\nAge: %@ ~ %@, %ld years old", model.birthday, model.deathday.length > 0 ? model.deathday : @"Now", endYear - beginYear];
    }
    
    self.detailLabel.text = detail;
    self.overviewLabel.text = model.biography;
}

- (void)setupSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.profileImg];
    [self addSubview:self.backView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.detailLabel];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.overviewLabel];
    WeakSelf(self)
    self.overviewLabel.didChangeHeight = ^(BOOL isExpand) {
        StrongSelfReturnNil(self)
        self.overviewLabel.isExpand = isExpand;
    };
}

- (void)defineLayout
{
    [self.profileImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(SCREEN_WIDTH * 1.5);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImg.mas_bottom).offset(-15.f);
        make.leading.trailing.bottom.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
        make.top.equalTo(self.backView).offset(15.f);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.nameLabel);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(10.f);
    }];
    
    [self.overviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.nameLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10.f);
        make.bottom.equalTo(self.backView).offset(-10.f);
    }];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius = 15.f;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}

- (UIImageView *)profileImg
{
    if (!_profileImg) {
        _profileImg = [[UIImageView alloc] init];
    }
    return _profileImg;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = kBoldFont(18.f);
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.text = @"Biography";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = kFont(14.f);
        _detailLabel.textColor = RGBColor(128, 128, 128);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (GZEWrappingLabel *)overviewLabel
{
    if (!_overviewLabel) {
        _overviewLabel = [[GZEWrappingLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 0)];
        _overviewLabel.wrapText = nil;
        _overviewLabel.wrapNumberOfLine = 6;
        _overviewLabel.font = kFont(14.f);
        _overviewLabel.textColor = [UIColor blackColor];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"Expand" attributes:@{
            NSFontAttributeName: kFont(14.f),
            NSForegroundColorAttributeName: RGBColor(128, 128, 128),
        }]];
        _overviewLabel.expandText = attri;
        attri = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithString:@"Collapse" attributes:@{
            NSFontAttributeName: kFont(14.f),
            NSForegroundColorAttributeName: RGBColor(128, 128, 128),
        }]];
        _overviewLabel.wrapText = attri;
    }
    return _overviewLabel;
}

@end
