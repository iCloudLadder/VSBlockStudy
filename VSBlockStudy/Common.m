//
//  Common.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "Common.h"


@implementation Common

+ (void)creatButtonWith:(NSArray *)titles target:(UIViewController *)viewController action:(SEL)action
{
    [self setViewControllerSomePropertyWith:viewController];
    
    CGSize size = viewController.view.bounds.size;
    CGFloat space = 20.0;
    CGFloat height = 40.0;
    CGFloat width = size.width - 2 * space;
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat orginY = space + (space + height) * idx;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(space, orginY, width, height);
        [button setTitle:title forState:UIControlStateNormal];
        button.backgroundColor = [UIColor orangeColor];
        button.tag = idx;
        [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
        [viewController.view addSubview:button];
    }];
}


+ (void)setViewControllerSomePropertyWith:(UIViewController *)viewController
{
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.edgesForExtendedLayout = UIRectEdgeNone;
    viewController.navigationController.navigationBar.translucent = NO;
}

@end
