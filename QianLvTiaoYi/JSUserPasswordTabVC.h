//
//  JSUserPasswordTabVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSUserPasswordTabVC : UITableViewController


//是否进入登录密码界面 还是 支付密码界面
@property (nonatomic,assign)BOOL isLoginPswVC;

//判断是否进入忘记密码界面
@property (nonatomic,assign)BOOL isForgetPswVC;


@end
