//
//  GZESearchListView.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/27.
//

#import "GZEBaseView.h"
#import <JXCategoryListContainerView.h>
@class GZESearchCellViewModel;
@class GZESearchListView;

@protocol GZESearchListViewDelegate <NSObject>

@optional
- (void)GZESearchListViewDidScroll:(GZESearchListView *_Nullable)listView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GZESearchListView : GZEBaseView <JXCategoryListContentViewDelegate>

@property (nonatomic, weak) id<GZESearchListViewDelegate> delegate;
@property (nonatomic, copy) void (^selectItemBlock)(GZESearchCellViewModel *model);
@property (nonatomic, copy) void (^deleteItemBlock)(NSMutableArray<GZESearchCellViewModel *> *model);
@property (nonatomic, assign) BOOL supportDelete;

- (void)updateWithModel:(NSMutableArray *)model;

@end

NS_ASSUME_NONNULL_END
