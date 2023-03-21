//
//  GZEDiscoverHeaderView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/14.
//

#import <UIKit/UIKit.h>
#import "GZEEnum.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEDiscoverHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) void (^didTapMediaButton)(GZEMediaType mediaType);
@property (nonatomic, copy) void (^didTapSortButton)(void);
@property (nonatomic, copy) void (^didTapGenreButton)(void);
@property (nonatomic, copy) void (^didTapLanguageButton)(void);
@property (nonatomic, copy) void (^didTapFilterButton)(void);

- (void)resetFilter;
- (void)updateSortTitle:(NSString *)title hightlight:(BOOL)hightlight;
- (void)sortArrowIsUp:(BOOL)isUp;

- (void)updateGenreTitle:(NSString *)title hightlight:(BOOL)hightlight;
- (void)genreArrowIsUp:(BOOL)isUp;

- (void)updateLanguageTitle:(NSString *)title hightlight:(BOOL)hightlight;
- (void)languageArrowIsUp:(BOOL)isUp;

@end

NS_ASSUME_NONNULL_END
