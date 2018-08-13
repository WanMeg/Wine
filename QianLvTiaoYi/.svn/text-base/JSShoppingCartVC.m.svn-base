//
//  JSShoppingCartVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "JSShoppingCartVC.h"
#import "JSGoodsDetailVC.h"
#import "PRSegmentControl.h"
#import "JSShoppingCartCell.h"

#import "GetShoppingCartData.h"
#import "JSCommitOrderVC.h"
#import "JSSCShopCell.h"
#import "JSSCEditCell.h"

#import "WMGuessLike.h"
#import "JSSCRecommentCell.h"
#import "JSSCRecommentLabCell.h"
#import "JSSCRecommentCVCell.h"
#import "GetGuessLikeData.h"

#import "JSGoodsCVCell.h"
#import "GetUserData.h"
#import "JSSCEmptyView.h"

@interface JSShoppingCartVC ()<PRSegmentControlDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *shoppingCartList; /**<购物车数据源*/
@property (nonatomic) BOOL isEditing;/**<编辑数量控件是否进入编辑状态*/
//底部工具条
@property (weak, nonatomic) IBOutlet UIButton *pickAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cartCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (copy, nonatomic) NSString *pageNumber;
@property (assign, nonatomic) NSInteger currentPage;
@property (nonatomic) int pickedCount;
@property (nonatomic, copy) NSString *pickedCartIDs;
@property (nonatomic, strong) WMGuessLike *guessLike;
@property (nonatomic, strong) JSSCRecommentCell *recommentCell;
@property (nonatomic, strong) JSSCEmptyView *emptyView;



@end

@implementation JSShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _emptyView = [[NSBundle mainBundle] loadNibNamed:@"JSSCEmptyView" owner:self options:nil].firstObject;
    
    //下拉和上拉刷新
    __weak typeof(self) weakSelf = self;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_tableView.mj_footer.isRefreshing) {
            [_tableView.mj_footer endRefreshing];
        }
        [weakSelf initModelsAndPager];
        [weakSelf requestShoppingCartList];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.guessLike = nil;
    [self getGuessLikeRequestData];

    if (M_MEMBER_LOGIN) {
        [self initModelsAndPager];
        [self requestShoppingCartList];
    } else {
        //退出登录后 清空购物车数据 显示图片
        [_shoppingCartList removeAllObjects];
    }
    
    if (!_isHaveBarItem) {
        return;
    } else {
        [self addNavigationLeftBarItem];
    }
}

#pragma mark - Http Request

/**
 *  设置基本参数
 */
- (void)initModelsAndPager
{
    self.currentPage = 1;
    self.pageNumber = @"10";
    self.shoppingCartList = [NSMutableArray array];
    [self.tableView reloadData];
}

/**
 *  请求购物车商品列表
 */
