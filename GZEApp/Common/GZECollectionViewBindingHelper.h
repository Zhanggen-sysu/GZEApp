//
//  GZECollectionViewBindingHelper.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface GZECollectionViewBindingHelper : NSObject

// collectionView 绑定工具类，参考链接：https://blog.scottlogic.com/2014/05/11/reactivecocoa-tableview-binding.html
+ (instancetype)bindCollectionView:(UICollectionView *)collectionView
                      sourceSignal:(RACSignal *)sourceSignal
                     selectCommand:(RACCommand *)selectCommand
                         cellClass:(Class)cellClass;

@end

NS_ASSUME_NONNULL_END
