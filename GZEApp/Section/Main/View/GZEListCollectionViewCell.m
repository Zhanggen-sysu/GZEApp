//
//  GZEListCollectionViewCell.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEListCollectionViewCell.h"
#import "GZEListCollectionViewModel.h"
#import "GZEListSmallView.h"
#import "UIImageView+WebCache.h"
#import "GZECommonHelper.h"

@interface GZEListCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bgImg;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) GZEListCollectionViewModel *viewModel;

@end

@implementation GZEListCollectionViewCell

- (void)updateWithModel:(GZEListCollectionViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.titleLabel.text = viewModel.title;
    [self.bgImg sd_setImageWithURL:viewModel.imgUrl placeholderImage:kGetImage(@"default-backdrop")];
    NSArray *subView = self.stackView.arrangedSubviews;
    [subView enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [viewModel.viewModels enumerateObjectsUsingBlock:^(GZEListSmallViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GZEListSmallView *view = [GZEListSmallView createListView:idx model:obj];
        [self.stackView addArrangedSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(69.f);
            make.left.right.equalTo(self.stackView);
        }];
    }];
}

- (void)setupSubviews
{
    [self.contentView addSubview:self.bgImg];
    [self.contentView addSubview:self.maskView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.stackView];
}

- (void)defineLayout
{
    // 320*180
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(180.f);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15.f);
        make.right.equalTo(self.contentView).offset(-15.f);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self layoutIfNeeded];
    [GZECommonHelper applyCornerRadiusToView:self.contentView radius:15.f corners:UIRectCornerAllCorners];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.maskView.bounds;
    gradientLayer.colors = @[(__bridge id)RGBAColor(70, 130, 180, 0.1f).CGColor
                             , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor
                             , (__bridge id)RGBAColor(70, 130, 180, 1.f).CGColor];
    gradientLayer.startPoint = CGPointMake(0.5, 0);
    gradientLayer.endPoint = CGPointMake(0.5, 1);
    gradientLayer.locations = @[@0, @0.4, @1];
    [self.maskView.layer addSublayer:gradientLayer];
}

- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
    }
    return _bgImg;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kBoldFont(16.f);
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
    }
    return _maskView;
}

- (UIStackView *)stackView
{
    if (!_stackView) {
        _stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.spacing = 10.f;
    }
    return _stackView;
}


@end
