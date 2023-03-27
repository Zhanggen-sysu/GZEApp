//
//  GZESearchListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseView.h"
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchListView : GZEBaseView <JXCategoryListContentViewDelegate>

- (void)updateWithModel:(NSArray *)model;

@end

NS_ASSUME_NONNULL_END
