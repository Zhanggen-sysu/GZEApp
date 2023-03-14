//
//  GZEListSmallView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/13.
//

#import "GZEBaseView.h"
@class GZEListSmallViewModel;
NS_ASSUME_NONNULL_BEGIN

@interface GZEListSmallView : GZEBaseView

+ (GZEListSmallView *)createListView:(NSInteger)index model:(GZEListSmallViewModel *)model;

@end

NS_ASSUME_NONNULL_END
