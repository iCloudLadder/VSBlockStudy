//
//  Common.h
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject

+ (void)creatButtonWith:(NSArray *)titles target:(UIViewController *)viewController action:(SEL)action;
+ (void)setViewControllerSomePropertyWith:(UIViewController *)viewController;


@end
