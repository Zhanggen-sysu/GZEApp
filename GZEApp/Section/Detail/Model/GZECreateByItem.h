//
//  GZECreateByItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/31.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZECreateByItem : GZEBaseModel

@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, copy)           NSString *creditID;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, assign)         NSInteger gender;
@property (nonatomic, nullable, copy) NSString *profilePath;

@end

NS_ASSUME_NONNULL_END
