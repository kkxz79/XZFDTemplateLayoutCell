//
//  XZFeedEntity.m
//  XZFDTemplateLayoutCell
//
//  Created by kkxz on 2018/12/10.
//  Copyright © 2018 kkxz. All rights reserved.
//

#import "XZFeedEntity.h"

@implementation XZFeedEntity

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        _identifier = [self uniqueIdentifier];
        _title = dictionary[@"title"];
        _content = dictionary[@"content"];
        _username = dictionary[@"username"];
        _time = dictionary[@"time"];
        _imageName = dictionary[@"imageName"];
    }
    return self;
}


-(NSString*)uniqueIdentifier {
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@",@(counter++)];
}

@end
