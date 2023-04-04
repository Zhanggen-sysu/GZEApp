//
//  GZETVDetailLineView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/3.
//

#import "GZETVDetailLineView.h"

@interface GZETVDetailLineView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITextView *detailTextView;

@end

@implementation GZETVDetailLineView

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super initWithFrame:CGRectZero]) {
        self.titleLabel.text = title;
    }
    return self;
}

- (void)updateWithDetail:(NSString *)detail
{
    [self.detailTextView removeFromSuperview];
    self.detailLabel.text = detail;
}

- (void)updateWithLinkDetail:(NSString *)linkDetail
{
    [self.detailLabel removeFromSuperview];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
    // 添加click
    [attriString appendAttributedString:[[NSAttributedString alloc] initWithString:linkDetail attributes:@{
        NSForegroundColorAttributeName:[UIColor whiteColor],
        NSFontAttributeName:[UIFont systemFontOfSize:16.f],
        NSLinkAttributeName:@"click://",
    }]];
    self.detailTextView.attributedText = attriString;
}

- (void)setupSubviews
{
    [self addSubview:self.titleLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.detailTextView];
}

- (void)defineLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.equalTo(self);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(10.f);
        make.top.trailing.bottom.equalTo(self);
    }];
    [self.detailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel.mas_trailing).offset(10.f);
        make.top.trailing.bottom.equalTo(self);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = kBoldFont(16);
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = kFont(16.f);
        _detailLabel.numberOfLines = 0;
    }
    return _detailLabel;
}

- (UITextView *)detailTextView
{
    if (!_detailTextView) {
        _detailTextView = [[UITextView alloc] init];
        _detailTextView.backgroundColor = [UIColor clearColor];
        _detailTextView.editable = NO;
        _detailTextView.delegate = self;
        _detailTextView.scrollEnabled = NO;
        _detailTextView.textContainerInset = UIEdgeInsetsZero;
        _detailTextView.textContainer.lineFragmentPadding = 0;
    }
    return _detailTextView;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([URL.scheme isEqualToString:@"click"]) {
        // TODO: 添加跳转网页
        return NO;
    }
    return YES;
}

@end
