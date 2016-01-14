//
//  VSTestBlockModel.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSTestBlockModel.h"

@interface VSTestBlockModel ()

@property (nonatomic, copy) NSString *name;


@end

@implementation VSTestBlockModel

- (instancetype)initWith:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (NSString *)description
{
    return _name;
}

- (void)dealloc
{
    NSLog(@"%@ delloc",self);
}

@end
