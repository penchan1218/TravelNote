//
//  PCAddNoteViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCAddNoteViewController.h"
#import "PCPhotosManager.h"
#import "UIView+LayoutHelper.h"
#import "UIView+BGTouchView.h"
#import "UIImage+ImagesAbout.h"

@interface PCAddNoteViewController () {
    UIImage *roundedImage;
}

@end

@implementation PCAddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加keyboard监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // text view 边框
    _textView.layer.cornerRadius= 4.0f;
    _textView.layer.borderWidth = 1.0f;
    _textView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    if (_lastUpdatedText != nil) {
        [_textView setText:_lastUpdatedText];
    }

    if (_imageView.image == nil) {
        [_imageView setImage:roundedImage];
    }
    
    __weak typeof(self) weakSelf = self;
    [_imageView touchEndedBlock:^(UIView *selfView) {
        [weakSelf exit];
    }];
    
    [_textView becomeFirstResponder];
}

- (void)keyboardWillChange:(NSNotification *)notif {
    NSLog(@"keyboard change");
    NSDictionary *userInfo = notif.userInfo;
    float keyboard_endY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
    float dist = SCREEN_HEIGHT-keyboard_endY;
    _containView.fixedBottom.constant = dist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exit {
    // 移除keyboard监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (self.completionBlock != nil) {
        BOOL modified = NO;
        // 认定为未修改只存在两种情况:
        // 1.本来就存在，而且与现在的text相同
        // 2.本来不存在，现在text依然为nil或其长度为0
        if ((_lastUpdatedText != nil && [_lastUpdatedText isEqualToString:_textView.text]) ||
            (_lastUpdatedText == nil && (_textView.text == nil || _textView.text.length == 0))) {
            modified = NO;
        } else {
            modified = YES;
        }
        self.completionBlock(_assetIndex, modified);
    }
}

- (void)setAssetIndex:(NSInteger)assetIndex {
    _assetIndex = assetIndex;
    
    __weak typeof(self) weakSelf = self;
    [[PCPhotosManager shared] takeOutAspectRatioThumbnailPhotoAtIndex:assetIndex
                                                           usingBlock:^(UIImage *image, NSInteger index) {
                                                               roundedImage = [image roundedImageWithRadius:4.0f];
                                                               weakSelf.imageView.image = roundedImage;
                                                           } failureBlock:^(NSError *error) {
                                                               [self logWarningText:@"照片取出失败。"];
                                                           }];
}

- (void)setLastUpdatedText:(NSString *)lastUpdatedText {
    _lastUpdatedText = [lastUpdatedText copy];
    _textView.text = lastUpdatedText;
}

- (void)usingBlockWhenEdittingFinished:(void (^)(NSInteger index, BOOL modified))block {
    self.completionBlock = block;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
