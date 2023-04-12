//
//  GZEPeopleDetailRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEBaseModel.h"
@class GZECombinedCreditsRsp;
@class GZETagImageRsp;
@class GZETmdbImageRsp;
NS_ASSUME_NONNULL_BEGIN

@interface GZEPeopleDetailRsp : GZEBaseModel

@property (nonatomic, copy)           NSString *birthday;
@property (nonatomic, copy)           NSString *knownForDepartment;
@property (nonatomic, copy)           NSString *deathday;
@property (nonatomic, assign)         NSInteger identifier;
@property (nonatomic, copy)           NSString *name;
@property (nonatomic, copy)           NSArray<NSString *> *alsoKnownAs;
@property (nonatomic, assign)         NSInteger gender;
@property (nonatomic, copy)           NSString *biography;
@property (nonatomic, assign)         double popularity;
@property (nonatomic, copy)           NSString *placeOfBirth;
@property (nonatomic, copy)           NSString *profilePath;
@property (nonatomic, assign)         BOOL isAdult;
@property (nonatomic, copy)           NSString *imdbID;
@property (nonatomic, copy)           NSString *homepage;
@property (nonatomic, strong)         GZECombinedCreditsRsp *combinedCredits;
@property (nonatomic, strong)         GZETmdbImageRsp *images;
@property (nonatomic, strong)         GZETagImageRsp *taggedImages;

@end

NS_ASSUME_NONNULL_END
