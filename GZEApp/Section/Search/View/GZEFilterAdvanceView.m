//
//  GZEFilterAdvanceView.m
//  GZEApp
//
//  Created by GenZhang on 2023/4/6.
//

#import "GZEFilterAdvanceView.h"

@interface GZEFilterAdvanceView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *clearBtn;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation GZEFilterAdvanceView

- (void)setupSubviews
{
    [self addSubview:self.tableView];
    [self addSubview:self.confirmBtn];
    [self addSubview:self.clearBtn];
}

- (void)defineLayout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.equalTo(self);
        make.width.equalTo(self.confirmBtn);
        make.height.mas_equalTo(30.f);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.clearBtn.mas_trailing).offset(20.f);
        make.trailing.bottom.height.equalTo(self.clearBtn);
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] init];
        [_clearBtn setTitle:@"Clear" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:RGBColor(0, 191, 255) forState:UIControlStateNormal];
        _clearBtn.backgroundColor = [UIColor whiteColor];
        _clearBtn.layer.borderWidth = 1;
        _clearBtn.layer.borderColor = RGBColor(0, 191, 255).CGColor;
        _clearBtn.titleLabel.font = kBoldFont(15.f);
        _clearBtn.layer.masksToBounds = YES;
        _clearBtn.layer.cornerRadius = 15.f;
        
    }
    return _clearBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = RGBColor(0, 191, 255);
        _confirmBtn.titleLabel.font = kBoldFont(15.f);
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = 15.f;
    }
    return _confirmBtn;
}

@end
