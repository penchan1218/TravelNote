//
//  PCTravelNoteViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/13.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCTravelNoteViewController.h"
#import "UIView+LayoutHelper.h"
#import "PCNetworkManager.h"
#import "PCBaseWebViewController.h"

#import "PCCommentModel+Helper.h"

#import "UIView+BGTouchView.h"
#import "UIImage+ImagesAbout.h"
#import "PCOthersInfoViewController.h"
#import "NSDate+MilliSeconds.h"

#import "PCSelfInformationModel.h"
#import "WXApi.h"

#import "PCShareViewController.h"
#import "PCModifyView.h"

@interface PCTravelNoteViewController () <TNShareToProtocol> {
    NSMutableDictionary *__observingKeyPaths;
}

@property (strong, nonatomic) NSMutableArray    *comments;

@property (weak, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) PCModifyView *modifyView;

@property (nonatomic, assign) BOOL isSharing;
@property (nonatomic, assign) BOOL isModifying;

@end

@implementation PCTravelNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0);
    self.tableView.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0);
//    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem.enabled = [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
    
    self.hud = [self.view HUDForLoadingText:@"正在加载"];
    
    self.comments = [NSMutableArray array];
    
    [_tf_giveComments setPlaceholderInset:14.0f];
    [_tf_giveComments setPlaceholderColor:UIColorFromRGBA(189, 222, 202, 1.0f)];
    _tf_giveComments.returnKeyType = UIReturnKeySend;
    _btn_sendComments.layer.borderColor = [UIColor whiteColor].CGColor;
    [_imgview_comments setImage:[[UIImage imageNamed:@"icon_comment"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    _lbl_nickname.adjustsFontSizeToFitWidth = YES;
    _lbl_likesNum.adjustsFontSizeToFitWidth = YES;
    _lbl_commentsNum.adjustsFontSizeToFitWidth = YES;
    _lbl_notes.numberOfLines = 0;
    
    [self.tableView setTableFooterView:[UIView new]];
    [self.tableView registerClass:[PCCommentsCell class] forCellReuseIdentifier:TNCommentsCell];
    
    
    __weak typeof(self) weakSelf = self;
    [_imgview_avatar touchEndedBlock:^(UIView *selfView) {
        PCOthersInfoViewController *userInfoVC = [[PCOthersInfoViewController alloc] init];
        userInfoVC.userId = weakSelf.model_tralvelNote.userId;
        [weakSelf.navigationController pushViewController:userInfoVC animated:YES];
    }];
    [_imgview_tags touchEndedBlock:^(UIView *selfView) {
        if (!weakSelf.indicator_like.isAnimating) {
            [weakSelf.indicator_like startAnimating];
            weakSelf.imgview_likes.alpha = 0.0;
            if (weakSelf.model_tralvelNote.isLiked) {
                [weakSelf unlikeRequest];
            } else {
                [weakSelf likeRequest];
            }
        }
    }];
    
    [self addNotificationObservation];
}

// like or unlike actions

- (void)likeRequest {
    __weak typeof(self) weakSelf = self;
    NSString *articleId = self.model_tralvelNote._id;
    if (articleId != nil) {
        [PCNetworkManager likeArticle:articleId ok:^(BOOL success) {
            if (success) {
                [weakSelf hasLikedOrUnliked:YES
                         animatedFromCenter:[weakSelf.indicator_like.superview convertPoint:weakSelf.indicator_like.center toView:weakSelf.view]];
                [weakSelf changeHeartImage:YES];
                weakSelf.lbl_likesNum.text = [NSString stringWithFormat:@"%ld", (unsigned long)(++weakSelf.model_tralvelNote.liked)];
                
                [PCPostNotificationCenter postNotification_likeSomearticle_withObj:nil articleId:articleId];
            }
        }];
    } else {
        NSLog(@"Like request failed for no articleid.");
    }
}

- (void)unlikeRequest {
    __weak typeof(self) weakSelf = self;
    NSString *articleId = self.model_tralvelNote._id;
    if (articleId != nil) {
        [PCNetworkManager dislikeArticle:articleId ok:^(BOOL success) {
            if (success) {
                [weakSelf hasLikedOrUnliked:NO
                         animatedFromCenter:[weakSelf.indicator_like.superview convertPoint:weakSelf.indicator_like.center toView:weakSelf.view]];
                [weakSelf changeHeartImage:NO];
                weakSelf.lbl_likesNum.text = [NSString stringWithFormat:@"%ld", (unsigned long)(--weakSelf.model_tralvelNote.liked)];
                
                [PCPostNotificationCenter postNotification_unlikeSomearticle_withObj:nil articleId:articleId];
            }
        }];
    } else {
        NSLog(@"Dislike request failed for no articleid.");
    }
}

- (void)hasLikedOrUnliked:(BOOL)hasLiked animatedFromCenter:(CGPoint)center {
    UIImageView *imgview_mark = [[UIImageView alloc] initWithFrame:self.imgview_likes.bounds];
    imgview_mark.contentMode = UIViewContentModeScaleAspectFit;
    imgview_mark.image = [UIImage imageNamed:hasLiked? @"heart_check": @"heart_normal"];
    [imgview_mark sizeToFit];
    imgview_mark.center = center;
    [self.view addSubview:imgview_mark];
    
    [UIView animateWithDuration:0.25 animations:^{
        imgview_mark.transform = CGAffineTransformMakeScale(1.5, 1.5);
        imgview_mark.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imgview_mark removeFromSuperview];
    }];
}

- (void)changeHeartImage:(BOOL)isLiked {
    self.model_tralvelNote.isLiked = isLiked;
    
    self.imgview_likes.image = [UIImage imageNamed:_model_tralvelNote.isLiked?@"heart_check":@"heart_normal"];
    self.imgview_likes.alpha = 1.0;
    [self.indicator_like stopAnimating];
}

//

- (IBAction)showModifyView:(id)sender {
    self.isModifying = !self.isModifying;
}

- (IBAction)shouldShareTo:(id)sender {
    if (self.model_tralvelNote && self.imgview_poster.image && !self.isSharing) {
        PCShareViewController *shareVC = [[PCShareViewController alloc] init];
        shareVC.delegate = self;
        [self addChildViewController:shareVC];
        [self.view addSubview:shareVC.view];
        [shareVC didMoveToParentViewController:self];
        [shareVC showChoices];
        
        __weak typeof(self) weakSelf = self;
        shareVC.cancelBlock = ^{
            weakSelf.isSharing = NO;
        };
        
        self.isSharing = YES;
    }
}

- (void)shareToWechat:(int)scene {
    self.isSharing = YES;
    
    UIImage *coverImg = [UIImage imageWithImage:self.imgview_poster.image scaledToSize:CGSizeMake(40, 40)];
    WXMediaMessage *message = [[WXMediaMessage alloc] init];
    [message setTitle:self.model_tralvelNote.title];
    [message setThumbImage:coverImg];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"http://travel.changjiangcp.com/view/%@/%ld", self.model_tralvelNote._id, (unsigned long)self.model_tralvelNote.temp];
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
    [WXApi sendReq:req];
    
    self.isSharing = NO;
}

