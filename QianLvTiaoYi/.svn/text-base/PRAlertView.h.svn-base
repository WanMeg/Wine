//
//  PRAlertView.h
//  QianLvTiaoYi
//
//  Created by JSHENG on 15/12/23.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PRAlertViewCallBack)(NSInteger buttonIndex);
@interface PRAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic, copy)PRAlertViewCallBack callBack;

- (void)showNoLoginAlertViewWithCallBack:(PRAlertViewCallBack)callBack;

@end
