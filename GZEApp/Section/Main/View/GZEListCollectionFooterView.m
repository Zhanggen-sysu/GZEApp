//
//  GZEListCollectionFooterView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import "GZEListCollectionFooterView.h"
#import "Macro.h"
#import "Masonry.h"
#import "GZECommonHelper.h"

@interface GZEListCollectionFooterView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *moreLabel;
@property (nonatomic, strong) UIImageView *arrow;


@end

@implementation GZEListCollectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self setupSubviews];
        [self defineLayout];
    }
    return self;
}

- (void)setupSubviews
{
    [self addSubview:self.backView];
    [self addSubview:self.moreLabel];
    [self addSubview:self.arrow];
}

- (void)defineLayout
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15.f);
    }];
    
    [self.moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.backView);
    }];
    
    [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreLabel.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(15.f, 15.f));
    }];
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = RGBColor(245, 245, 245);
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10.f;
    }
    return _backView;
}

- (UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.text = @"更\n多";
        _moreLabel.numberOfLines = 2;
        _moreLabel.font = kFont(14.f);
        _moreLabel.textColor = RGBColor(128, 128, 128);
    }
    return _moreLabel;
}

- (UIImageView *)arrow
{
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = kGetImage(@"arrow-right-gray");
    }
    return _arrow;
}

@end
