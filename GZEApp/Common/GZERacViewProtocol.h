//
//  GZERacViewProtocol.h
//  GZEApp
//
//  Created by GenZhang on 2023/12/5.
//

#ifndef GZERacViewProtocol_h
#define GZERacViewProtocol_h
#import "Macro.h"
#import "Masonry.h"
#import <ReactiveObjC.h>

@protocol GZERacViewProtocol <NSObject>

@optional

- (void)bindViewModel:(id)viewModel;

@end

#endif /* GZERacViewProtocol_h */
