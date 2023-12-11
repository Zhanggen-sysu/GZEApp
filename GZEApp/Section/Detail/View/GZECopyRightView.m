//
//  GZECopyRightView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZECopyRightView.h"
#import "GZECommonHelper.h"

@interface GZECopyRightView ()

@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation GZECopyRightView

- (void)setupSubviews
{
    [self addSubview:self.tipsLabel];
}

- (void)defineLayout
{
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-10.f);
    }];
}

- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = kBoldFont(12.f);
        _tipsLabel.textColor = RGBColor(200, 200, 200);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.text = @"Copyright ©️ The Movie Database (TMDB)";
    }
    return _tipsLabel;
}


@end
