//
//  ScrollStatusBar.h
//  ScrollStatusBar
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 Key. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollStatusBar : UIView

/**
 *  title: 展示的标题
 *  point_y: statusBar初始y坐标
 */
+ (__kindof ScrollStatusBar *)scrollStatusBarWithTitle:(NSString *)title coordinate_y:(CGFloat)point_y;

// 展示隐藏
- (void)showScrollStatusBar;
- (void)dismissScrollStatusBar;

@end