- (void)addNotificationObservation {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasFollowedSomeoneNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *userId = [note.userInfo objectForKey:@"userId"];
                                                      if ([self.model_tralvelNote.userId isEqualToString:userId]) {
                                                          [weakSelf follow:YES];
                                                      }
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnfollowedSomeoneNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *userId = [note.userInfo objectForKey:@"userId"];
                                                      if ([self.model_tralvelNote.userId isEqualToString:userId]) {
                                                          [weakSelf follow:NO];
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasSharedToWechatNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      if (!weakSelf.hud) {
                                                          weakSelf.hud = [weakSelf.view HUDForLoadingText:nil];
                                                      }
                                                      weakSelf.hud.mode = MBProgressHUDModeText;
                                                      weakSelf.hud.labelText = @"分享成功";
                                                      [weakSelf.hud hide:YES afterDelay:2];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasCancelledSharingToWechatNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                  }];
}

- (void)makeHeaderShadow {
    self.view_containView.layer.masksToBounds = NO;
    self.view_containView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.view_containView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.view_containView.layer.shadowOpacity = 0.5;
    self.view_containView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.view_containView.bounds, 0, 0) cornerRadius:1].CGPath;
}

- (void)updateTravelNoteInfo {
    if ([[PCSelfInformationModel sharedInstance].unionid isEqualToString:self.model_tralvelNote.userId]) {
        [self.btn_follow removeFromSuperview];
        
        self.btn_modify.alpha = 1.0;
    } else {
        self.btn_modify.alpha = 0.0;
    }
    
    _lbl_nickname.text = _model_tralvelNote.userName;
    _lbl_title.text = _model_tralvelNote.title;
    _lbl_notes.text = _model_tralvelNote._description;
    
    _lbl_likesNum.text = [NSString stringWithFormat:@"%ld", (unsigned long)_model_tralvelNote.liked];
    _imgview_likes.image = [UIImage imageNamed:_model_tralvelNote.isLiked?@"heart_check":@"heart_normal"];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self makeHeaderShadow];
    
    [self.tableView setContentInset:UIEdgeInsetsMake(self.view_header.frame.size.height, 0, 0, 0)];
