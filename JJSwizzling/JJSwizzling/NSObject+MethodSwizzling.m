//
//  NSObject+MethodSwizzling.m
//  Swizzling
//
//  Created by mm on 2020/8/26.
//  Copyright © 2020 mm. All rights reserved.
//

#import "NSObject+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation NSObject (MethodSwizzling)

/**
 方法交换
 核心：通过操作把原来 originalSEL -- originalMethod.IMP   targetSEL -- targetMethod.IMP 对应关系
      改为 originalSEL -- targetMethod.IMP   targetSEL -- originalMethod.IMP
 其中：originalSEL、originalMethod 一般为原生方法。targetMethod 为替换方法，可以在除原实现外，实现一些自定义处理
      因此
 */
+ (void)jj_methodswizzlingWithClass:(Class)class originalSEL:(SEL)originalSEL targetSEL:(SEL)targetSEL {
    if (class == nil) {
        return;
    }
      
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method targetMethod = class_getInstanceMethod(class, targetSEL);
    
    // 避免从父类继承的方法中，父类没有该方法的实现，导致 crash
    if (originalMethod == nil) {
        // 1 对 originalSEL 设置一个实现
        class_addMethod(class, originalSEL, method_getImplementation(targetMethod), method_getTypeEncoding(targetMethod));
        // 2. 修改实现，实现自定义操作(这里做打印提示)。
        //    不修改也可以，会把 targetMethod.IMP 作为 originalSEL 的实现
//        method_setImplementation(targetMethod, imp_implementationWithBlock(^(id self, SEL _cmd){
//            NSLog(@" MethodSwizzling [%@ class] have no originalMethod", class);
//        }));
        return;
    }
    
    // 在当前类添加方法，判断当前类是否实现了原方法（避免对继承的方法交换，修改了父类的方法实现）
    BOOL addMethod = class_addMethod(class, originalSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    if (addMethod) {
//        class_replaceMethod(class, targetSEL, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        class_replaceMethod(class, originalSEL, method_getImplementation(targetMethod), method_getTypeEncoding(targetMethod));
    } else {
        // 直接交换 IMP
        method_exchangeImplementations(originalMethod, targetMethod);
    }
    
}

@end
