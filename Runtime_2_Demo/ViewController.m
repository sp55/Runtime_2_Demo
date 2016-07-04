//
//  ViewController.m
//  Runtime_2_Demo
//
//  Created by admin on 16/7/4.
//  Copyright © 2016年 AlezJi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Person+Ext.h"
#import "TestModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()<personPlayDelegate>
@property(nonatomic,strong)Person *student;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray *titlesArr= @[@"获取类的成员变量",@"获取类的全部属性名",@"获取类的全部方法",@"获取类遵守的全部协议",@"动态改变成员变量",@"动态交换类方法",@"动态添加方法",@"动态为Category扩展加属性",@"更便捷的归档解档",@"字典转Model"];

    for (NSInteger i=0; i<titlesArr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(30, 30+40*i, self.view.frame.size.width-60, 30);
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
    
    /*
     runtime是一套底层的C语言API，包含很多强大实用的C语言数据类型和C语言函数，平时我们编写的OC代码，底层都是基于runtime实现的。
     */
    self.student = [[Person alloc]init];
    
}
-(void)btnAction:(UIButton *)btn
{
    switch (btn.tag) {
        case 100://获取类的成员变量
        {
            unsigned int count;
            
            //获取成员变量的数组的指针
            Ivar *ivars = class_copyIvarList([Person class], &count);
            
            for (int i = 0; i < count; i++) {
                Ivar ivar = ivars[i];
                
                //根据ivar获得其成员变量的名称
                const char *name = ivar_getName(ivar);
                //c的字符串转oc的字符串
                NSString *key = [NSString stringWithUTF8String:name];
                NSLog(@"%d == %@",i,key);
            }
            //记得释放
            free(ivars);
            //如果你的成员私有，也可以获取到 比如_education
        }
            break;
        case 101://获取类的全部属性名
        {
            unsigned int count;
            
            //获得指向该类所有属性的指针
            objc_property_t *properties = class_copyPropertyList([Person class], &count);
            
            for (int i = 0; i < count; i++) {
                //获取该类的一个属性的指针
                objc_property_t property = properties[i];
                //获取属性的名称
                const char *name = property_getName(property);
                //将c的字符串转化为OC字符串
                NSString *key = [NSString stringWithUTF8String:name];
                
                NSLog(@"%d == %@",i,key);
            }
            //记得释放
            free(properties);

        }
            break;
        case 102://获取类的全部方法
        {
            unsigned int count;
            
            //获取指向该类的所有方法的数组指针
            Method *methods = class_copyMethodList([Person class], &count);
            
            for (int i = 0; i < count; i++) {
                //获取该类的一个方法的指针
                Method method = methods[i];
                //获取方法
                SEL methodSEL = method_getName(method);
                //将方法转换成为C字符串
                const char *name = sel_getName(methodSEL);
                //将C字符串转为OC字符串
                NSString *methodName = [NSString stringWithUTF8String:name];
                
                //获取方法参数个数
                int arguments = method_getNumberOfArguments(method);
                
                NSLog(@"%d == %@ %d",i,methodName,arguments);
            }
            //记得释放
            free(methods);

        }
            break;
        case 103://获取类遵守的全部协议
        {
            unsigned int count;
            
            //获取指向该类遵循的所有协议的数组指针
            __unsafe_unretained Protocol **protocols = class_copyProtocolList([self class], &count);
            
            for (int i = 0; i < count; i++) {
                //获取该类遵循的一个协议指针
                Protocol *protocol = protocols[i];
                //获取C字符串协议名
                const char *name = protocol_getName(protocol);
                //C字符串转OC字符串
                NSString *protocolName = [NSString stringWithUTF8String:name];
                NSLog(@"%d == %@",i,protocolName);
            }
            //记得释放
            free(protocols);

        }
            break;
        case 104://动态改变成员变量
        {
            self.student.name = @"张三";
            
            unsigned int count = 0;
            //获取成员变量的数组的指针
            Ivar *ivar = class_copyIvarList([self.student class], &count);
            
            for (int i = 0; i < count; i++) {
                Ivar var = ivar[i];
                //根据ivar获得其成员变量的名称
                const char *varName  = ivar_getName(var);
                //C的字符串转OC的字符串
                NSString *name = [NSString stringWithUTF8String:varName];
                //当属性变量为name时，改变成@"李四"
                if ([name isEqualToString:@"_name"]) {
                    object_setIvar(self.student, var, @"李四");
                    break;
                }
            }
            //记得释放
            free(ivar);
            //结果变成了李四
            NSLog(@"student name %@",self.student.name);

        }
            break;
        case 105://动态交换类方法
        {
            //首先获取Person类的两个 类方法名
            Method m1 = class_getInstanceMethod([Person class], @selector(doSomeThing));
            Method m2 = class_getInstanceMethod([Person class], @selector(doSomeOtherThing));
            //交换方法
            method_exchangeImplementations(m1, m2);
            // 发现两个方交换了
            NSLog(@"student do something:%@",[self.student doSomeThing]);
            NSLog(@"student do doSomeOtherThing:%@",[self.student doSomeOtherThing]);
            
            //runtime修改的是类，不是单一对象  一次修改 在下次编译前一直有效
            
            Person *student2 = [Person new];
            NSLog(@"运行时改变后student do something:%@",[student2 doSomeThing]);
            NSLog(@"运行时改变后student do doSomeOtherThing:%@",[student2 doSomeOtherThing]);
            //也可以在类目中添加自己方法去替换  类 或者系统类的方法
            
            [self.student sleep];

        }
            break;
        case 106://动态添加方法
        {
            class_addMethod([self.student class], @selector(fromCity:), (IMP)fromCityAnswer, "v@:@");
            if ([self.student respondsToSelector:@selector(fromCity:)]) {
                [self.student performSelector:@selector(fromCity:) withObject:@"广州"];
            }else
            {
                NSLog(@"无法告诉你我从哪里来");
            }

        }
            break;
        case 107://动态为Category扩展加属性
        {
            /*
             Category提供了一种比继承（inheritance）更为简洁的方法来对class进行扩展，无需创建对象类的子类就能为现有的类添加新方法，可以为任何已经存在的class添加方法，包括哪些没有源代码的类（如某些框架类）。
             
             类别的局限性
             （1）无法向类中添加新的实例变量，类别没有位置容纳实例变量。
             （2）名称冲突，即当类别中的方法与原生类方法名称冲突时，类别具有更高的优先级。类别方法将完全取代初始方法从而无法再使用初始方法。
             
             */
            //通过runtime 可以让category添加属性
            self.student.englishName = @"Andy_Lau";
            
            NSLog(@"Student English name is %@",self.student.englishName);

        }
            break;
        case 108://更便捷的归档解档
        {
            Person *person = [[Person alloc] init];
            person.name = @"刘德华";
            person.sex = @"男";
            person.age = 53;
            person.height = 170;
            person.job = @"演员";
            person.native = @"香港";
            
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [NSString stringWithFormat:@"%@/archive2",docPath];
            [NSKeyedArchiver archiveRootObject:person toFile:path];
            
            Person *unarchiverPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
            
            NSLog(@"unarchiverPerson == %@ %@",path,unarchiverPerson);

        }
            break;
        case 109://字典转Model
        {
            [TestModel test];

        }
            break;
        default:
            break;
    }
}
void fromCityAnswer(id self,SEL _cmd,NSString *str){
    
    NSLog(@"我来自:%@",str);
}



@end
