//
//  VSARCBlockViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSARCBlockViewController.h"
#import "VSTestBlockModel.h"


typedef void (^VoidBlockVoid)();

static VSTestBlockModel *staticVar = nil;


@interface VSARCBlockViewController ()
{
    // VSTestBlockModel *_tbmPropertyVar;
    
}

@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) VSTestBlockModel *tbmProperty;

@property (nonatomic, strong) VSTestBlockModel *tbmPropertyVar;



@property (nonatomic, copy) VoidBlockVoid blockProperty; // copy ,block 不是对象二十代码块地址

@end

@implementation VSARCBlockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _buttonTitles = @[@"__weak block",@"System block",@"Porperty block",@"Static var",@"Function return block"];
    [Common creatButtonWith:_buttonTitles target:self action:@selector(buttonClickEvent:)];
    
    staticVar = [[VSTestBlockModel alloc] initWith:@"Static var"];
    
    
    
    _tbmPropertyVar = [[VSTestBlockModel alloc] initWith:@"init property var"];

    
}

- (void)buttonClickEvent:(UIButton *)button
{
    NSLog(@"tag = %ld",button.tag);
    switch (button.tag) {
        case 0: [self test__Weak__Strong]; break;
        case 1: [self testSystemBlock]; break;
        case 2: [self testPropertys]; break;
        case 3: [self testStaticVar]; break;
        case 4: [self testFunctionReturnBlock]; break;
        default: break;
    }
}


- (void)test__Weak__Strong
{
    VSTestBlockModel *tbm = [self creatTestBlockModelWith:@"__weak & __strong"];
    
    typeof(tbm) __weak weakTbm = tbm;
    VoidBlockVoid block1 = ^{ NSLog(@"tbm0 = %@",weakTbm); };
    VoidBlockVoid block2 = ^{
        typeof(weakTbm) __strong strongTbm = weakTbm;
        NSLog(@"tbm1 = %@",strongTbm);};
    
    block1(); // ......1
    block2(); // ......2
    tbm = nil;// ......3
    block1(); // ......4
    block2(); // ......5
    
    /*
     tbm0 = __weak & __strong ----------1
     tbm1 = __weak & __strong ----------2
     __weak & __strong delloc ----------3
     tbm0 = (null) ---------------------4
     tbm1 = (null) ---------------------5
     */
    
    /* 在ARC下，使用block会安全很多，
     很多时候不用使用__weak & __strong 也不会出现问题，
     但是尽量都使用上面block2的写法，以防出现内存泄漏 或发生crash
     */
}



