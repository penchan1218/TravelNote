//
//  UIConstants.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#ifndef TravelNote_UIConstants_h
#define TravelNote_UIConstants_h

#define     SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define     SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

#define     UIColorFromRGBA(r, g, b, a)     [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define HexColor(rgbValue, al) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:al > 1? 1.0: al]

#endif