- (void)requestShoppingCartList
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"pageNumber": _pageNumber,
                            @"currentPage": [NSString stringWithFormat:@"%ld", (long)_currentPage]};
    [GetShoppingCartData postWithUrl:RMRequestStatusCartList param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (dataObj) {
            weakSelf.currentPage++;
            [weakSelf.shoppingCartList addObjectsFromArray:dataObj];
            NSLog(@"%lu",(unsigned long)_shoppingCartList.count);
        }
        [weakSelf.tableView reloadData];
        if (error.code == 200 || error.code == 200) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (error.code == 0) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  请求删除购物车商品
 */
- (void)requestDelShoppingCartWithCartID:(NSString *)cartID{
    NSDictionary *parma = @{@"operationType": @"1",@"mallShoppingcartId": cartID};
    [XLDataService postWithUrl:RMRequestStatusDelCart param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (error.code != 100) {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

/**
 *  请求编辑购物车商品数量
 */
- (void)requestEditShoppingCartNumberWithCartID:(NSString *)cartID number:(NSString *)number finish:(void(^)(BOOL success))finishBlock {
    NSDictionary *parma = @{@"mallShoppingcartId": cartID,
                            @"number": number};
    [XLDataService postWithUrl:RMRequestStatusEditCartNumber param:parma modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             finishBlock(YES);
         } else {
             finishBlock(NO);
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

/**
 *  获取猜你喜欢数据
 */
- (void)getGuessLikeRequestData
{
    __weak typeof(self) weakSelf = self;
    
    [GetGuessLikeData postWithUrl:RMRequestStatusRecommentGoods param:nil modelClass:[WMGuessLike class] responseBlock:^(id dataObj, NSError *error)
     {
         if (dataObj) {
             weakSelf.guessLike = dataObj;
             [weakSelf.recommentCell.scRecommentCollView reloadData];
             [weakSelf.tableView reloadData];
         }
     }];
}

#pragma mark - Private functions

/**
 *  添加导航栏左侧按钮
 */
- (void)addNavigationLeftBarItem
{
    UIButton *leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(0,0,18,18);
    [leftItem setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [leftItem addTarget:self action:@selector(backUpVCClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    self.navigationItem.leftBarButtonItem = item;
}

/**
 *  计算选中购物车价格
 *
 *  @param productsList   购物车列表
 *  @param state           全选状态 PickedStateAll: 全选，PickedStateCancel:取消全选，PickedStateNone:没有进行全选操作
 *
 *  @return 计算总价结果
 */
- (float)caculateTotalPriceWithPickState:(PickedState)state
{
    float totalPrice = 0;
    int selectCount = 0;
    int productCount = 0;
    int productAmount = 0;
    NSMutableString *mStr = [NSMutableString string];
    
    for (int i = 0; i < _shoppingCartList.count; i++) {
        CartShopModel *csModel = _shoppingCartList[i];
        NSDictionary *dic = [self updateGoodsPickedButtonWithCartShop:csModel pickState:state];
        float price = ((NSNumber *)dic[@"totalPrice"]).floatValue;
        totalPrice += price;
        
        BOOL shopSelect = ((NSNumber *)dic[@"shopSelect"]).boolValue;
        if (shopSelect) selectCount++;
        
        int count = ((NSNumber *)dic[@"productCount"]).intValue;
        productCount += count;
        
        int pCount = ((NSNumber *)dic[@"productAmount"]).intValue;
        productAmount += pCount;
        
        NSString *cartIds = dic[@"selectedCartIds"];
        [mStr appendString:cartIds];
        
        //当店铺下面商品被完全删除，在模型里面移除商品的模型
        if (pCount == 0) {
            [_shoppingCartList removeObjectAtIndex:i];
        }
    }
    
    // 4s运行 点击购物车会崩溃 加上了版本判断
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        //去除拼接的最后一个逗号
        if ([mStr containsString:@","]) {
            self.pickedCartIDs = [mStr substringToIndex:mStr.length-1];
        } else {
            self.pickedCartIDs = @"";
        }
    }
    
    //当全部pick按钮都为选中时，更新全选按钮为选中状态，否则为取消全选
    if (selectCount == _shoppingCartList.count) {
        _pickAllButton.selected = YES;
    } else {
        _pickAllButton.selected = NO;
    }
    
    _cartCountLabel.text = [NSString stringWithFormat:@"购物车共%d件商品", productAmount];
    [_commitButton setTitle:[NSString stringWithFormat:@"结算(%d)件", productCount] forState:UIControlStateNormal];
    
    if (productCount <= 0) {
        [_commitButton setBackgroundColor:[UIColor grayColor]];
        [_commitButton setUserInteractionEnabled:NO];
    } else {
        [_commitButton setBackgroundColor:QLTY_MAIN_COLOR];
        [_commitButton setUserInteractionEnabled:YES];
    }
    return totalPrice;
}


/**
 *  判断是否登录
 *
 *  @return
 */
- (BOOL)isLogin
{
    if (M_MEMBER_LOGIN) {
        return YES;
    } else {
        PRAlertView *alertView = [[PRAlertView alloc] init];
        __weak typeof(self) weakSelf = self;
        [alertView showNoLoginAlertViewWithCallBack:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MemberCenter" bundle:[NSBundle mainBundle]];
                UIViewController * NC = [sb instantiateViewControllerWithIdentifier:@"LoginNC"];
                [weakSelf presentViewController:NC animated:YES completion:nil];
            }
        }];
        return NO;
    }
}


#pragma mark - Actions

- (void)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  商品cell圆圈选择按钮点击事件
 */
- (IBAction)pickButtonAction:(UIButton *)sender {
    
    CartShopModel *csModel = _shoppingCartList[sender.tag / 10000];
    ShoppingCart *info = csModel.goods[sender.tag %10000];
    info.isPicked = !info.isPicked;
    
    //选择更新总价
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateNone]];
    [_tableView reloadData];
}


/**
 *  店铺名称cell左侧圆圈选择按钮点击事件
 */
- (IBAction)shopPickButtonAction:(UIButton *)sender {
    CartShopModel *csModel = _shoppingCartList[sender.tag];
    csModel.selected = !csModel.isSelected;
    [self updateGoodsPickedButtonWithCartShop:csModel pickState:csModel.isSelected?PickedStateALL:PickedStateCancel];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  编辑按钮点击事件
 */
- (IBAction)editButtonAction:(UIButton *)sender {
    CartShopModel *csModel = _shoppingCartList[sender.tag];
    csModel.edit = !csModel.edit;
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}


- (NSDictionary *)updateGoodsPickedButtonWithCartShop:(CartShopModel *)cartShop pickState:(PickedState)state {
    //选中数量
    int count = 0;
    float totalPrice = 0;
    int productCount = 0;
    int productAmount = 0;
    NSMutableString *mStr = [NSMutableString string];
    
    for (int i = 0; i < cartShop.goods.count; i++) {
        ShoppingCart *goods = cartShop.goods[i];
        switch (state) {
            case PickedStateALL:
                goods.isPicked = YES;
                break;
            case PickedStateCancel:
                goods.isPicked = NO;
            default:
                break;
        }
        
        if (goods.isPicked) {
            float price = goods.price * goods.number;
            totalPrice += price;
            count++;
            productCount += goods.number;
            [mStr appendString:[NSString stringWithFormat:@"%@,",goods.mallShoppingcartId]];
        }
        productAmount += goods.number;
    }
    
    if (count == cartShop.goods.count) {
        cartShop.selected = YES;
    } else {
        cartShop.selected = NO;
    }
    NSString *cartIds = [NSString stringWithString:mStr];
    NSDictionary *dic = @{@"totalPrice": @(totalPrice),
                          @"productCount": @(productCount),
                          @"productAmount": @(productAmount),
                          @"shopSelect": @(cartShop.isSelected),
                          @"selectedCartIds": cartIds};
    return dic;
}

/**
 *  全选按钮点击事件，更新价格
 *
 *  @param sender 全选按钮
 */
- (IBAction)pickAllButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateALL]];
    } else {
        _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateCancel]];
    }
    [_tableView reloadData];
}

