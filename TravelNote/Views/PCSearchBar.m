//
//  PCSearchBar.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCSearchBar.h"

@interface PCSearchBar () {
    UITextField *__searchField;
    UILabel *__placeHolderField;
    UIImageView *__searchIconField;
    
    float width;
    float height;
    
    float inset_y;
    float iconWidth;
}

@property (nonatomic, copy) SearchBlock searchBlock;

@end

@implementation PCSearchBar

+ (PCSearchBar *)searchBarInstanceWithSearchBlock:(SearchBlock)block {
    float inset_x = 40.0f;
    float inset_y = 8.0f;
    PCSearchBar *newInstance = [[PCSearchBar alloc] initWithFrame:CGRectMake(inset_x, inset_y, SCREEN_WIDTH-2*inset_x, 44-2*inset_y) withSearchBlock:block];
    return newInstance;
}

- (id)initWithFrame:(CGRect)frame withSearchBlock:(SearchBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        width = frame.size.width;
        height = frame.size.height;
        
        inset_y = frame.origin.y;
        iconWidth = height-inset_y*2;
        
        self.userInteractionEnabled = YES;
        self.layer.cornerRadius = height/2;
        self.backgroundColor = HexColor(0x1EA461, 1.0f);
        [self setupSubviews];
        
        self.searchBlock = block;
    }
    return self;
}

- (void)setupSubviews {
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(iconWidth*2+10, inset_y/2, width-iconWidth*3-20, iconWidth+inset_y)];
    searchField.font = [UIFont systemFontOfSize:16.0f];
    searchField.textColor = [UIColor whiteColor];
    searchField.delegate = self;
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    [self addSubview:searchField];
    __searchField = searchField;
    
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, iconWidth, iconWidth)];
    searchIcon.center = CGPointMake(width/2, height/2);
    searchIcon.clipsToBounds = YES;
    searchIcon.userInteractionEnabled = NO;
    searchIcon.contentMode = UIViewContentModeScaleAspectFit;
    searchIcon.image = [UIImage imageNamed:@"icon_search"];
    searchIcon.alpha = 0.6f;
    [self addSubview:searchIcon];
    __searchIconField = searchIcon;
    
    UILabel *placeHolderField = [[UILabel alloc] initWithFrame:CGRectZero];
    placeHolderField.center = CGPointMake(width/2, height/2);
    placeHolderField.userInteractionEnabled = NO;
    placeHolderField.font = [UIFont systemFontOfSize:14.0f];
    placeHolderField.textAlignment = NSTextAlignmentCenter;
    placeHolderField.textColor = [UIColor whiteColor];
    placeHolderField.alpha = 0.6f;
    [self addSubview:placeHolderField];
    __placeHolderField = placeHolderField;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    if ([placeHolder isEqualToString:_placeHolder] || self.placeHolder != nil) {
        return ;
    }
    
    _placeHolder = [placeHolder copy];
    __placeHolderField.text = _placeHolder;
    [__placeHolderField sizeToFit];
    
    float placeHolderWidth = __placeHolderField.frame.size.width;
    float placeHolderHeight = __placeHolderField.frame.size.height;
    float totalWidth = placeHolderWidth+iconWidth;

    __searchIconField.frame = CGRectMake((width-totalWidth)/2, inset_y, iconWidth, iconWidth);
    __placeHolderField.frame = CGRectMake(__searchIconField.frame.origin.x+iconWidth, (height-placeHolderHeight)/2, placeHolderWidth, placeHolderHeight);
}

- (NSString *)text {
    return __searchField.text;
}

- (void)triggleBlock {
    if (self.searchBlock != nil) {
        self.searchBlock(self.text);
    }
}

#pragma mark - Protocol - text filed

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        __searchIconField.frame = CGRectMake(iconWidth, __searchIconField.frame.origin.y, iconWidth, iconWidth);
        __placeHolderField.alpha = 0.0f;
    }];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self triggleBlock];
    
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField.text == nil || textField.text.length == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            __searchIconField.frame = CGRectMake(__placeHolderField.frame.origin.x-iconWidth, __searchIconField.frame.origin.y, iconWidth, iconWidth);
            __placeHolderField.alpha = 0.6f;
        }];
    }
    
    return YES;
}

- (BOOL)isFirstResponder {
    return __searchField.isFirstResponder;
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return __searchField.resignFirstResponder;
}

@end