- (void)testPropertys
{
    NSLog(@"**********************");
    
    VSTestBlockModel *tbmOne = [[VSTestBlockModel alloc] initWith:@"one"];
    VoidBlockVoid tmBlock1 = ^{
        NSLog(@"tm = %@",tbmOne);
    } ;
    NSLog(@"blockOne = %@",tmBlock1);  // ........................1
    tmBlock1(); // ...............................................2
    tbmOne = nil; // .............................................3
    tmBlock1(); // ...............................................2.1

    NSLog(@"**********************");
    
    _tbmProperty = [[VSTestBlockModel alloc] initWith:@"Two"];
    VoidBlockVoid tmBlock2 = ^{
        NSLog(@"tm = %@",_tbmProperty);
    } ;
    NSLog(@"blockTwo = %@",tmBlock2); // .........................4
    tmBlock2(); // ...............................................5
    _tbmProperty = nil; // .......................................6
    tmBlock2(); // ...............................................7
    
    NSLog(@"**********************");
    
    VSTestBlockModel *tmbThree = [[VSTestBlockModel alloc] initWith:@"three"];
    _blockProperty = ^{
        NSLog(@"tm = %@",tmbThree);
    } ;
    NSLog(@"blockThree = %@",_blockProperty); // ..................8
    _blockProperty(); // ..........................................9
    tmbThree = nil; // ............................................10
    
    NSLog(@"**********************");

    
    NSLog(@"blockFour = %@",^{NSLog(@"This is block four");}); // .....................11

    NSLog(@"blockFive = %@",^{NSLog(@"This is block Five %@",staticVar);}); // ........12

    NSLog(@"blockSix = %@",^{NSLog(@"This is block Six %@",_tbmPropertyVar);}); // ....13

    VSTestBlockModel *tmbSeven = [[VSTestBlockModel alloc] initWith:@"Seven"];
    NSLog(@"blockSix = %@",^{NSLog(@"This is block four %@",tmbSeven);}); // ..........14
    tmbSeven = nil; // ................................................................15
    
    /* log
     blockOne = <__NSMallocBlock__: 0x7ff599e090d0>  ----1
     tm = one -------------------------------------------2
     tm = one -------------------------------------------2.1
     **********************
     blockTwo = <__NSMallocBlock__: 0x7ff599f51500> -----4
     tm = Two -------------------------------------------5
     Two delloc -----------------------------------------6
     tm = (null) ----------------------------------------7
     **********************
     blockThree = <__NSMallocBlock__: 0x7ff599f17540> ---8
     tm = three -----------------------------------------9
     
     **********************
     
     blockFour = <__NSGlobalBlock__: 0x109ade1c0> ------11
     
     blockFive = <__NSGlobalBlock__: 0x109ade200> ------12
     
     blockSix = <__NSStackBlock__: 0x7fff56125a10> -----13
     
     blockSix = <__NSStackBlock__: 0x7fff561259e0> -----14
     
     Seven delloc --------------------------------------15
     
     one delloc ----------------------------------------3
     */
    
    // 在ARC下，1,4,8 在赋值给变量时，会被自动copy到堆上
    // 在ARC下，11 block 不赋值给变量，也不获取任何外部变量
    // 在ARC下，12 block 不赋值给变量，捕获静态区域变量， 没有局部变量的骚扰，运行不依赖上下文，内存管理也简单的多
    // 在ARC下，13 block 不赋值给变量，捕获成员变量，作用域只在本类范围内
    // 在ARC下，14 block 不赋值给变量，捕获栈区域变量，作用域只在本方法内
    
    // 在ARC下，2, 2.1, 3 局域block捕获的局域变量，在执行结束时block会自动释放
    // 在ARC下，5, 6, 7 block在捕获成员变量时，不会copy变量，而是直接读取其内存内容
    
    // 在ARC下， 8, 9 没有输出 three dealloc，说明成员block会捕获其外部变量，当self被释放时才输出
}




- (void)testSystemBlock
{
    // 系统提供的block
    NSArray *arr = @[@"0",@"1",@"2"];
    VSTestBlockModel *tbmArr = [[VSTestBlockModel alloc] initWith:@"test NSArray"];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj = %@, idx = %ld, tbmArr = %@",obj,idx,tbmArr);
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"dispathc arr = %@",tbmArr);
    });
    int index = 0;
    while (++index < 10) {
        tbmArr = nil;
        NSLog(@"index = %d, tbmArr = %@",index,tbmArr);
    }
    // tbmArr = nil;
    
    NSLog(@"test finished");
    
    /*
     obj = 0, idx = 0, tbmArr = test NSArray
     obj = 1, idx = 1, tbmArr = test NSArray -------1
     obj = 2, idx = 2, tbmArr = test NSArray
     
     index = 1, tbmArr = (null)  --------------------------2
     
     dispathc arr = test NSArray // 异步 位置可能在循环之前 ---3
     
     index = 2, tbmArr = (null) ---------------------------2
     
     test finished --------------------------------4
     test NSArray delloc --------------------------5
     */
    
    /* ARC
     
     2 & 3 ，系统block会把捕获的外部变量 复制到堆上
     
     最后输出了 test NSArray delloc, 可见系统的block会在当前代码块结束时自动释放，
     没必要刻意去使用 __weak 避免内存泄漏，尽管如此，但还是建议使用 __weak，以防万一
     */
    
}

