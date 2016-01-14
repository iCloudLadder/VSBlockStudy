//
//  VSMRCBlockViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSMRCBlockViewController.h"
#import "VSTestBlockModel.h"


typedef void (^VoidBlockVoid)();

static VSTestBlockModel *staticVar = nil;


@interface VSMRCBlockViewController ()
{
    // VSTestBlockModel *_tbmPropertyVar;
    
}

@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, strong) VSTestBlockModel *tbmProperty;

@property (nonatomic, strong) VSTestBlockModel *tbmPropertyVar;



@property (nonatomic, copy) VoidBlockVoid blockProperty; // copy ,block 不是对象二十代码块地址

@end

@implementation VSMRCBlockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    
    _buttonTitles = @[@"__block block",@"System block",@"Porperty block",@"Static var",@"Function return block",@"block as parameter"];
    [Common creatButtonWith:_buttonTitles target:self action:@selector(buttonClickEvent:)];
    
    staticVar = [[VSTestBlockModel alloc] initWith:@"Static var"];
    
    
    
    _tbmPropertyVar = [[VSTestBlockModel alloc] initWith:@"init property var"];

    
}

- (void)buttonClickEvent:(UIButton *)button
{
    NSLog(@"tag = %ld",button.tag);
    switch (button.tag) {
        case 0: [self test__block]; break;
        case 1: [self testSystemBlock]; break;
        case 2: [self testPropertys]; break;
        case 3: [self testStaticVar]; break;
        case 4: [self testFunctionReturnBlock]; break;
        case 5: [self testBlockAsParameter]; break;
        default: break;
    }
}


