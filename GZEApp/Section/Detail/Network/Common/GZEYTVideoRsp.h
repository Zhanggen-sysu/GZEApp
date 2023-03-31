//
//  GZEYTVideoRsp.h
//  GZEApp
//
//  Created by GenZhang on 2023/3/29.
//

#import "GZEBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GZEYTVideoRsp : GZEBaseModel

@property (nonatomic, assign) NSInteger thumbnailWidth;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, copy)   NSString *providerName;
@property (nonatomic, copy)   NSString *type;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy)   NSString *providerURL;
@property (nonatomic, copy)   NSString *html;
@property (nonatomic, copy)   NSString *authorURL;
@property (nonatomic, copy)   NSString *thumbnailURL;
@property (nonatomic, copy)   NSString *authorName;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger thumbnailHeight;
@property (nonatomic, copy)   NSString *version;
@property (nonatomic, copy)   NSString *url;
// local
@property (nonatomic, copy)   NSString *videoType;

/// 示例：
/// {"thumbnail_width":480,
/// "width":200,
/// "provider_name":"YouTube",
/// "type":"video",
/// "height":113,
/// "provider_url":"https://www.youtube.com/",
/// "html":"<iframe width=\"200\" height=\"113\" src=\"https://www.youtube.com/embed/YXN_lNZZAZA?feature=oembed\"
/// frameborder=\"0\" allow=\"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope;
/// picture-in-picture; web-share\" allowfullscreen title=\"DJ Antoine &amp; Timati feat.
/// Grigory Leps - London (Official Video HD)\"></iframe>",
/// "author_url":"https://www.youtube.com/@kontorrecords",
/// "thumbnail_url":"https://i.ytimg.com/vi/YXN_lNZZAZA/hqdefault.jpg",
/// "author_name":"Kontor.TV",
/// "title":"DJ Antoine & Timati feat. Grigory Leps - London (Official Video HD)",
/// "thumbnail_height":360,"version":"1.0","url":"https://www.youtube.com/watch?v=YXN_lNZZAZA"}

@end

NS_ASSUME_NONNULL_END
