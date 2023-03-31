//
//  GZEKeyWordView.m
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEKeyWordView.h"
#import <TTGTextTagCollectionView.h>

@interface GZEKeyWordView ()

@property (nonatomic, strong) TTGTextTagCollectionView *keywordView;

@end

@implementation GZEKeyWordView

//- (void)ud

- (void)setupSubviews
{
    [self addSubview:self.keywordView];
}

- (void)defineLayout
{
    [self.keywordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self).offset(15.f);
        make.trailing.equalTo(self).offset(-15.f);
    }];
}

@end
