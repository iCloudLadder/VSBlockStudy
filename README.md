# VSBlockStudy

 官方文档
 https://developer.apple.com/library/prerelease/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithBlocks/WorkingwithBlocks.html#//apple_ref/doc/uid/TP40011210-CH8
 
 runtime openSource
 http://opensource.apple.com/source/objc4/objc4-680/runtime/

# block 的存储
 1. NSStackBlock：位于栈内存，函数返回后Block将无效
    在超出 NSStackBlock 的使用周期外使用，*必须copy*， retain和release无效
 2. NSMallocBlock：位于堆内存。
    可以retain、release，但是retainCount始终是1，而内存管理器中仍然会增加、减少计数。(在任何情况下，尽量不要使用retainCount，计数不一定准确)
    copy之后不会再生成新的block，只是增加了一次引用，类似retain；
 
 3. NSGlobalBlock：类似函数，位于数据段
    retain、copy、release操作都无效
 


 __block 修饰的变量，在block中是以 *变量地址* 的形式存在的，类似函数的实参
 MRC中__block是不会引起retain；但在ARC中__block则会引起retain。
 ARC中应该使用__weak或__unsafe_unretained弱引用。__weak只能在iOS5以后使用。
 


 
 #  delegate & block 区别
 
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
 

