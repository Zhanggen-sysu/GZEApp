//
//  GZEDetailListCellVM.m
//  GZEApp
//
//  Created by GenZhang on 2023/12/8.
//

#import "GZEDetailListCellVM.h"
#import "GZETVListItem.h"
#import "GZEMovieListItem.h"
#import "GZECommonHelper.h"
#import "GZEEnum.h"

@interface GZEDetailListCellVM ()

@property (nonatomic, strong, readwrite) UIColor *magicColor;
@property (nonatomic, strong, readwrite) UIColor *nameColor;
@property (nonatomic, strong, readwrite) NSURL *posterUrl;
@property (nonatomic, assign, readwrite) NSAttributedString *ratingString;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) RACCommand *tapCommand;
@property (nonatomic, strong, readwrite) RACSubject *jumpTVSubject;
@property (nonatomic, strong, readwrite) RACSubject *jumpMovieSubjec;

@end

@implementation GZEDetailListCellVM

- (instancetype)initWithTVListItem:(GZETVListItem *)tvItem magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        self.magicColor = magicColor;
        self.name = tvItem.name;
        self.posterUrl = [GZECommonHelper getPosterUrl:tvItem.posterPath size:GZEPosterSize_w342];
        if (CGColorEqualToColor(magicColor.CGColor, [UIColor whiteColor].CGColor)) {
            self.nameColor = [UIColor blackColor];
        }
        self.ratingString = [self ratingString:tvItem.voteAverage];
        self.tapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [self.jumpTVSubject sendNext:RACTuplePack(@(GZEMediaType_TV), @(tvItem.identifier))];
            return [RACSignal empty];
        }];
    }
    return self;
}

- (instancetype)initWithMovieListItem:(GZEMovieListItem *)movieItem magicColor:(UIColor *)magicColor
{
    if (self = [super init]) {
        self.magicColor = magicColor;
        self.name = movieItem.title;
        self.posterUrl = [GZECommonHelper getPosterUrl:movieItem.posterPath size:GZEPosterSize_w342];
        if (CGColorEqualToColor(magicColor.CGColor, [UIColor whiteColor].CGColor)) {
            self.nameColor = [UIColor blackColor];
        }
        self.ratingString = [self ratingString:movieItem.voteAverage];
        self.tapCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [self.jumpTVSubject sendNext:RACTuplePack(@(GZEMediaType_Movie), @(movieItem.identifier))];
            return [RACSignal empty];
        }];
    }
    return self;
}

- (NSAttributedString *)ratingString:(double)voteAverage
{
    NSMutableAttributedString *ratingStr = [[NSMutableAttributedString alloc] init];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = kGetImage(@"starFullIcon");
    attach.bounds = CGRectMake(0, -2, 14.f, 14.f);
    NSDictionary *attri = @{
        NSFontAttributeName: kFont(14.f),
        NSForegroundColorAttributeName: RGBColor(255, 215, 0)
    };
    [ratingStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [ratingStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %.1f", voteAverage] attributes:attri]];
    return ratingStr;
}

@end
