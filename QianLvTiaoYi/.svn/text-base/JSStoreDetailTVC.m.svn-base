//
//  JSStoreDetailTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/16.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSStoreDetailTVC.h"
#import "UINavigationBar+Awesome.h"
#import "GetShopDetailData.h"

#import "DXPopover.h"

@interface JSStoreDetailTVC ()

@property (nonatomic, strong) WMShopDetail *shopDetail;

@property (weak, nonatomic) IBOutlet UIImageView *sDBannerImg;
@property (weak, nonatomic) IBOutlet UIImageView *sDLogoImg;
@property (weak, nonatomic) IBOutlet UILabel *sDShopName;
@property (weak, nonatomic) IBOutlet UIButton *sDCollectBtn;
@property (weak, nonatomic) IBOutlet UILabel *sDCompanyName;
@property (weak, nonatomic) IBOutlet UILabel *sDCompanyDes;
@property (weak, nonatomic) IBOutlet UILabel *sDCompanyAddress;
@property (weak, nonatomic) IBOutlet UILabel *sDOpenTime;

/*描述相符*/
@property (weak, nonatomic) IBOutlet UILabel *sDDesPoint;
@property (weak, nonatomic) IBOutlet UILabel *sDDesStatus;
@property (weak, nonatomic) IBOutlet UIImageView *sDDesImg;
@property (weak, nonatomic) IBOutlet UILabel *sDDesPercent;

/*卖家服务*/
@property (weak, nonatomic) IBOutlet UILabel *sDServicePoint;
@property (weak, nonatomic) IBOutlet UILabel *sDServiceStatus;
@property (weak, nonatomic) IBOutlet UIImageView *sDServiceImg;
@property (weak, nonatomic) IBOutlet UILabel *sDServicePercent;

/*物流速度*/
@property (weak, nonatomic) IBOutlet UILabel *sDDeliveryPoint;
@property (weak, nonatomic) IBOutlet UILabel *sDDeliveryStatus;
@property (weak, nonatomic) IBOutlet UIImageView *sDDeliveryImg;
@property (weak, nonatomic) IBOutlet UILabel *sDDeliveryPercent;

@property (nonatomic, copy) NSString *erWeiMaUrl;
@property (nonatomic, copy) NSString *zhiZhaoUrl;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, assign) BOOL isCollectShop;

@end

@implementation JSStoreDetailTVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;

    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    // 请求店铺详情数据
    [self getShopDetailRequestData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationLeftButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar lt_reset];
    
    self.navigationController.navigationBar.translucent = NO;
    
}
#pragma mark - HttpRequest

/**
 *  获取店铺详情数据
 */
