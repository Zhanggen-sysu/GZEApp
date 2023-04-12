//
//  GZEPeopleDetailView.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/7.
//

#import "GZEBaseView.h"
@class GZEPeopleDetailRsp;

NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleDetailView : GZEBaseView

- (void)updateWithModel:(GZEPeopleDetailRsp *)model;

@end

NS_ASSUME_NONNULL_END
