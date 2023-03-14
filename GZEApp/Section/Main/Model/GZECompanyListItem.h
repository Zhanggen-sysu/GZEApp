//
//  GZECompanyListItem.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/10.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZECompanyListItem : GZEBaseModel

@property (nonatomic, assign) NSInteger displayPriority;
@property (nonatomic, copy)   NSString *logoPath;
@property (nonatomic, copy)   NSString *providerName;
@property (nonatomic, assign) NSInteger providerID;

@end

NS_ASSUME_NONNULL_END
