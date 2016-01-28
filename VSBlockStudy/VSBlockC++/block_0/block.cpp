// 看runtime官方开源 http://opensource.apple.com/source/objc4/objc4-680/runtime/
struct objc_selector; struct objc_class;
struct __rw_objc_super { struct objc_object *object; struct objc_object *superClass; };
#ifndef _REWRITER_typedef_Protocol
typedef struct objc_object Protocol;
#define _REWRITER_typedef_Protocol
#endif
#define __OBJC_RW_DLLIMPORT extern
__OBJC_RW_DLLIMPORT struct objc_object *objc_msgSend(struct objc_object *, struct objc_selector *, ...);
__OBJC_RW_DLLIMPORT struct objc_object *objc_msgSendSuper(struct objc_super *, struct objc_selector *, ...);
__OBJC_RW_DLLIMPORT struct objc_object* objc_msgSend_stret(struct objc_object *, struct objc_selector *, ...);
__OBJC_RW_DLLIMPORT struct objc_object* objc_msgSendSuper_stret(struct objc_super *, struct objc_selector *, ...);
__OBJC_RW_DLLIMPORT double objc_msgSend_fpret(struct objc_object *, struct objc_selector *, ...);
__OBJC_RW_DLLIMPORT struct objc_object *objc_getClass(const char *);
__OBJC_RW_DLLIMPORT struct objc_class *class_getSuperclass(struct objc_class *);
__OBJC_RW_DLLIMPORT struct objc_object *objc_getMetaClass(const char *);
__OBJC_RW_DLLIMPORT void objc_exception_throw(struct objc_object *);
__OBJC_RW_DLLIMPORT void objc_exception_try_enter(void *);
__OBJC_RW_DLLIMPORT void objc_exception_try_exit(void *);
__OBJC_RW_DLLIMPORT struct objc_object *objc_exception_extract(void *);
__OBJC_RW_DLLIMPORT int objc_exception_match(struct objc_class *, struct objc_object *);
__OBJC_RW_DLLIMPORT int objc_sync_enter(struct objc_object *);
__OBJC_RW_DLLIMPORT int objc_sync_exit(struct objc_object *);
__OBJC_RW_DLLIMPORT Protocol *objc_getProtocol(const char *);
#ifndef __FASTENUMERATIONSTATE
struct __objcFastEnumerationState {
	unsigned long state;
	void **itemsPtr;
	unsigned long *mutationsPtr;
	unsigned long extra[5];
};
__OBJC_RW_DLLIMPORT void objc_enumerationMutation(struct objc_object *);
#define __FASTENUMERATIONSTATE
#endif
#ifndef __NSCONSTANTSTRINGIMPL
struct __NSConstantStringImpl {
  int *isa;
  int flags;
  char *str;
  long length;
};
#ifdef CF_EXPORT_CONSTANT_STRING
extern "C" __declspec(dllexport) int __CFConstantStringClassReference[];
#else
__OBJC_RW_DLLIMPORT int __CFConstantStringClassReference[];
#endif
#define __NSCONSTANTSTRINGIMPL
#endif
#ifndef BLOCK_IMPL
#define BLOCK_IMPL
struct __block_impl {  // block的结构
  void *isa; // 三种值， &_NSConcreteGlobalBlock ，&_NSConcreteMallocBlock ， &_NSConcreteStackBlock
  int Flags; // flags = 0, 看下面 .........0 和 .........1
  int Reserved; // 保留字段
  void *FuncPtr; // block 的实现地址 __main_block_func_0
};
// Runtime copy/destroy helper functions (from Block_private.h)
#ifdef __OBJC_EXPORT_BLOCKS // block 变量的引用
extern "C" __declspec(dllexport) void _Block_object_assign(void *, const void *, const int);
extern "C" __declspec(dllexport) void _Block_object_dispose(const void *, const int);
extern "C" __declspec(dllexport) void *_NSConcreteGlobalBlock[32];
extern "C" __declspec(dllexport) void *_NSConcreteStackBlock[32];
#else
__OBJC_RW_DLLIMPORT void _Block_object_assign(void *, const void *, const int);
__OBJC_RW_DLLIMPORT void _Block_object_dispose(const void *, const int);
__OBJC_RW_DLLIMPORT void *_NSConcreteGlobalBlock[32];
__OBJC_RW_DLLIMPORT void *_NSConcreteStackBlock[32];
#endif
#endif
#define __block
#define __weak

#define __OFFSETOFIVAR__(TYPE, MEMBER) ((long long) &((TYPE *)0)->MEMBER)
static __NSConstantStringImpl __NSConstantStringImpl_block_m_0 __attribute__ ((section ("__DATA, __cfstring"))) = {__CFConstantStringClassReference,0x000007c8,"VS Study Block!",15}; // OC 中 以 @"" 形式出现的string，是以静态变量存储的


#include <Foundation/Foundation.h> // 头文件

int main(int, const char **); // 主函数的声明

struct __main_block_impl_0 { // block 的初始化，实现入口
  struct __block_impl impl; // block变量声明
  struct __main_block_desc_0* Desc; // block 描述
    // block变量 实现
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, int flags=0) { // ...............0
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags; // 默认值0
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// block执行代码，
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {

        NSLog((NSString *)&__NSConstantStringImpl_block_m_0);
    }

// block 描述结构体
static struct __main_block_desc_0 {
  unsigned long reserved;// 保留字段
  unsigned long Block_size;// block 大小
} __main_block_desc_0_DATA = { 0, sizeof(struct __main_block_impl_0)}; // block描述的实现
int main(int argc, const char * argv[])
{
    
//   强转block       block的实现                 block的执行代码地址       block的描述
    (void (*)(void))&__main_block_impl_0((void *)__main_block_func_0, &__main_block_desc_0_DATA)(); // ..............1
    
    
    return 0;
}