/**
 *  结算提交按钮点击事件
 */
- (IBAction)commitButtonAction:(id)sender
{
    JSCommitOrderVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommitOrderVC"];
    vc.cartIDs = _pickedCartIDs;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 *  自定义删除按钮点击事件
 */
- (IBAction)delCartButtonAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag%10000 inSection:sender.tag / 10000];
    [self tableView:_tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:indexPath];
}

/**
 *  加入购物车图标按钮点击方法
 */
- (void)shopCarAddShopCarBtnClick:(UIButton *)sender
{
    if ([self isLogin]) {
        WMGuess *guess = _guessLike.remaiGoods[sender.tag];
        //获取产品id
        [XLDataService getWithUrl:RMRequestStatusGetGoodsProduct param:@{@"goodsId": guess.goodsId} modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
             if (dataObj) {
                 NSArray *proArray = dataObj[@"product"];
                 NSString *productID = proArray[0];
                 
                 //加入购物车
                 [PRUitls delay:0.5 finished:^{
                     [XLDataService postWithUrl:RMRequestStatusAddCart param:@{@"productId": productID,@"number":@"1"} modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                          if (error.code == 100) {
                              [SVProgressHUD showSuccessWithStatus:error.domain];
                              [self initModelsAndPager];
                              [self requestShoppingCartList];
                          } else {
                              [SVProgressHUD showErrorWithStatus:error.domain];
                          }
                      }];
                 }];
             }
         }];
    }
}

#pragma mark - PRSegmentControlDelegate

- (void)didBeginEditingWithSegmentControl:(PRSegmentControl *)segmentControl {
    //当增加减少控件进入编辑状态，用此方法来控制收键盘
    _isEditing = YES;
}