- (void)test__block
{
    VSTestBlockModel *tbm = [self creatTestBlockModelWith:@"__block1"];

    VoidBlockVoid block1 = ^{ NSLog(@"tbm1 = %@",tbm); };
    block1(); // ......1
    [tbm release];// ......2
    tbm = [self creatTestBlockModelWith:@"motify __block1"];
    block1(); // ......3
    
    
    VSTestBlockModel *tbm2 = [self creatTestBlockModelWith:@"__block2"];
    VoidBlockVoid block2 = [^{
        NSLog(@"tbm2 = %@",tbm2);} copy];
    
    block2(); // ......4
    [tbm2 release];// ......5
    tbm2 = [self creatTestBlockModelWith:@"motify __block2"];
    block2(); // ......6
    
    
    __block VSTestBlockModel *tbm3 = [self creatTestBlockModelWith:@"__block3"];
    VoidBlockVoid block3 = [^{
        NSLog(@"tbm3 = %@",tbm3);} copy];
    
    block3(); // ......7
    [tbm3 release];// ......8
    tbm3 = [self creatTestBlockModelWith:@"motify __block3"];
    block3(); // ......9
    
    Block_release(block2); //.....10
    
    /*
     tbm1 = __block1  -----------1
     __block1 delloc ------------2
     tbm1 = *nil description* ---3
     
     tbm2 = __block2 ------------4
     tbm2 = __block2 ------------6
     
     tbm3 = __block3 ------------7
     __block3 delloc ------------8
     tbm3 = motify __block3 -----9
     
     __block2 delloc ------------10 ,5
     */
    
    /* 在MRC下 block不会被自动copy ,也不会自动释放(除apple提供的接口中的block)
     __block 变量让block直接从变量的内存地址 *读 * 写* 数据
      非_block变量 会copy外部变量，而且只能读取，不能修改
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
    [tbmOne release]; // .............................................3
    tmBlock1(); // ...............................................2.1

    NSLog(@"**********************");
    
    self.tbmProperty = [[VSTestBlockModel alloc] initWith:@"Two"];
    VoidBlockVoid tmBlock2 = ^{
        NSLog(@"tm = %@",_tbmProperty);
    } ;
    NSLog(@"blockTwo = %@",tmBlock2); // .........................4
    tmBlock2(); // ...............................................5
    [_tbmProperty release]; // .......................................6
    tmBlock2(); // ...............................................7
    
    NSLog(@"**********************");
    
    VSTestBlockModel *tmbThree = [[VSTestBlockModel alloc] initWith:@"three"];
    self.blockProperty = ^{
        NSLog(@"tm = %@",tmbThree);
    } ;
    NSLog(@"blockThree = %@",_blockProperty); // ..................8
    _blockProperty(); // ..........................................9
    // [tmbThree release]; __block 修饰 tmbThree时使用
    tmbThree = [[VSTestBlockModel alloc] initWith:@"motify three"];
    _blockProperty(); // ...............................................17
    [tmbThree release]; // ............................................10
    
    NSLog(@"**********************");

    
    NSLog(@"blockFour = %@",^{NSLog(@"This is block four");}); // .....................11

    NSLog(@"blockFive = %@",^{NSLog(@"This is block Five %@",staticVar);}); // ........12

    NSLog(@"blockSix = %@",^{NSLog(@"This is block Six %@",_tbmPropertyVar);}); // ....13

    VSTestBlockModel *tmbSeven = [[VSTestBlockModel alloc] initWith:@"Seven"];
    NSLog(@"blockSix = %@",^{NSLog(@"This is block four %@",tmbSeven);}); // ..........14
    [tmbSeven release]; // ................................................................15
    
    NSLog(@"blockSix = %@",[^{NSLog(@"This is block Six %@",_tbmPropertyVar);} copy]); // ....16

    
    
    Block_release(self.blockProperty); // .............................................18
    
    /* log
     blockOne = <__NSStackBlock__: 0x7fff57bdabe8>  -----1
     tm = one -------------------------------------------2
     one delloc -----------------------------------------3
     tm = *nil description* -----------------------------3.1
     **********************
     blockTwo = <__NSStackBlock__: 0x7fff57bdabb8> ------4
     tm = Two -------------------------------------------5
     Two delloc -----------------------------------------6
     tm = *nil description* -----------------------------7
     **********************
     blockThree = <__NSMallocBlock__: 0x7fde09f2f300> ---8
     tm = three -----------------------------------------9
     
     tm = three -----------------------------------------17 // 修改后输出依然是修改前的值
     motify three delloc --------------------------------10
     **********************
     
     blockFour = <__NSGlobalBlock__: 0x10802b240> ------11
     
     blockFive = <__NSGlobalBlock__: 0x10802b280> ------12
     
     blockSix = <__NSStackBlock__: 0x7fff57bdab60> -----13
     
     blockSix = <__NSStackBlock__: 0x7fff57bdab30> -----14
     
     Seven delloc --------------------------------------15
     
     blockSix = <__NSMallocBlock__: 0x7fda42c380a0> ----16
     
     three delloc --------------------------------------18
     */
    
    // 在MRC下，1,4,8,13,14 在赋值给变量时，不会被自动copy到堆上,而是在栈内， 16 经过copy后才到堆
    // 在MRC下，11 block 不赋值给变量，也不获取任何外部变量
    // 在MRC下，12 block 不赋值给变量，捕获静态区域变量， 没有局部变量的骚扰，运行不依赖上下文，内存管理也简单的多
    
    // 在MRC下，2,3,3.1 - 5,6,7 位于栈内的block并没有捕获栈内的变量(看 testFunctionReturnBlock)
    // 在MRC下，5, 6, 7 block在捕获成员变量时，不会copy变量，而是直接读取其内存内容
    
    // 在MRC下， 17 ，18 在block被copy到堆上时，捕获外部变量,
    // 若tmbThree是__block变量,则17 输出 tm = motify three,18不会输出,内存无法释放
    
    

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
        if (index == 1) {
            [tbmArr release]; // ................... 10
            tbmArr = [[VSTestBlockModel alloc] initWith:@"motify"];
        }
        NSLog(@"index = %d tbmArr = %@",index,tbmArr);
    }
    // tbmArr = nil;
    
    NSLog(@"test finished");
    
    /*
     obj = 0, idx = 0, tbmArr = test NSArray
     obj = 1, idx = 1, tbmArr = test NSArray -------1
     obj = 2, idx = 2, tbmArr = test NSArray
     
     index = 1 tbmArr = motify ---------------------------2
     index = 2 tbmArr = motify ---------------------------2

     dispathc arr = test NSArray // 异步 位置不定(会出现在次) ---3
     
     index = 3 tbmArr = motify ---------------------------2
     index = 4 tbmArr = motify ---------------------------2

     test NSArray delloc --------------------------4 // 异步 位置不定 (会出现在次)
     
     test finished --------------------------------5
     */
    
    /* MRC
     
     4 没有在第一次循环时输出，系统block捕获了外部变量
     
     4 在 3 后输出， 系统block使用结束后会在动释放
     
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
    [staticVar release]; // ................................4
    testBlock(); // ....................................5
    NSLog(@"staticVar = %@",staticVar); // .............6
    /*
     before staticInt = Static var  --------1
     
     tm = Static var
     Static var delloc ---------------------2
     block finished
     
     after staticInt = modify static var ---3
     
     modify static var delloc --------------4
     
     tm = *nil description* ---------------------------5
     block finished
     
     staticVar = modify static var ---------6
     */
    
    // 在MRC下 和ARC基本相同
    // 2&5 之后，3&6的log，static 变量可以被修改
    // 4 之后，5的log，MRC下 static变量被引用其地址内容
    
    
    
    NSLog(@"*******************************");
    
    __block typeof(self) weakSelf = self;
    self.tbmPropertyVar = [[[VSTestBlockModel alloc] initWith:@"Property var"] autorelease];
    VoidBlockVoid testBlockProperty = ^{
        NSLog(@"tm = %@",_tbmPropertyVar);
        weakSelf.tbmPropertyVar = [[VSTestBlockModel alloc] initWith:@"modify Property var"];
        NSLog(@"block finished");
    } ;
    NSLog(@"before _tbmPropertyVar = %@",_tbmPropertyVar); // ....7
    testBlockProperty(); // ......................................8
    NSLog(@"after _tbmPropertyVar = %@",_tbmPropertyVar); // .....9
    [_tbmPropertyVar release]; // ....................................10
    testBlockProperty(); // ......................................11
    NSLog(@"staticVar = %@",_tbmPropertyVar); // .................12
    
    Block_release(testBlockProperty);
    /*
     before _tbmPropertyVar = Property var -----------7
     
     tm = Property var
     block finished
     
     after _tbmPropertyVar = modify Property var -----9
     
     modify Property var delloc ----------------------10
     
     tm = *nil description* -------------------------------------11
     block finished
     
     staticVar = modify Property var -----------------12
     
     Property var delloc -----------------------------8

     */
    // 与ARC 不同的是 8 在最后输出
    
    // 在MRC下，成员变量可以被修改，也是引用的地址内容（会不会怎加变量的引用计数？应该不会，待验证）
    
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
    
    
    // 在MRC下 log
    /*
    
     不能直接返回 栈内的block，因栈内的block 出了次函数后被释放
     */
    
    // 1, 2
    
    
}

