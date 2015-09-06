//
//  PCTravelNoteViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/13.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPlaceHolderTextField.h"
#import "PCTravelNoteModel.h"

@interface PCTravelNoteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgview_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_poster;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_tags;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_likes;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_comments;

@property (weak, nonatomic) IBOutlet UILabel *lbl_nickname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_notes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_commentsNum;
@property (weak, nonatomic) IBOutlet UILabel *lbl_likesNum;

@property (weak, nonatomic) IBOutlet UIButton *btn_follow;
@property (weak, nonatomic) IBOutlet UIButton *btn_modify;
@property (weak, nonatomic) IBOutlet UIButton *btn_sendComments;

@property (weak, nonatomic) IBOutlet UIView *view_containView;
@property (weak, nonatomic) IBOutlet UIView *view_bottom;
@property (weak, nonatomic) IBOutlet UIView *view_header;

@property (weak, nonatomic) IBOutlet PCPlaceHolderTextField *tf_giveComments;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_follow;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_like;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) PCTravelNoteModel *model_tralvelNote;


- (void)follow:(BOOL)follow;

@end
