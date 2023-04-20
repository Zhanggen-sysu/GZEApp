//
//  GZEImageBrowserCell.h
//  GZEApp
//
//  Created by GenZhang on 2023/4/13.
//

#import "GZEBaseCollectionViewCell.h"
@class GZEImageBrowserScrollView;

NS_ASSUME_NONNULL_BEGIN

@interface GZEImageBrowserCell : GZEBaseCollectionViewCell

@property (nonatomic, strong) GZEImageBrowserScrollView *imageScrollView;

@end

NS_ASSUME_NONNULL_END