- (VoidBlockVoid)getVoidBlockVoid
{
    return ^{
        NSLog(@"This is a block as return value"); // 不应用外部变量，不copy时为 globalBlock
    };
}

- (VoidBlockVoid)getVoidBlockVoidReferenceVar
{
//    __block VSTestBlockModel *tbm = [self creatTestBlockModelWith:@"Function var"];
//    return ^{
//        NSLog(@"tbm = %@",tbm); error ,不能返回 栈内的block，因栈内的block 出了次函数后被释放
//    };
    
    return nil;
}


- (VoidBlockVoid)getVoidBlockVoidWith:(VSTestBlockModel *)tbm
{
//    return ^{
//        NSLog(@"tbm = %@",tbm); error ,不能返回 栈内的block，因栈内的block 出了次函数后被释放
//    };
    return nil;
}



- (void)testBlockAsParameter
{
    [self printBlockTypeWith:^{ //  __NSGlobalBlock__
        NSLog(@"golbal block");
    }];
    
    [self printBlockTypeWith:^{
        NSLog(@"static var = %@",staticVar); // __NSGlobalBlock__
    }];
    
    self.tbmPropertyVar = [self creatTestBlockModelWith:@"test property var"];
    [self printBlockTypeWith:^{
        NSLog(@"property var = %@",_tbmPropertyVar); // __NSStackBlock__
    }];
    
    VSTestBlockModel *model = [self creatTestBlockModelWith:@"Stack var"];
    [self printBlockTypeWith:^{
        NSLog(@"property var = %@",model); // __NSStackBlock__
    }];

    
    
}

- (void)printBlockTypeWith:(VoidBlockVoid)block
{
    NSLog(@"block = %@",block);
}

- (VSTestBlockModel *)creatTestBlockModelWith:(NSString *)name
{
    return [[VSTestBlockModel alloc] initWith:name];
}


-(void)dealloc
{
    [super dealloc];
}

@end