//    [self resizeHeaderSize];
    
    __weak typeof(self) weakSelf = self;
    [_model_tralvelNote getImageBackThroughKey:_model_tralvelNote.userImgKey ok:^(UIImage *userImg) {
        weakSelf.imgview_avatar.image = userImg;
    } withSizeCut:CGSizeMake(40, 40)];
    
    CGFloat width_cover = SCREEN_WIDTH-10*2;
    CGSize size_cover = CGSizeMake(width_cover, (int)(width_cover/2));
    [_model_tralvelNote getImageBackThroughKey:_model_tralvelNote.coverKey ok:^(UIImage *coverImg) {
        weakSelf.imgview_poster.image = coverImg;
    } withSizeCut:size_cover];
    
    [self downloadComments];
    
    [self.view_header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerpanAction:)]];
}

- (void)headerpanAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.tableView.contentOffset.y < - self.view_header._height) {
            [self.tableView setContentOffset:CGPointMake(0, -self.view_header._height) animated:YES];
        }
        return ;
    }
    CGPoint translation = [gesture translationInView:gesture.view];
    CGFloat translation_y = translation.y;
    CGFloat offset_y = self.tableView.contentOffset.y;
    [self.tableView setContentOffset:CGPointMake(0, offset_y-translation_y) animated:NO];
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (void)resizeHeaderSize {
    // 好吧, 这么多代码, 只是为了计算header的高度      我靠( ‵o′)凸
//    CGFloat width = _view_containView.frame.size.width;
//    CGSize textFixedSize = CGSizeMake(width, CGFLOAT_MAX);
//    CGRect rect_title = [_lbl_title.text boundingRectWithSize:textFixedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _lbl_title.font} context:nil];
//    CGRect rect_notes = [_lbl_notes.text boundingRectWithSize:textFixedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: _lbl_notes.font} context:nil];
//    
//    CGFloat height = 8+_imgview_avatar.frame.size.height+10+_imgview_poster.frame.size.height+16+10+16+rect_title.size.height+rect_notes.size.height+31;
//    _view_header.frame = CGRectMake(0, 0, SCREEN_WIDTH, height+10);
    
//    CGSize size = [self.view_header sizeThatFits:CGSizeMake(self.view_header.frame.size.width, CGFLOAT_MAX)];
//    self.view_header.fixedHeigt.constant = size.height;
}

- (IBAction)play:(id)sender {
    PCBaseWebViewController *baseWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"TNBaseWebViewController"];
    baseWebView.articleId = self.model_tralvelNote._id;
    baseWebView.temp = @(self.model_tralvelNote.temp);
    baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/view/%@/%ld", self.model_tralvelNote._id, (unsigned long)self.model_tralvelNote.temp];
    baseWebView.title = self.model_tralvelNote.title;
    baseWebView.webViewType = TNWebViewTypePreviewWorks;
    baseWebView.coverImg = self.imgview_poster.image;
//    baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/webs/%@/adjust", self.model_tralvelNote._id];
    [self.navigationController pushViewController:baseWebView animated:YES];
}

