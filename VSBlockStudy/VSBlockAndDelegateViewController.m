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


/*
 
 block无法完全代替delegate
 
 delegate运行成本低。
 delegate是经典设计模式也就是大部分的语言都可以实现的模式，相对block出现比较早。
 delegate只是保存了一个对象指针，直接回调，没有额外消耗。
 delegate的直接回调，了解runtime 中 id objc_msgSend(id self, SEL op, ...)
 delegate相对C的函数指针，只多做了一个查表动作(类实例调用过的方法，会被缓存，相关了解struct objc_class定义中的struct objc_cache *cache)
 
 delegate的弊病在ARC之前是容易出现野指针
 delegate一般用于单纯的一对一回调，不然代码会很冗杂
 delegate优点在于运行成本低，适合运算强度较大、回调频繁的环境
 
 
 block成本高。
 block出栈需要将使用的数据从栈内存拷贝到堆内存，当然对象的话就是加计数，使用完Block_release后才消除。
 
 使用block实现委托模式，其优点是回调的block代码块定义在委托对象函数内部，使代码更为紧凑；
 适配对象不再需要实现具体某个protocol，代码更为简洁。
 
 */



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
