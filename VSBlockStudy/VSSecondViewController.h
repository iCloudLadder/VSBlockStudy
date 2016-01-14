//
//  VSSecondViewController.h
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/14.
//  Copyright © 2016年 VS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VSGobackInputText <NSObject>

- (void)getInputTextWith:(NSString *)text;

@end

@interface VSSecondViewController : UIViewController

@property (nonatomic, assign) id<VSGobackInputText> delegate;

@property (nonatomic, copy) void (^inputText) (NSString *text);

@end
