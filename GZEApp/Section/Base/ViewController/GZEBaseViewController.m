//
//  GZEBaseViewController.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/11.
//

#import "GZEBaseViewController.h"
#import <NSObject+MemoryLeak.h>

@interface GZEBaseViewController ()

@property (nonatomic, strong) id viewModel;

@end

@implementation GZEBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (BOOL)willDealloc
{
    if (![super willDealloc]) {
        return NO;
    }
    MLCheck(self.viewModel);
    return YES;
}


@end
