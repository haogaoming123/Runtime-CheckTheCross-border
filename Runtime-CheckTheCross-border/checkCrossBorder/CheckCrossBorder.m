//
//  CheckCrossBorder.m
//  Runtime-CheckTheCross-border
//
//  Created by haogaoming on 2017/2/21.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "CheckCrossBorder.h"
#import <objc/runtime.h>

/// 是否显示崩溃日志
static BOOL showLogEnabled = YES;

#pragma make----
#pragma 书写打印函数---
/// 输出函数宏定义
#define SAFETYLOG(...) safetyLogShow(__VA_ARGS__)

void safetyLogShow(NSString * format, ...)
{
    if (!showLogEnabled) {
        return;
    }
    va_list ap;
    va_start(ap, format);
    NSString *content = [[NSString alloc] initWithFormat:format arguments:ap];
    NSLog(@"%@", content);
    va_end(ap);
}
#pragma ---end


#pragma make-------
#pragma 数组的安全方法
@interface NSArray (safety)

@end

@implementation NSArray (safety)

+(Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayI"), selector);
}

-(id)safety_objectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        SAFETYLOG(@"发生崩溃：[%@  %@] 找不到这个index={%lu}的值，因为不在[0...%lu]区间",NSStringFromClass([self class]),NSStringFromSelector(_cmd),(unsigned long)index,MAX((unsigned long)self.count-1, 0));
        return nil;
    }
    return [self safety_objectAtIndex:index];
}
@end

@interface NSMutableArray (safety)

@end

@implementation NSMutableArray (safety)

+(Method)methodOfSelectorM:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), selector);
}

-(id)safety_objectAtIndexM:(NSUInteger)index
{
    if (index >= self.count) {
        SAFETYLOG(@"发生崩溃：[%@  %@] 找不到这个index={%lu}的值，因为不在[0...%lu]区间",NSStringFromClass([self class]),NSStringFromSelector(_cmd),(unsigned long)index,MAX((unsigned long)self.count-1, 0));
        return nil;
    }
    return [self safety_objectAtIndexM:index];
}

-(void)safety_addObject:(id)anObject
{
    if (!anObject) {
        SAFETYLOG(@"发生崩溃：[%@  %@]操作object为nil",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        return;
    }
    [self safety_addObject:anObject];
}
@end
#pragma --end

#pragma make-------
#pragma 字典的安全方法
@interface NSMutableDictionary (safety)

@end

@implementation NSMutableDictionary (safety)

+(Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"), selector);
}

-(void)safety_setObject:(id)anObject forKey:(id <NSCopying>)aKey
{
    if (!anObject) {
        SAFETYLOG(@"发生崩溃：[%@  %@]操作object为nil",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        return;
    }
    if (!aKey) {
        SAFETYLOG(@"发生崩溃：[%@  %@]操作key为nil",NSStringFromClass([self class]),NSStringFromSelector(_cmd));
        return;
    }
    [self safety_setObject:anObject forKey:aKey];
}

@end
#pragma ---end

@implementation CheckCrossBorder

+(void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NSArry
        method_exchangeImplementations([NSArray methodOfSelector:@selector(objectAtIndex:)], [NSArray methodOfSelector:@selector(safety_objectAtIndex:)]);
        //NSMutableArry
        method_exchangeImplementations([NSMutableArray methodOfSelectorM:@selector(objectAtIndex:)], [NSMutableArray methodOfSelectorM:@selector(safety_objectAtIndexM:)]);
        //NSMutableArry--addobject
        method_exchangeImplementations([NSMutableArray methodOfSelectorM:@selector(addObject:)], [NSMutableArray methodOfSelectorM:@selector(safety_addObject:)]);
        
        //NSMutableDictionary
        method_exchangeImplementations([NSMutableDictionary methodOfSelector:@selector(setObject:forKey:)], [NSMutableDictionary methodOfSelector:@selector(safety_setObject:forKey:)]);
    });
}

+(void)setXcodeSafetyLog:(BOOL)enabled
{
    showLogEnabled = enabled;
}
@end

