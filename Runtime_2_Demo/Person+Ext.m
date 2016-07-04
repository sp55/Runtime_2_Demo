//
//  Person+Ext.m
//  Runtime_2_Demo
//
//  Created by admin on 16/7/4.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "Person+Ext.h"
#import <objc/runtime.h>

@implementation Person (Ext)
char eName;

-(void)setEnglishName:(NSString *)englishName
{
    //创建关联要使用Objective - C的运行时函数：objc_setAssociatedObject
    //4个参数分别是（源对象，关键字，关联对象，关联策略）。
    objc_setAssociatedObject(self, &eName, englishName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)englishName
{
    //获取相关连得对象时使用Objc函数objc_getAssociatedObject
    return objc_getAssociatedObject(self, &eName);
}
//该方法在类或分类在第一次加载内存的时候调用

+(void)load
{
    //    方法交换
    Method originalMethod = class_getInstanceMethod([Person class], @selector(sleep));
    Method newMethod = class_getInstanceMethod([Person class], @selector(noSleep));
    
    method_exchangeImplementations(originalMethod, newMethod);
    
}

-(void)noSleep
{
    NSLog(@"睡你麻痹，起来high");
}
@end
