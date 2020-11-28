//
//  NSObject+MethodSwizzling.h
//  Swizzling
//
//  Created by mm on 2020/8/26.
//  Copyright © 2020 mm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MethodSwizzling)

+ (void)jj_methodswizzlingWithClass:(Class)class originalSEL:(SEL)originalSEL targetSEL:(SEL)targetSEL;

@end

NS_ASSUME_NONNULL_END