- (void)getShopDetailRequestData
{
    __weak typeof(self) weakSelf = self;

    [GetShopDetailData postWithUrl:RMRequestStatusShopDetail param:@{@"shopId": _shopDetailId} modelClass:[WMShopDetail class] responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            
            weakSelf.shopDetail = dataObj;
            
            [self getSomeDataWith:dataObj];
            
            [_sDBannerImg sd_setImageWithURL:[NSURL URLWithString:_shopDetail.mallShop.imgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
            [_sDLogoImg sd_setImageWithURL:[NSURL URLWithString:_shopDetail.mallShop.shopLogo] placeholderImage:[UIImage imageNamed:@"noimage"]];
            
            _sDShopName.text = _shopDetail.mallShop.shopName;
            
            //收藏按钮
            if (_shopDetail.isCollect == YES) {
                
                [_sDCollectBtn setImage:[UIImage imageNamed:@"pjhongxing"] forState:UIControlStateNormal];
                [_sDCollectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            } else {
                [_sDCollectBtn setImage:[UIImage imageNamed:@"guanzhu0"] forState:UIControlStateNormal];
                [_sDCollectBtn setTitle:@"收藏店铺" forState:UIControlStateNormal];
            }
            
            
        /****************  ↓↓↓↓描述相符view上控件的显示状态↓↓↓↓  *****************/
            
            _sDDesPoint.text = _shopDetail.commodityQuality;
            
            if ([_shopDetail.commodityQualityStatus isEqualToString:@"Just"]) {
                //描述相符 行业大于店铺
                
                _sDDesImg.image = [UIImage imageNamed:@"shopdown"];
                _sDDesPoint.textColor = [UIColor greenColor];
                _sDDesStatus.text = @"低";
                _sDDesStatus.backgroundColor = [UIColor greenColor];
                _sDDesPercent.text = [NSString stringWithFormat:@"低于同行业%d%@",_shopDetail.commodityQualityPercentage,@"%"];
                
            } else if ([_shopDetail.commodityQualityStatus isEqualToString:@"negative"]) {
                //描述相符 行业低于店铺
                
                _sDDesImg.image = [UIImage imageNamed:@"shoptop"];
                _sDDesPoint.textColor = [UIColor redColor];
                _sDDesStatus.text = @"高";
                _sDDesStatus.backgroundColor = [UIColor redColor];
                _sDDesPercent.text = [NSString stringWithFormat:@"高于同行业%d%@",_shopDetail.commodityQualityPercentage,@"%"];
                
            } else {
                //描述相符 行业等于店铺
                
                _sDDesImg.image = [UIImage imageNamed:@"shoptop"];
                _sDDesPoint.textColor = [UIColor redColor];
                _sDDesStatus.text = @"等";
                _sDDesStatus.backgroundColor = [UIColor redColor];
                _sDDesPercent.text = [NSString stringWithFormat:@"等于同行业"];
            }
            
            
        /****************  ↓↓↓↓卖家服务view上控件的显示状态↓↓↓↓  *****************/
            
            _sDServicePoint.text = _shopDetail.serviceAttitude;
            
            if ([_shopDetail.serviceAttitudeStatus isEqualToString:@"Just"]) {
                //卖家服务 行业大于店铺
                
                _sDServiceImg.image = [UIImage imageNamed:@"shopdown"];
                _sDServicePoint.textColor = [UIColor greenColor];
                _sDServiceStatus.text = @"低";
                _sDServiceStatus.backgroundColor = [UIColor greenColor];
                _sDServicePercent.text = [NSString stringWithFormat:@"低于同行业%d%@",_shopDetail.serviceAttitudePercentage,@"%"];
                
            } else if ([_shopDetail.serviceAttitudeStatus isEqualToString:@"negative"]) {
                //卖家服务 行业低于店铺
                
                _sDServiceImg.image = [UIImage imageNamed:@"shoptop"];
                _sDServicePoint.textColor = [UIColor redColor];
                _sDServiceStatus.text = @"高";
                _sDServiceStatus.backgroundColor = [UIColor redColor];
                _sDServicePercent.text = [NSString stringWithFormat:@"高于同行业%d%@",_shopDetail.serviceAttitudePercentage,@"%"];
                
            } else {
                //卖家服务 行业等于店铺
                
                _sDServiceImg.image = [UIImage imageNamed:@"shoptop"];
                _sDServicePoint.textColor = [UIColor redColor];
                _sDServiceStatus.text = @"等";
                _sDServiceStatus.backgroundColor = [UIColor redColor];
                _sDServicePercent.text = [NSString stringWithFormat:@"等于同行业"];
            }
     
        /****************   ↓↓↓↓物流速度view上控件的显示状态↓↓↓↓   *****************/
            
            _sDDeliveryPoint.text = _shopDetail.deliveryTime;
            
            if ([_shopDetail.deliveryTimeStatus isEqualToString:@"Just"]) {
                //物流速度 行业大于店铺
                
                _sDDeliveryImg.image = [UIImage imageNamed:@"shopdown"];
                _sDDeliveryPoint.textColor = [UIColor greenColor];
                _sDDeliveryStatus.text = @"低";
                _sDDeliveryStatus.backgroundColor = [UIColor greenColor];
                _sDDeliveryPercent.text = [NSString stringWithFormat:@"低于同行业%d%@",_shopDetail.deliveryTimePercentage,@"%"];
                
            } else if ([_shopDetail.deliveryTimeStatus isEqualToString:@"negative"]) {
                //物流速度 行业低于店铺
                
                _sDDeliveryImg.image = [UIImage imageNamed:@"shoptop"];
                _sDDeliveryPoint.textColor = [UIColor redColor];
                _sDDeliveryStatus.text = @"高";
                _sDDeliveryStatus.backgroundColor = [UIColor redColor];
                _sDDeliveryPercent.text = [NSString stringWithFormat:@"高于同行业%d%@",_shopDetail.deliveryTimePercentage,@"%"];
                
            } else {
                //物流速度 行业等于店铺
                
                _sDDeliveryImg.image = [UIImage imageNamed:@"shoptop"];
                _sDDeliveryPoint.textColor = [UIColor redColor];
                _sDDeliveryStatus.text = @"等";
                _sDDeliveryStatus.backgroundColor = [UIColor redColor];
                _sDDeliveryPercent.text = [NSString stringWithFormat:@"等于同行业"];
            }
            
            
            //公司名称
            _sDCompanyName.text = _shopDetail.mallShop.shopName;
            //公司简介
            _sDCompanyDes.text = _shopDetail.mallShop.shopDepict;
            //所在地区
            _sDCompanyAddress.text = _shopDetail.mallShop.companyAddress;
            //开店时间
            _sDOpenTime.text = _shopDetail.mallShop.enterTime;
        }
    }];
}


/**
 *  获取客服电话，营业执照，二维码数据
 */
- (void)getSomeDataWith:(WMShopDetail *)shopDetail
{

    _erWeiMaUrl = shopDetail.mallShop.shopGeneralizeQrcode;
    _zhiZhaoUrl = shopDetail.mallShop.licenseElectronic;
    _phone = shopDetail.mallShop.mobile;

    NSLog(@"_erWeiMaUrl = %@ %@ %@",_erWeiMaUrl,_zhiZhaoUrl,_phone);
}


/**
 *  收藏店铺的请求
 */
- (void)getShopCollectRequest
{
    __weak typeof(self) weakSelf = self;
    
    [XLDataService postWithUrl:RMRequestStatusAddCollect param:@{@"shopId": _shopDetailId} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             weakSelf.shopDetail.isCollect = _isCollectShop;
             [SVProgressHUD showSuccessWithStatus:error.domain];
         }
     }];
}


