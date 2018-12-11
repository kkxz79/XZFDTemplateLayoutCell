//
//  XZFeedEntity.h
//  XZFDTemplateLayoutCell
//
//  Created by kkxz on 2018/12/10.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZFeedEntity : NSObject
-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@property (nonatomic, copy , readonly) NSString *identifier;
@property (nonatomic, copy , readonly) NSString *title;
@property (nonatomic, copy , readonly) NSString *content;
@property (nonatomic, copy , readonly) NSString *username;
@property (nonatomic, copy , readonly) NSString *time;
@property (nonatomic, copy , readonly) NSString *imageName;

@end

NS_ASSUME_NONNULL_END
