//
//  VSBlockViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSBlockViewController.h"
#import "Common.h"

@interface VSBlockViewController ()

@end

@implementation VSBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setViewControllerSomePropertyWith:self];
    
    // block 句法
    
    /*    returnValue (^ blockName) (parameters...)      */
    
    // block 类型
    
    /*   returnValue (^) (parameters...)           */
    
    // block typedef
    typedef void (^ VoidBlockVoid)(void); //  == void (^ VoidBlockVoid)(),VoidBlockVoid is void (^)(void)
    
    typedef int (^ IntBlockDoubleInt)(int, int); // IntBlockDoubleInt is  int (^)(int, int)

    
    
    
    // exmaple , no return and no parameters
    // void (^ voidBlockVoid)(void) = VoidBlockVoid voidBlockVoid
    VoidBlockVoid voidBlockVoid = ^(void){
        NSLog(@"This is a block,type is void (^) (void) ");
    };
    // 执行 block
    voidBlockVoid();
    
    // exmaple, return int and two parameters
    // int (^ twoNumbersPlus) (int, int) = IntBlockDoubleInt twoNumbersPlus
    IntBlockDoubleInt twoNumbersPlus = ^(int num1, int num2){
        int plus = num1 + num2;
        return plus;
    };
    int plus = twoNumbersPlus(2, 3);
    NSLog(@"plus = %d",plus);
    
    
    // block 使用外部变量
    NSLog(@"**************** block 使用外部变量 ****************");
    int variable = 10;
    VoidBlockVoid blockUseVariable = ^{ // (void) 可以省略
        NSLog(@"variable = %d",variable);
    };
    blockUseVariable();
    
    
    // block 修改外部变量 __block
    NSLog(@"**************** block 修改外部变量 __block ****************");
    __block int variable2 = 99;
    VoidBlockVoid blockModifyVariable = ^{ // (void) 可以省略
        NSLog(@"before variable = %d",variable2);
        variable2 = 88;
        NSLog(@"after variable = %d",variable2);
    };
    
    NSLog(@"before block variable = %d",variable2);
    blockModifyVariable();
    NSLog(@"after block variable = %d",variable2);

    
}



@end
