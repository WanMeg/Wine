//
//  PRSliderController.m
//  ELLife
//
//  Created by admin on 15/8/14.
//  Copyright (c) 2015年 JSheng. All rights reserved.
//

#import "PRSliderController.h"
#import "PRSliderSpecCell.h"
#import "PRSliderHeaderView.h"
#import "JSContact.h"
#import "PRSegmentControl.h"
#import "PRTableView.h"

#define SliderWidth 300.0f/375.0f*WIDTH

@interface PRSliderController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, PRSegmentControlDelegate>

@property(nonatomic, strong) PRSegmentControl *sc;
@property(nonatomic, strong) PRTableView *tableView;
@property(nonatomic, strong) UIButton *bottomButton;
@property(nonatomic, copy) PRSCCallBackBlock callBack;
@property(nonatomic, copy) getDataBlock getData;
@property(nonatomic, strong) PRSliderHeaderView *headerView;
@property(nonatomic, assign) CGFloat headerHeight;
@property(nonatomic, assign) NSUInteger totals;

@end

@implementation PRSliderController

- (instancetype)initWithTotals:(NSUInteger)totals header:(UIView *)header getData:(getDataBlock)getData callBack:(PRSCCallBackBlock)callBack {
    self = [super init];
    if (self) {
        if (header) {
//            self.headerView = header;
        } else {
            self.headerView = [[NSBundle mainBundle] loadNibNamed:@"PRSliderHeaderView" owner:self options:nil].firstObject;
            self.headerView.frame = CGRectMake(0, 0, WIDTH, CELL_HEIGHT_(102));
        }
        self.headerHeight = self.headerView.frame.size.height;
        
        self.callBack = callBack;
        self.getData = getData;
        self.totals = totals;
        
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        } else {
            [APPDELEGATE window].rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        }
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    self.tableView = [[PRTableView alloc] initWithFrame:CGRectMake(WIDTH, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight-49)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView setCallBack:^{
        [weakSelf.view endEditing:YES];
    }];
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SliderWidth, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 40, 44)];
    titleLabel.text = @"数量";
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    titleLabel.textColor = [UIColor lightGrayColor];
    [footer addSubview:titleLabel];
    
    self.sc = [[PRSegmentControl alloc] initWithFrame:CGRectMake(63, 0, 100, 30)];
    _sc.delegate = self;
    _sc.minValue = 1;
    [footer addSubview:_sc];
    self.tableView.tableFooterView = footer;
    
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _bottomButton.frame = CGRectMake(WIDTH, HEIGHT - 49, SliderWidth, 49);
    _bottomButton.backgroundColor = QLTY_MAIN_COLOR;
    [_bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(addToCartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PRSliderSpecCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"specCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

-(void)loadView {
    [super loadView];
    UIView *stautsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    stautsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stautsView];
    
    if (self.headerView != nil) {
        self.headerView.frame = CGRectMake(WIDTH, 20, SliderWidth, self.headerView.bounds.size.height);
        [self.view addSubview:self.headerView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSelectedItems:nil];
    
    if (_isGroupActivity) {
        [_bottomButton setTitle:@"加入团购" forState:UIControlStateNormal];
    } else {
        [_bottomButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showTableView];
    
    // 赋值
    [self.headerView.imgView sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
    if (M_MEMBER_LOGIN && M_IS_AUTHENTICA) {
        self.headerView.priceLabel.text = self.lingsPrice;
    } else if (M_MEMBER_LOGIN && !M_IS_AUTHENTICA) {
        self.headerView.priceLabel.text = @"认证可见";
    } else {
        self.headerView.priceLabel.text = @"登录认证可见";
    }
    self.headerView.lingshouPrice.text = self.pifaPrice;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //当视图消失的时候，回到上一页
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc {
    NSLog(@"sliderController dealloc");
}

#pragma mark Method 
/**
 *  更新选中的Items
 *
 *  @param indexPath 当前选中的下标
 */
- (void)updateSelectedItems:(NSIndexPath *)indexPath{
    if (self.selectedItems == nil || self.selectedItems.count == 0) {
        self.selectedItems = [NSMutableArray arrayWithCapacity:_totals];
        //初始化选中的item, 如以后需要加入库存判断再此方法中加入判断
        for (int i = 0; i<_totals; i++) {
            [self.selectedItems addObject:@(0)];
        }
    }
    
    if (indexPath) {
        _selectedItems[indexPath.section] = @(indexPath.row);
        //回调选择信息
        [self callBackSelectedDatas];
    }
}

/**
 *  回调到上一个页面  当前选中的 items和当前的数量
 */
- (void)callBackSelectedDatas {
    self.callBack(_selectedItems, _currentQuantity);
 //回调product
    if (self.fetchProduct) {
        Product *product = self.fetchProduct();
//        [self.headerView.imgView sd_setImageWithURL:[NSURL URLWithString:product.goodsImageUrl?product.goodsImageUrl:@""] placeholderImage:[UIImage imageNamed:@"noimage.png"]];
        self.headerView.priceLabel.text = [NSString stringWithFormat:@"%.2f",product.wholesalePrice];
    }
}

/**
 *  购物车点击事件 回调到商品详情页面
 *
 *  @param sender UIButton
 */
- (void)addToCartAction:(UIButton *)sender {
    if (self.addCartCallBack) {
        self.addCartCallBack();
    }
}

/**
 *  重写currentQuantity Setter
 *
 *  @param currentQuantity
 */
-(void)setCurrentQuantity:(NSUInteger)currentQuantity {
    _currentQuantity = currentQuantity;
    //更新数量选择空间当前值
    _sc.currentValue = currentQuantity;
}

/**
 *  背景View点击事件，回到上一个页面
 *
 *  @param tap
 */
- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self hideTableView:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

/**
 *  显示TableView动画效果
 */
-(void)showTableView {
    [UIView animateWithDuration:0.2f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.tableView.frame = CGRectMake(WIDTH-SliderWidth, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight+49));
        self.headerView.frame = CGRectMake(WIDTH - SliderWidth, 20,SliderWidth,self.headerView.bounds.size.height);
        self.bottomButton.frame = CGRectMake(WIDTH - SliderWidth, HEIGHT - 49, SliderWidth, 49);
    }];
}

/**
 *  隐藏TableView动画效果
 *
 *  @param ended 动画完成回调Block
 */
- (void)hideTableView:(void (^)(BOOL finished))ended{
    [UIView animateWithDuration:0.2f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        self.tableView.frame = CGRectMake(WIDTH, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight));
        self.headerView.frame = CGRectMake(WIDTH, 20,SliderWidth,self.headerView.bounds.size.height);
    } completion:^(BOOL finished) {
        ended(finished);
    }];
}


#pragma mark - PRSliderController delegate 
- (void)didBeginEditingWithSegmentControl:(PRSegmentControl *)segmentControl {
    
}

/**
 *  数量选择空间Delegate 值改变的时候方法
 *
 *  @param segmentControl 当前的控件
 *  @param value 改变的值
 */
-(void)segmentControl:(PRSegmentControl *)segmentControl changedValue:(NSUInteger)value {
    self.currentQuantity = value;
    [self callBackSelectedDatas];
}
#pragma mark Gesture recognizer delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.view) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark Table view delegate

#pragma mark Table view datasource


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     [self.view endEditing:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totals;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     //得到listView的高度  ***在这里ListView本身并无用处！！！
    GBTagListView *listView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, 0, TagListViewWidth, 0)];
    GoodsSpecifications *specs = self.getData(indexPath.row);
   
    CGFloat height = [listView setTagWithItemCount:specs.productSpecificationsValues.count fetchString:^NSString *(int index) {
        ProductSpecificationsValue *value = specs.productSpecificationsValues[index];
        return value.specificationsValue;
    }];
    return height+16;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PRSliderSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"specCell" forIndexPath:indexPath];
    if (self.getData) {
        GoodsSpecifications * gs = self.getData(indexPath.row);
        cell.titleLabel.text = gs.specificationsName;
        cell.values = gs.productSpecificationsValues;
    }
    __weak typeof(self) weakSelf = self;
    //ListView的Item点击时间回调
    [cell.listView setDidselectItemBlock:^(NSInteger index) {
        [weakSelf updateSelectedItems: [NSIndexPath indexPathForRow:index inSection:indexPath.row]];
    }];
    //设置当前选中的Item  **默认为每条第一个
    NSNumber *num = _selectedItems[indexPath.row];
    [cell.listView didSelectItemWithTag:num.intValue];
    return cell;
}


/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
