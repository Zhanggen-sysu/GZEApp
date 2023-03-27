//
//  GZEAuthorDetails.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEAuthorDetails : GZEBaseModel

@property (nonatomic, copy)             NSString *name;
@property (nonatomic, copy)             NSString *username;
@property (nonatomic, nullable, copy)   NSString *avatarPath;
@property (nonatomic, nullable, strong) NSNumber *rating;

@end

NS_ASSUME_NONNULL_END
