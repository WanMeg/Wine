//
//  JSEvaluateView.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/19.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSEvaluateTopBar.h"
#import "CommentModel.h"

@interface JSEvaluateView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) JSEvaluateTopBar *topBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommentResultsModel *commentResults;
//@property (weak, nonatomic) EvaluateCallBackBlock evaluateCallBack;
@end
