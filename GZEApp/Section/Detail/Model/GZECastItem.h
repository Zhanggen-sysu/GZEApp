//
//  GZECastItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseModel.h"
@class GZERoleItem;

NS_ASSUME_NONNULL_BEGIN

@interface GZECastItem : GZEBaseModel

@property (nonatomic, assign)         BOOL isAdult;
@property (nonatomic, assign)         NSInteger gender;
@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, copy)           NSString *knownForDepartment;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, copy)           NSString *originalName;
@property (nonatomic, assign)         double popularity;
@property (nonatomic, nullable, copy) NSString *profilePath;
@property (nonatomic, assign)         NSInteger castID;
@property (nonatomic, copy)           NSString *character;
@property (nonatomic, copy)           NSString *creditID;
@property (nonatomic, assign)         NSInteger order;
// TV
@property (nonatomic, copy)           NSArray<GZERoleItem *> *roles;
@property (nonatomic, assign)         NSInteger totalEpisodeCount;

// local
@property (nonatomic, copy, readonly) NSString *roleString;

@end

NS_ASSUME_NONNULL_END
