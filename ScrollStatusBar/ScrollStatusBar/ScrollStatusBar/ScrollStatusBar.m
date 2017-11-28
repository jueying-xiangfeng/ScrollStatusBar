//
//  ScrollStatusBar.m
//  ScrollStatusBar
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 Key. All rights reserved.
//

#import "ScrollStatusBar.h"

@interface ScrollStatusBar () {
    NSTimeInterval _showTime;      // 下滑时间
    NSTimeInterval _stayTime;      // 展示停留时间
    NSTimeInterval _dismissTime;   // 上滑消失时间
    
    UIColor * _backgroundColor; // 背景色
    CGFloat _backgroundAlpha;   // 背景的透明度
    
    UIColor * _textColor;   // 文字颜色
    CGFloat _textFontSize;  // 文字大小
    
    NSString * _title;  // 标题
}

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIView * animationView;

@end

@implementation ScrollStatusBar

+ (__kindof ScrollStatusBar *)scrollStatusBarWithTitle:(NSString *)title coordinate_y:(CGFloat)point_y {
    ScrollStatusBar * scrollStatusBar = [[ScrollStatusBar alloc] initWithFrame:CGRectMake(0, point_y, [UIScreen mainScreen].bounds.size.width, 0)
                                                                      showTime:0.8
                                                                      stayTime:1
                                                                   dismissTime:0.8
                                                               backgroundColor:[UIColor greenColor]
                                                               backgroundAlpha:0.8
                                                                     textColor:[UIColor whiteColor]
                                                                  textFontSize:15
                                                                         title:title];
    return scrollStatusBar;
}

- (instancetype)initWithFrame:(CGRect)frame
                     showTime:(NSTimeInterval)showTime
                     stayTime:(NSTimeInterval)stayTime
                  dismissTime:(NSTimeInterval)dismissTime
              backgroundColor:(UIColor *)backgroundColor
              backgroundAlpha:(CGFloat)backgroundAlpha
                    textColor:(UIColor *)textColor
                 textFontSize:(CGFloat)textFontSize
                        title:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        _showTime = showTime;
        _stayTime = stayTime;
        _dismissTime = dismissTime;
        _backgroundColor = backgroundColor;
        _backgroundAlpha = backgroundAlpha;
        _textColor = textColor;
        _textFontSize = textFontSize;
        _title = title;
        
        self.alpha = 0;
        
        [self configUI];
        [self layoutUI];
    }
    return self;
}

- (void)configUI {
    self.animationView = [[UIView alloc] init];
    self.animationView.backgroundColor = _backgroundColor;
    self.animationView.layer.opacity = _backgroundAlpha;
    [self addSubview:self.animationView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = _textColor;
    self.titleLabel.font = [UIFont systemFontOfSize:_textFontSize];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = _title;
    [self.animationView addSubview:self.titleLabel];
}

- (void)layoutUI {
    CGFloat h_Margin = 5;
    CGFloat v_Margin = 10;
    CGFloat titleHeight = 0;
    CGFloat titleWidth = [UIScreen mainScreen].bounds.size.width - h_Margin*2;
    if (_title) {
        NSDictionary * dict = @{NSFontAttributeName : [UIFont systemFontOfSize:_textFontSize]};
        CGSize size = CGSizeMake(titleWidth, CGFLOAT_MAX);
        size = [_title boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
        titleHeight = size.height + 2;
    }
    CGFloat height = v_Margin*2 + titleHeight;
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            height);
    self.animationView.frame = self.bounds;
    self.titleLabel.frame = CGRectMake(h_Margin,
                                       (height - titleHeight)/2.0,
                                       titleWidth,
                                       titleHeight);
}

#pragma mark- Public
- (void)showScrollStatusBar {
    // 移出现有的动画
    [self.animationView.layer removeAllAnimations];
    [self.layer removeAllAnimations];
    
    CGRect frame = self.animationView.frame;
    frame.origin.y = -frame.size.height;
    self.animationView.frame = frame;
    
    /************* 将当前view 已到superView最顶部显示 *************/
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:_showTime animations:^{
        self.alpha = 1;
        self.animationView.frame = self.bounds;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:_stayTime animations:^{
                self.alpha = 0.99;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self dismissScrollStatusBar];
                }
            }];
        }
    }];
}

- (void)dismissScrollStatusBar {
    [UIView animateWithDuration:_dismissTime animations:^{
        self.alpha = 0;
        CGRect frame = self.animationView.frame;
        frame.origin.y = -frame.size.height;
        self.animationView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}


@end
