//
//  VSBlockAndDelegateViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/14.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSBlockAndDelegateViewController.h"
#import "Common.h"
#import "VSSecondViewController.h"

@interface VSBlockAndDelegateViewController ()<VSGobackInputText>

@property (nonatomic, strong) UILabel *scanLabel;

@end

@implementation VSBlockAndDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [Common creatButtonWith:@[@"Block",@"Delegate"] target:self action:@selector(buttonClickedEvent:)];
    
    
    [self creatScanLable];
}

- (void)buttonClickedEvent:(UIButton *)button
{
    VSSecondViewController *svc = [[VSSecondViewController alloc] init];
    switch (button.tag) {
        case 0:{
                    typeof(self) __weak weakSelf = self;
                    svc.inputText = ^(NSString *text){
                        typeof(weakSelf) __strong  strongSelf = weakSelf;
                        strongSelf.scanLabel.text = text;
                    };
                }
            break;
        case 1:
            svc.delegate = self;
            break;

            
        default:
            break;
    }
    
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)getInputTextWith:(NSString *)text
{
    _scanLabel.text = text;
}


- (void)creatScanLable
{
    self.scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, CGRectGetWidth(self.view.frame) - 40, 100)];
    _scanLabel.text = @"Start Value";
    _scanLabel.numberOfLines = 0;
    _scanLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _scanLabel.center = self.view.center;
    [self.view addSubview:_scanLabel];
}

@end
