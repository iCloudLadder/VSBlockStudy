//
//  NSString+VSExtendedString.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "NSString+VSExtendedString.h"

@implementation NSString (VSExtendedString)

-(BOOL)isNotEmpty
{
    if (self && [self isKindOfClass:[NSString class]] && [self length]) {
        return YES;
    }
    return NO;
}

@end
