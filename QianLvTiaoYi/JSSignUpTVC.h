//
//  JSSignUpTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/10/30.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+Verify.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface JSSignUpTVC : UITableViewController

@property (nonatomic, copy) NSString *loginMode;
@property (nonatomic, copy) NSString *openID;

@property (weak, nonatomic) IBOutlet UIView *upView;

@end
