//
//  GZEReviewItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZEAuthorDetails;

NS_ASSUME_NONNULL_BEGIN

@interface GZEReviewItem : GZEBaseModel

@property (nonatomic, copy)   NSString *author;
@property (nonatomic, strong) GZEAuthorDetails *authorDetails;
@property (nonatomic, copy)   NSString *content;
@property (nonatomic, copy)   NSString *createdAt;
@property (nonatomic, copy)   NSString *identifier;
@property (nonatomic, copy)   NSString *updatedAt;
@property (nonatomic, copy)   NSString *url;

@end

NS_ASSUME_NONNULL_END
