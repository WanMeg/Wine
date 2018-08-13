//
//  PRAddressSliderVC.m
//  QianLvTiaoYi
//
//  Created by JSHENG on 16/1/6.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "PRAddressSliderVC.h"
#import "JSContact.h"

#define SliderWidth 250.0f/375.0f*WIDTH

@interface PRAddressSliderVC ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic, copy) PRASCCallBackBlock callBack;
@property(nonatomic, copy) PRAGetDataBlock getData;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, assign) CGFloat headerHeight;

@end

@implementation PRAddressSliderVC
- (instancetype)initWithTotals:(NSUInteger)totals header:(UIView *)header getData:(PRAGetDataBlock)getData callBack:(PRASCCallBackBlock)callBack{
    self = [super init];
    if (self) {
        if (header != nil) {
            self.headerHeight = header.frame.size.height;
        }else{
            self.headerHeight = 0;
        }
        self.callBack = callBack;
        self.getData = getData;
        self.totals = totals;
        self.headerView = header;
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }else{
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(WIDTH, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight)) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showTableView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc {
    NSLog(@"sliderController dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Method

- (void)tapHandler:(UITapGestureRecognizer *)tap {
    [self hideTableView:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

-(void)showTableView {
    [UIView animateWithDuration:0.2f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        self.tableView.frame = CGRectMake(WIDTH-SliderWidth, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight));
        self.headerView.frame = CGRectMake(WIDTH - SliderWidth, 20,SliderWidth,self.headerView.bounds.size.height);
    }];
}

- (void)hideTableView:(void (^)(BOOL finished))ended{
    [UIView animateWithDuration:0.2f animations:^{
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
        self.tableView.frame = CGRectMake(WIDTH, 20+self.headerHeight, SliderWidth, HEIGHT-(20+self.headerHeight));
        self.headerView.frame = CGRectMake(WIDTH, 20,SliderWidth,self.headerView.bounds.size.height);
    } completion:^(BOOL finished) {
        ended(finished);
    }];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.callBack != nil) {
        self.callBack(indexPath.row);
    }
//    [self hideTableView:^(BOOL finished) {
//        [self dismissViewControllerAnimated:NO completion:nil];
//    }];
}

#pragma mark Table view datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totals;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.textColor = ELLIFE_GRAY;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.backgroundColor = [UIColor clearColor];
    //实时回调获取数据
    if (self.getData) {
        cell.textLabel.text = self.getData(indexPath.row);
    }
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
