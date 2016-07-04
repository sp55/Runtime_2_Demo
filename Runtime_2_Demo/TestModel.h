//
//  TestModel.h
//  Runtime_2_Demo
//
//  Created by admin on 16/7/4.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EmptyPropertyProperty <NSObject>
-(NSDictionary *)defaultValueForEmptyProperty;
@end


@interface TestModel : NSObject<EmptyPropertyProperty>


@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSNumber *count;
@property(nonatomic,assign)int commentCount;
@property(nonatomic,strong)NSArray *summaries;
@property(nonatomic,strong)NSDictionary *parameters;
@property(nonatomic,strong)NSSet *results;

@property(nonatomic,strong)TestModel *testModel;


//只读属性
@property(nonatomic,assign,readonly)NSString *classVersion;

//通过这个方法来实现自动生成model
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

//转换成字典
-(NSDictionary *)toDictionary;

//测试
+(void)test;



@end
