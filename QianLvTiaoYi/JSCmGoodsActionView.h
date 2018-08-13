//
//  JSCmGoodsActionView.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/2.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCmGoodsActionView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *goodsActionTabView;
@property (nonatomic, strong) NSArray *actionArray;
@property (nonatomic, assign) NSInteger index;


@end
