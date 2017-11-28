//
//  UIScrollView+ScrollStatusBar.m
//  ScrollStatusBar
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 Key. All rights reserved.
//

#import "UIScrollView+ScrollStatusBar.h"
#import <objc/runtime.h>

static void * kScrollStatusBar = &kScrollStatusBar;

@implementation UIScrollView (ScrollStatusBar)

/*
 enum {
    OBJC_ASSOCIATION_ASSIGN = 0,            // 关联对象的属性是弱引用
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,  // 关联对象的属性是强引用并且关联对象不使用原子性
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,    // 关联对象的属性是copy并且关联对象不使用原子性
    OBJC_ASSOCIATION_RETAIN = 01401,        // 关联对象的属性是copy并且关联对象使用原子性
    OBJC_ASSOCIATION_COPY = 01403           // 关联对象的属性是copy并且关联对象使用原子性
 };
 */

- (void)setScrollStatusBar:(ScrollStatusBar *)scrollStatusBar {
    if (scrollStatusBar != self.scrollStatusBar) {
        [self.scrollStatusBar removeFromSuperview];
        [self.superview insertSubview:scrollStatusBar atIndex:0];
        [self.superview setNeedsLayout];
        
        [self willChangeValueForKey:@"scrollStatusBar"];
        objc_setAssociatedObject(self, &kScrollStatusBar, scrollStatusBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"scrollStatusBar"];
    }
}

- (ScrollStatusBar *)scrollStatusBar {
    return objc_getAssociatedObject(self, &kScrollStatusBar);
}

@end
