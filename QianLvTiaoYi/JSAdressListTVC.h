//
//  JSAdressListTVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/6.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetAddressListData.h"

typedef void(^AdressListTVCCallBack)(Address *address);

@interface JSAdressListTVC : UITableViewController
@property (nonatomic) BOOL isCreatOrder;    /**<是否是从下单页面 跳转过来的*/
@property (nonatomic, copy) AdressListTVCCallBack callBack;
@end
