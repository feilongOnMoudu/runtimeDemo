//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 宋飞龙 on 17/2/21.
//  Copyright © 2017年 宋飞龙. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

void runAddMethod(id self,SEL _cmd, NSString * string) {
    NSLog(@"add C IMP %@",string);
}


@interface ViewController () {
    //成员变量
    NSInteger  type3;
}


@property (nonatomic,copy) NSString * type1;
@property (nonatomic,copy) NSString * type2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    unsigned int count;
    //获取属性列表
    objc_property_t * propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        
        const char * propertyName = property_getName(propertyList[i]);
        NSLog(@"property:%@",[NSString stringWithUTF8String:propertyName]);
    }
    //获取成员变量列表
    Ivar * ivarList = class_copyIvarList([self class], &count);
    for (const Ivar * i = ivarList; i < count+ivarList; i++) {
        Ivar myIvar = *i;
        const char * ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar:%@",[NSString stringWithUTF8String:ivarName]);
    }
    //获取方法列表
    Method * methList = class_copyMethodList([self class], &count);
    for (unsigned int i; i < count; i++) {
        Method myMeth = methList[i];
        SEL methName = method_getName(myMeth);
        NSLog(@"MethName:%@",NSStringFromSelector(methName));
    }
    [self performSelector:@selector(resolveAdd:) withObject:@"大龙哥"];
    
    //关联对象
//    static char associatedObjectKey;
//    objc_setAssociatedObject(self, &associatedObjectKey, @"添加的", OBJC_ASSOCIATION_COPY_NONATOMIC);
//    NSString * string = objc_getAssociatedObject(self, &associatedObjectKey);
//    NSLog(@"associatedObject = %@",string);
    NSArray * arr = @[@"1",@"2"];
    [self addAssociatedObject:@"再次添加的"];
     [self addAssociatedObject:arr];
    NSLog(@"associatedObject = %@",[self getAssociatedObject]);
}

//添加关联对象
- (void)addAssociatedObject:(id)object{
    objc_setAssociatedObject(self, @selector(getAssociatedObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//获取关联对象
- (id)getAssociatedObject{
    return objc_getAssociatedObject(self, _cmd);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    //动态添加方法
    if ([NSStringFromSelector(sel) isEqualToString:@"resolveAdd:"]) {
        class_addMethod(self, sel, (IMP)runAddMethod, "v@:*");
    }
    return YES;
}

- (void) test {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