- (void)testStaticVar
{
    VoidBlockVoid testBlock = ^{
        NSLog(@"tm = %@",staticVar);
        staticVar = [[VSTestBlockModel alloc] initWith:@"modify static var"];
        NSLog(@"block finished");
    } ;
    NSLog(@"before staticInt = %@",staticVar); // ......1
    testBlock(); // ....................................2
    NSLog(@"after staticInt = %@",staticVar); // .......3
    staticVar = nil; // ................................4
    testBlock(); // ....................................5
    NSLog(@"staticVar = %@",staticVar); // .............6
    /*
     before staticInt = Static var  --------1
     
     tm = Static var
     Static var delloc ---------------------2
     block finished
     
     after staticInt = modify static var ---3
     
     modify static var delloc --------------4
     
     tm = (null) ---------------------------5
     block finished
     
     staticVar = modify static var ---------6
     */
    
    // 在ARC下
    // 2&5 之后，3&6的log，static 变量可以被修改
    // 4 之后，5的log，ARC下 static变量被引用其地址内容
    
    
    
    NSLog(@"*******************************");
    
    _tbmPropertyVar = [[VSTestBlockModel alloc] initWith:@"Property var"];
    VoidBlockVoid testBlockProperty = ^{
        NSLog(@"tm = %@",_tbmPropertyVar);
        _tbmPropertyVar = [[VSTestBlockModel alloc] initWith:@"modify Property var"];
        NSLog(@"block finished");
    } ;
    NSLog(@"before _tbmPropertyVar = %@",_tbmPropertyVar); // ....7
    testBlockProperty(); // ......................................8
    NSLog(@"after _tbmPropertyVar = %@",_tbmPropertyVar); // .....9
    _tbmPropertyVar = nil; // ....................................10
    testBlockProperty(); // ......................................11
    NSLog(@"staticVar = %@",_tbmPropertyVar); // .................12
    /*
     before _tbmPropertyVar = Property var -----------7
     
     tm = Property var
     Property var delloc -----------------------------8
     block finished
     
     after _tbmPropertyVar = modify Property var -----9
     
     modify Property var delloc ----------------------10
     
     tm = (null) -------------------------------------11
     block finished
     
     staticVar = modify Property var -----------------12
     */
    
    // 在ARC下，成员变量可以被修改，也是引用的地址内容（会不会怎加变量的引用计数？应该不会，待验证）
    
    // 全局变量或静态变量在内存中的地址是固定的，Block在读取该变量值的时候是直接从其所在内存读出，获取到的是最新值，而不是在定义时copy的常量
}


- (void)testFunctionReturnBlock
{
    NSLog(@"block0 = %@",[self getVoidBlockVoid]); // ..................1
    VoidBlockVoid block1 = [self getVoidBlockVoid];
    NSLog(@"block1 = %@",block1);// ....................................2
    block1();// ........................................................3
    
    NSLog(@"block2 = %@",[self getVoidBlockVoidReferenceVar]); // ......4
    VoidBlockVoid block3 = [self getVoidBlockVoidReferenceVar];
    NSLog(@"block3 = %@",block3); // ...................................5
    block3(); // .......................................................6

    
    VSTestBlockModel *tbm = [self creatTestBlockModelWith:@"Function parameter"];
    NSLog(@"block4 = %@",[self getVoidBlockVoidWith:tbm]); // ..........7
    VoidBlockVoid block5 = [self getVoidBlockVoidWith:tbm];
    NSLog(@"block5 = %@",block5); // ...................................8
    block5(); // .......................................................9
    
    
    // 在ARC下 log
    /*
     block0 = <__NSGlobalBlock__: 0x103e40370> ------1
     block1 = <__NSGlobalBlock__: 0x103e40370> ------2
     This is a block as return value-----------------3
     block2 = <__NSMallocBlock__: 0x7f9f03c2ffa0> ---4
     Function var delloc -----------------------------------
     block3 = <__NSMallocBlock__: 0x7f9f03f34c30> ---5
     tbm = Function var -----------------------------6
     block4 = <__NSMallocBlock__: 0x7f9f03f4b420> ---7
     block5 = <__NSMallocBlock__: 0x7f9f03e23b30> ---8
     tbm = Function parameter -----------------------9
     Function parameter delloc -----------------------------
     Function var delloc -----------------------------------
     */
    
    // 1, 2
    
    
}

- (VoidBlockVoid)getVoidBlockVoid
{
    return ^{
        NSLog(@"This is a block as return value");
    };
}

- (VoidBlockVoid)getVoidBlockVoidReferenceVar
{
    VSTestBlockModel *tbm = [self creatTestBlockModelWith:@"Function var"];
    return ^{
        NSLog(@"tbm = %@",tbm);
    };
}


- (VoidBlockVoid)getVoidBlockVoidWith:(VSTestBlockModel *)tbm
{
    return ^{
        NSLog(@"tbm = %@",tbm);
    };
}




- (VSTestBlockModel *)creatTestBlockModelWith:(NSString *)name
{
    return [[VSTestBlockModel alloc] initWith:name];
}


@end
