#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{
    
    NSString *vsString = @"-----------";
    void (^block)() =  ^{
        NSLog(@"VS Study Block! %@",vsString);
    };
    
    block();
    
    
    return 0;
}