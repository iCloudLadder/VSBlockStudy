#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    
    NSObject *object = [[NSObject alloc] init];
    
    // __block NSObject *object = [[NSObject alloc] init];

    // __weak typeof(object) weakO = object;
    
    void(^block)() =  ^{
        NSLog(@"VS Study Block! - %@",object);
    };
    block();
    
    return 0;
}
