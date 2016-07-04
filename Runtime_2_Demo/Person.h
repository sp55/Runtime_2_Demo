//
//  Person.h
//  Runtime_2_Demo
//
//  Created by admin on 16/7/4.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol personPlayDelegate <NSObject>
-(void)giveMeBall:(NSString *)ball;
@end


@interface Person : NSObject


@property(nonatomic,weak)id<personPlayDelegate> delegate;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,assign)NSInteger age;
@property(nonatomic,assign)float height;
@property(nonatomic,copy)NSString *job;
@property(nonatomic,copy)NSString *native;



-(void)eat;
-(void)sleep;
-(NSString *)doSomeThing;
-(NSString *)doSomeOtherThing;


@end
