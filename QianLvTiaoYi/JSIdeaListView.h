//
//  JSIdeaListView.h
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/7/11.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSIdeaListView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *ideaListTabView;
@property(nonatomic, strong) NSMutableArray *ideaListArray;
@property (nonatomic, copy) NSString *pageNumber;
@property(nonatomic, assign) NSInteger currentPage;
@end
