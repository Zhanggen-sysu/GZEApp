//
//  GZEKeyWordView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEKeyWordView.h"
#import "GZEKeywordRsp.h"
#import "GZEGenreItem.h"
#import <TTGTextTagCollectionView.h>

@interface GZEKeyWordView () <TTGTextTagCollectionViewDelegate>

@property (nonatomic, strong) TTGTextTagCollectionView *keywordView;
@property (nonatomic, strong) TTGTextTagStyle *keywordStyle;
@property (nonatomic, strong) GZEKeywordRsp *model;

@end

@implementation GZEKeyWordView

- (void)updateWithModel:(GZEKeywordRsp *)model magicColor:(nonnull UIColor *)magicColor
{
    if (model.keywords.count <= 0 && model.results.count <= 0) {
        self.hidden = YES;
        return;
    }
    self.model = model;
    self.keywordStyle.backgroundColor = magicColor;
    [model.keywords enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TTGTextTagStringContent *text = [TTGTextTagStringContent contentWithText:obj.name];
        text.textFont = kFont(14.f);
        text.textColor = [UIColor whiteColor];
        TTGTextTag *textTag = [TTGTextTag tagWithContent:text style:self.keywordStyle];
        [self.keywordView addTag:textTag];
    }];
    [model.results enumerateObjectsUsingBlock:^(GZEGenreItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TTGTextTagStringContent *text = [TTGTextTagStringContent contentWithText:obj.name];
        text.textFont = kFont(14.f);
        text.textColor = [UIColor whiteColor];
        TTGTextTag *textTag = [TTGTextTag tagWithContent:text style:self.keywordStyle];
        [self.keywordView addTag:textTag];
    }];
    
    [self.keywordView reload];
}

- (void)setupSubviews
{
    [self addSubview:self.keywordView];
}

- (void)defineLayout
{
    [self.keywordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
    }];
}

- (TTGTextTagCollectionView *)keywordView
{
    if (!_keywordView) {
        _keywordView = [[TTGTextTagCollectionView alloc] init];
        _keywordView.delegate = self;
    }
    return _keywordView;
}

- (TTGTextTagStyle *)keywordStyle
{
    if (!_keywordStyle) {
        _keywordStyle = [[TTGTextTagStyle alloc] init];
        _keywordStyle.borderWidth = 0;
        _keywordStyle.shadowOffset = CGSizeMake(0, 0);
        _keywordStyle.shadowRadius = 0;
        _keywordStyle.extraSpace = CGSizeMake(8, 3);
    }
    return _keywordStyle;
}

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(TTGTextTag *)tag
                      atIndex:(NSUInteger)index
{
    !self.didTapKeyword ?: self.didTapKeyword(self.model.keywords[index]);
}

@end