- (void)segmentControl:(PRSegmentControl *)segmentControl changedValue:(NSUInteger)value {
    ShoppingCart *info = _shoppingCartList[segmentControl.tag];
    [self requestEditShoppingCartNumberWithCartID:info.mallShoppingcartId number:[NSString stringWithFormat:@"%ld", (unsigned long)value] finish:^(BOOL success) {
        if (success) {
            info.number = value;
            _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateNone]];
        } else {
            [segmentControl setCurrentValue:info.number];
        }
    }];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //如果是编辑状态则 关闭键盘
    if (_isEditing) {
        [tableView endEditing:YES];
        _isEditing = NO;
    }
    
    
    if (indexPath.section == _shoppingCartList.count + 1) {
        return;
    } else {
        if (indexPath.row == 0) return;
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
        JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
        CartShopModel *csModel = _shoppingCartList[indexPath.section];
        Product *product = csModel.goods[indexPath.row-1];
        vc.goodsID = product.goodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - Table view datasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shoppingCartList.count  == 0 || indexPath.section == _shoppingCartList.count)
    {
        if (indexPath.row == 0) {
            return 44;
        } else {
            NSInteger count = _guessLike.remaiGoods.count;
            NSInteger row = count % 2;
            
            //宽度（设备宽度 - 间距） / Item数量
            CGFloat width = WIDTH / 2;
            // 高度（宽度 * 宽高比例） + 文字高度
            CGFloat width2 = width*1.146f+52.0f;
            
            if (row == 1) {
                int hight = (count / 2 + 1) * width2;
                return hight;
            } else {
                int hight = (count / 2) * width2;
                return hight;
            }
        }
    } else {
        return indexPath.row == 0 ? 44 : 110;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //当购物车为空，隐藏底部工具条
    if (_shoppingCartList.count > 0) {
        _bottomBar.hidden = NO;
    } else {
        _bottomBar.hidden = YES;
    }
    _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateNone]];
    
    return _shoppingCartList.count + 1; //加上推荐商品的区
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (_shoppingCartList.count > 0 && section < _shoppingCartList.count) {

        CartShopModel *csModel = _shoppingCartList[section];
        return csModel.goods.count + 1;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_shoppingCartList.count == 0 || indexPath.section == _shoppingCartList.count)
    {
        //商品推荐的区
        
        if (indexPath.row == 0) {
            
            JSSCRecommentLabCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommentLabCell" forIndexPath:indexPath];
            
            return cell;
        } else {
            
            _recommentCell = [tableView dequeueReusableCellWithIdentifier:@"recommentCell" forIndexPath:indexPath];
            
            _recommentCell.scRecommentCollView.delegate = self;
            _recommentCell.scRecommentCollView.dataSource = self;
            _recommentCell.scRecommentCollView.scrollEnabled = NO;
            
            [_recommentCell.scRecommentCollView registerNib:[UINib nibWithNibName:@"JSGoodsCVCell" bundle:nil] forCellWithReuseIdentifier:@"GoodsItem"];
            
            return _recommentCell;
        }
    } else {
        CartShopModel *csModel = _shoppingCartList[indexPath.section];
        
        if (indexPath.row == 0) {
            JSSCShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopCell" forIndexPath:indexPath];
            cell.storeNameLabel.text = csModel.shopName;
            cell.selectButton.tag = indexPath.section;
            cell.editButton.tag = indexPath.section;
            if (csModel.edit) {
                [cell.editButton setTitle:@"完成" forState:UIControlStateNormal];
            } else {
                [cell.editButton setTitle:@"编辑" forState:UIControlStateNormal];
            }
            cell.selectButton.selected = csModel.isSelected;
            cell.picked = csModel.isSelected;
            
            return cell;
            
        } else if(csModel.edit) {
            JSSCEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCartCell" forIndexPath:indexPath];
            ShoppingCart *info = csModel.goods[indexPath.row - 1];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:info.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
            cell.delButton.tag = indexPath.section * 10000 + indexPath.row;
            cell.selectButton.selected = info.isPicked;
            cell.numberTF.text =  [NSString stringWithFormat:@"%ld",  (long)info.number];
            
            __weak typeof(cell) weakCell = cell;
            [cell setDidChangeNumBlock:^(NSInteger num) {
                [weakCell setEditItemsUserInteractionEnabled:NO];
                [self requestEditShoppingCartNumberWithCartID:info.mallShoppingcartId number:[NSString stringWithFormat:@"%ld", (long)num] finish:^(BOOL success) {
                    if (!success) {
                        weakCell.numberTF.text = [NSString stringWithFormat:@"%ld", (long)info.number];
                    }else {
                        info.number = num;
                        weakCell.numberTF.text = [NSString stringWithFormat:@"%ld", (long)num];
                    }
                    [weakCell setEditItemsUserInteractionEnabled:YES];
                }];
            }];
            
            return cell;
        } else {
            JSShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartCell" forIndexPath:indexPath];
            cell.segmentControl.delegate = self;
            ShoppingCart *info = csModel.goods[indexPath.row - 1];
            cell.segmentControl.currentValue = info.number;
            cell.nameLabel.text = info.goodsName;
            cell.specLab.text = info.spec;
            cell.numLabel.text = [NSString stringWithFormat:@"x %ld", (long)info.number];
            cell.goodsPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", info.price];
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:info.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
            
            cell.segmentControl.tag = indexPath.section * 10000 + indexPath.row-1;
            cell.pickButton.tag = indexPath.section * 10000 + indexPath.row-1;
            cell.delButton.tag = indexPath.section * 10000 + indexPath.row-1;
            cell.picked = info.isPicked;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_shoppingCartList.count == 0) {
        return 260;
    } else {
        return M_HEADER_HIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_shoppingCartList.count == 0) {
         UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 260)];
        [headerView addSubview:_emptyView];
        return headerView;
    } else {
        return nil;
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _shoppingCartList.count) {
        return UITableViewCellEditingStyleNone;
    } else {
        if (indexPath.row == 0) {
            return UITableViewCellEditingStyleNone;
        } else {
            //设置编辑风格为删除风格
            return UITableViewCellEditingStyleDelete;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shoppingCartList.count > indexPath.section) {
        CartShopModel *csModel = _shoppingCartList[indexPath.section];
        return !csModel.isEdit;
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        CartShopModel *csModel = _shoppingCartList[indexPath.section];
        ShoppingCart *info = csModel.goods[indexPath.row-1];
        
        [self requestDelShoppingCartWithCartID:info.mallShoppingcartId];
        [csModel.goods removeObjectAtIndex:indexPath.row-1];
        
        if (csModel.goods.count == 0)
        {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            self.tabBarController.tabBar.hidden = NO;
        } else {
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        //删除更新总价
        _totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", [self caculateTotalPriceWithPickState:PickedStateNone]];
        [PRUitls delay:0.3 finished:^{
            [tableView reloadData];
        }];
    }

}

#pragma mark - UICollectionViewDelegateFlowLayout

//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //宽度（设备宽度 - 间距） / Item数量
    CGFloat width = WIDTH / 2;
    // 高度（宽度 * 宽高比例） + 文字高度
    return CGSizeMake(width, width*1.146f+52.0f);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _guessLike.remaiGoods.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSGoodsCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GoodsItem" forIndexPath:indexPath];

    WMGuess *guess = _guessLike.remaiGoods[indexPath.row];

    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:guess.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    cell.nameLabel.text = guess.name;
    
    //wm 用户没有登录只显示零售价  登录并认证后显示零售和批发价

    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = [NSString stringWithFormat:@"批:￥%.2f/%@", guess.wholesalePrice,guess.unit?guess.unit:@""];
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        cell.piPriceLabel.text = @"认证可见";
    } else {
        cell.piPriceLabel.text = @"登录认证可见";
    }
    cell.lingPriceLabel.text = [NSString stringWithFormat:@"零:￥%.2f/%@", guess.goods_retail_price,guess.unit?guess.unit:@""];
    
    cell.soldNumLabel.text = [NSString stringWithFormat:@"销量:%d", guess.goodsSales];
    [cell.addShopCarBtn addTarget:self action:@selector(shopCarAddShopCarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.addShopCarBtn.tag = indexPath.row;

    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转商品详情界面
    
    WMGuess *guess = _guessLike.remaiGoods[indexPath.row];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Category" bundle:[NSBundle mainBundle]];
    JSGoodsDetailVC *vc = [sb instantiateViewControllerWithIdentifier:@"GoodsDetailVC"];
    vc.goodsID = guess.goodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
