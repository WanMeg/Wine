//
//  JSAddressEditVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/21.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSAdressListTVC.h"
#import "Address.h"

@interface JSAddressEditVC : UIViewController

@property (nonatomic, strong) Address *address;
@property (nonatomic, assign) BOOL isEditAddress;
@property (nonatomic) BOOL isCreatOrder;    /**<是否是从下单页面 跳转过来的*/

/*设置为默认地址*/
@property (nonatomic, assign) int switchIsOn;

@property (nonatomic, copy) AdressListTVCCallBack callBack;

@end
