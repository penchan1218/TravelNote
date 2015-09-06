//
//  UIView+FrameAbout.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/30.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "UIView+FrameAbout.h"

@implementation UIView (FrameAbout)

- (CGFloat)_left {
    return self.frame.origin.x;
}

- (void)set_left:(CGFloat)_left {
    [self setFrame:CGRectOffset(self.frame, _left-self._left, 0)];
}

- (CGFloat)_right {
    return self.frame.origin.x+self._width;
}

- (void)set_right:(CGFloat)_right {
    [self setFrame:CGRectOffset(self.frame, _right-self._right, 0)];
}

- (CGFloat)_top {
    return self.frame.origin.y;
}

- (void)set_top:(CGFloat)_top {
    [self setFrame:CGRectOffset(self.frame, 0, _top-self._top)];
}

- (CGFloat)_bottom {
    return self.frame.origin.y+self._height;
}

- (void)set_bottom:(CGFloat)_bottom {
    [self setFrame:CGRectOffset(self.frame, 0, _bottom-self._bottom)];
}


- (CGPoint)_leftTop {
    return self.frame.origin;
}

- (void)set_leftTop:(CGPoint)_leftTop {
    self._left = _leftTop.x;
    self._top = _leftTop.y;
}

- (CGPoint)_leftBottom {
    return CGPointMake(self._left, self._bottom);
}

- (void)set_leftBottom:(CGPoint)_leftBottom {
    self._left = _leftBottom.x;
    self._bottom = _leftBottom.y;
}

- (CGPoint)_rightTop {
    return CGPointMake(self._right, self._top);
}

- (void)set_rightTop:(CGPoint)_rightTop {
    self._right = _rightTop.x;
    self._top = _rightTop.y;
}

- (CGPoint)_rightBottom {
    return CGPointMake(self._right, self._bottom);
}

- (void)set_rightBottom:(CGPoint)_rightBottom {
    self._right = _rightBottom.x;
    self._bottom = _rightBottom.y;
}

- (CGFloat)_width {
    return self.frame.size.width;
}

- (CGFloat)_height {
    return self.frame.size.height;
}

@end