- (void)keyboardWillChange:(NSNotification *)notif {
    NSDictionary *userInfo = notif.userInfo;
    UIViewAnimationOptions options = [userInfo[@"UIKeyboardAnimationCurveUserInfoKey"] integerValue];
    NSTimeInterval duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect endRect = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    float endY = endRect.origin.y;
    float translationY = SCREEN_HEIGHT-endY;
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        _view_bottom.fixedBottom.constant = translationY;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [PCPostNotificationCenter postNotification_hideTabbar_withObj:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    if (_tf_giveComments.isFirstResponder) {
        [_tf_giveComments resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)follow:(BOOL)follow {
    _btn_follow.alpha = 1.0f;
    [_indicator_follow stopAnimating];
    
    UIColor *color = follow? UIColorFromRGBA(213, 94, 96, 1.0f): THEME_COLOR;
    [_btn_follow setTitleColor:color forState:UIControlStateNormal];
    _btn_follow.layer.borderColor = color.CGColor;
    _btn_follow.tag = follow;
    [_btn_follow setTitle:follow? @"已关注": @"关注" forState:UIControlStateNormal];
}

- (void)downloadComments {
    __weak PCTravelNoteViewController *weakSelf = self;
    [PCNetworkManager getArticleComments:self.model_tralvelNote._id ok:^(NSArray *comments, NSString *articleid) {
        [weakSelf.comments removeAllObjects];
        for (NSInteger i = 0; i < comments.count; i++) {
            PCCommentModel *model = [[PCCommentModel alloc] initWithInfo:comments[i]];
            model.indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            [weakSelf.comments addObject:model];
            model.indexpath = [NSIndexPath indexPathForRow:weakSelf.comments.count-1 inSection:0];
        }
        
        [weakSelf renewCellHeightOfModels:weakSelf.comments];
        [weakSelf shouldUpdateCommentsWheterReloadData:YES];
    }];
}

- (IBAction)sendComment {
    if (self.tf_giveComments.text.length == 0) {
        return ;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *_id = self.model_tralvelNote._id;
    NSString *content = [_tf_giveComments.text copy];
    
    __weak MBProgressHUD *weakHUD = hud;
    __weak typeof(self) weakSelf = self;
    [PCNetworkManager addAComment:_id content:content ok:^(BOOL success, NSString *articleId) {
        NSLog(@"Add comment %@ status code : %d", content, success);
        if (success) {
            weakSelf.tf_giveComments.text = nil;
            [weakSelf.tf_giveComments resignFirstResponder];
            weakHUD.mode = MBProgressHUDModeText;
            weakHUD.labelText = @"评论成功";
            [weakHUD hide:YES afterDelay:1.0];
            
//            [weakSelf downloadComments];
            [weakSelf addCommentJustSent:content];
        } else {
            weakHUD.mode = MBProgressHUDModeText;
            weakHUD.labelText = @"评论失败";
            [weakHUD hide:YES afterDelay:1.0];
        }
    }];
}

- (void)addCommentJustSent:(NSString *)content {
    PCCommentModel *model = [[PCCommentModel alloc] initWithInfo:@{@"commentTime": [NSDate millisecondsFrom1970ByNow],
                                                                   @"userId": [[NSUserDefaults standardUserDefaults] objectForKey:@"user_unionid"],
                                                                   @"userImgKey": [PCSelfInformationModel sharedInstance].headImgKey,
                                                                   @"userName": [PCSelfInformationModel sharedInstance].nickname,
                                                                   @"content": content}];
    [self.comments addObject:model];
    [self renewCellHeightOfModels:@[model]];
    model.indexpath = [NSIndexPath indexPathForRow:self.comments.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[model.indexpath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self shouldUpdateCommentsWheterReloadData:NO];
}

- (IBAction)willFollow:(UIButton *)btn {
    btn.alpha = 0.0f;
    [_indicator_follow startAnimating];
    
    __weak typeof(self) weakSelf = self;
    if (btn.tag == 1) {
        // 调取消关注API
        [PCNetworkManager unfollowTheUser:self.model_tralvelNote.userId ok:^(BOOL success) {
            [weakSelf follow:!success];
            if (success) {
                [PCPostNotificationCenter postNotification_unfollowSomeone_withObj:nil userId:self.model_tralvelNote.userId];
            }
        }];
    } else if (btn.tag == 0) {
        // 调关注API
        [PCNetworkManager followTheUser:self.model_tralvelNote.userId ok:^(BOOL success) {
            [weakSelf follow:success];
            if (success) {
                [PCPostNotificationCenter postNotification_followSomeone_withObj:nil userId:self.model_tralvelNote.userId];
            }
        }];
    } else {
        [self logWarningText:@"关注tag出现问题"];
    }
}

- (void)setModel_tralvelNote:(PCTravelNoteModel *)model_tralvelNote {
    _model_tralvelNote = model_tralvelNote;
    if (self.hud) {
        [self.hud hide:YES];
        self.hud = nil;
    }
    
    [model_tralvelNote addObserver:self forKeyPath:@"isFollowed" options:NSKeyValueObservingOptionNew context:nil];
    
    [self updateTravelNoteInfo];
}

- (void)setIsModifying:(BOOL)isModifying {
    if (self.isModifying == isModifying) {
        return ;
    }
    
    if (isModifying) {
        __weak typeof(self) weakSelf = self;
        PCModifyView *modifyView = [[PCModifyView alloc] initWithEditBlock:^{
            PCBaseWebViewController *baseWebView = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"TNBaseWebViewController"];
            baseWebView.articleId = weakSelf.model_tralvelNote._id;
            baseWebView.temp = @(weakSelf.model_tralvelNote.temp);
            baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/webs/%@/adjust", baseWebView.articleId];
            baseWebView.webViewType = TNWebViewTypeAdjustAfterFinished;
            baseWebView.title = weakSelf.model_tralvelNote.title;
            [weakSelf.navigationController pushViewController:baseWebView animated:YES];
        } andDeleteBlock:^{
            __weak MBProgressHUD *hud = [self.view HUDForLoadingText:@"正在删除"];
            [PCNetworkManager deleteArticle:weakSelf.model_tralvelNote._id ok:^(BOOL success) {
                if (success) {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"删除成功";
                    [hud hide:YES afterDelay:1.0];
                    
                    [PCPostNotificationCenter postNotification_deleteOneTravelNote_withObj:nil articleId:self.model_tralvelNote._id];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"删除失败";
                    [hud hide:YES afterDelay:1.0];
                }
            }];
        }];
        [self.btn_modify.superview addSubview:modifyView];
        [modifyView showWithArrowPointing:CGPointMake(self.btn_modify.center.x, self.btn_modify._bottom)];
        self.modifyView = modifyView;
    } else {
        [self.modifyView hide];
    }
    
    _isModifying = isModifying;
}

- (void)shouldUpdateCommentsWheterReloadData:(BOOL)reloadData {
    _lbl_commentsNum.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.comments.count];
    if (reloadData) {
        [self.tableView reloadData];
    }
}

- (void)renewCellHeightOfModels:(NSArray *)updatedModels {
    PCCommentsCell *cell_comments = [self.tableView dequeueReusableCellWithIdentifier:TNCommentsCell];
    for (PCCommentModel *model in updatedModels) {
        [model reloadCell:cell_comments];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == _model_tralvelNote) {
        if ([keyPath isEqualToString:@"isFollowed"]) {
            [self follow:self.model_tralvelNote.isFollowed];
        }
    }
}

- (void)dealloc {
    [_model_tralvelNote removeObserver:self forKeyPath:@"isFollowed"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Protocol - table view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_tf_giveComments.isFirstResponder) {
        [_tf_giveComments resignFirstResponder];
    }
    
    CGFloat offset_y = scrollView.contentOffset.y;
    CGFloat height_header = self.view_header.frame.size.height;
    CGFloat height_tags = self.imgview_tags.frame.size.height;
    CGFloat total_offset = -MIN(offset_y, -height_tags)-height_header;
    self.view_header.fixedTop.constant = total_offset;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCCommentModel *model = self.comments[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:TNCommentsCell];;
    
    __weak typeof(self) weakSelf = self;
    cell.showUserInfoBlock = ^(NSString *userId) {
        if (userId) {
            PCOthersInfoViewController *userInfoVC = [[PCOthersInfoViewController alloc] init];
            userInfoVC.userId = userId;
            [weakSelf.navigationController pushViewController:userInfoVC animated:YES];
        }
    };
    
    PCCommentModel *model = _comments[indexPath.row];
    [model reloadCell:cell];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Protocol - textfield

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSMutableString *newString = [NSMutableString stringWithString:textField.text];
//    [newString replaceCharactersInRange:range withString:string];
//    _btn_sendComments.enabled = newString.length > 0;
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendComment];
    return YES;
}

#pragma mark - Protocol - TNShareToProtocol

- (void)willShareToWechatScene:(NSInteger)scene {
    switch (scene) {
        case 0:
            [self shareToWechat:WXSceneSession];
            break;
        case 1:
            [self shareToWechat:WXSceneTimeline];
            break;
        case 2:
            [self shareToWechat:WXSceneFavorite];
        default:
            break;
    }
}

@end
