//
//  JSShoppingCartVC.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PickedState) {
    PickedStateALL = 0,                  /**<全选*/
    PickedStateCancel,                   /**<取消全选*/
    PickedStateNone                     /**<没有选择*/
};

@interface JSShoppingCartVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) BOOL isHaveBarItem;



@end