#pragma mark - Private

/**
 *  设置顶部导航信息按钮  收藏按钮状态
 */
- (void)setNavigationLeftButton
{
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    //导航栏右侧按钮
    UIImage *image = [[UIImage imageNamed:@"return.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item= [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleRightButtons:)];
    self.navigationItem.leftBarButtonItem = item;
    
    
    _sDCollectBtn.layer.cornerRadius = 4;
    _sDCollectBtn.clipsToBounds = YES;
    _sDCollectBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _sDCollectBtn.layer.borderWidth = 1.0f;
}

#pragma mark - Actions

/**
 *  导航条左侧按钮点击事件
 */
- (void)handleRightButtons:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  收藏按钮点击事件
 *
 *  延时刷新数据
 */
- (IBAction)collectButtonClick:(id)sender
{
    [self getShopCollectRequest];
    
    [PRUitls delay:0.5 finished:^{
        [self getShopDetailRequestData];
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //拨打客服电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phone]]];
    }
}
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"拨打客服热线" message:_phone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        [alert show];
    } else if (indexPath.row == 2) {
        //二维码
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_erWeiMaUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
        DXPopover *popover = [DXPopover popover];
        [popover showAtView:_sDCollectBtn withContentView:imageV];
    } else if (indexPath.row == 4) {
        //营业执照
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_zhiZhaoUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
        DXPopover *popover = [DXPopover popover];
        [popover showAtView:_sDCollectBtn withContentView:imageV];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
