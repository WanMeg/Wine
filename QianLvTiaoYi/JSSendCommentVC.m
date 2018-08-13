//
//  JSSendCommentVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/1.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSendCommentVC.h"

#import "JSSendCommentTabVCell.h"
#import "Goods.h"
#import "PRImageManager.h"

@interface JSSendCommentVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *sendCommentTabView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UITextView *sendTextView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *describeStarImgs;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *sendImgViews;
@property (weak, nonatomic) IBOutlet UILabel *sendPhotoLab;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (weak, nonatomic) UIImageView *currentIV;  //当前选择上传的图片视图
@property (nonatomic, strong) JSSendCommentTabVCell *sendCommentCell;
@property (nonatomic, assign) NSInteger seleteStarNum1;
@property (nonatomic, assign) NSInteger seleteStarNum2;
@property (nonatomic, assign) NSInteger seleteStarNum3;
@property (nonatomic, strong) UIActionSheet *sheet;
@property (nonatomic, copy) NSDictionary *parma;

@end

@implementation JSSendCommentVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sendTextView.delegate = self;
    _sendCommentTabView.delegate = self;
    _sendCommentTabView.dataSource = self;
    
    //设置商品图片
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:_sendGoodsImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
    
    [self addDescribeStarImgsTapGesture];
    
    [_sendImgViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         UIImageView *image = _sendImgViews[0];
         image.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCommentUploadBusinessPhoto:)];
         [obj addGestureRecognizer:tap];
     }];
}


/**
 *  发图片点击手势
 */
- (void)sendCommentUploadBusinessPhoto:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    _sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    _sheet.tag = sender.view.tag;
    _currentIV = (UIImageView *)sender.view;

    [_sheet showInView:self.view];
}

#pragma mark - ActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;//设置可编辑
    switch (buttonIndex) {
        case 0:{
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;//相机
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 1:{
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//相册
            picker.sourceType = sourceType;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
        default:
            // 取消
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    UIImage *selectedImage = [PRImageManager imageCompressForSize:image targetSize:CGSizeMake(500, 500)];
    _currentIV.image = selectedImage;
    
    if (_sheet.tag == 0) {
        
        _sendPhotoLab.frame = CGRectMake(184, 154, 42, 21);
        UIImageView *img = _sendImgViews[1];
        img.userInteractionEnabled = YES;
        img.image = [UIImage imageNamed:@"upcasex.png"];
    }
    
    if (_sheet.tag == 1) {
        [_sendPhotoLab removeFromSuperview];
        UIImageView *img = _sendImgViews[2];
        img.userInteractionEnabled = YES;
        img.image = [UIImage imageNamed:@"upcasex.png"];
    }
    
    self.selectedImages[_currentIV.tag] = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Private

/**
 *  请求发送评论
 */
- (void)getSendCommentRequestWithCommodityQuality:(NSInteger)num1 withDeliveryTime:(NSInteger)num2 withServiceAttitude:(NSInteger)num3 withWithURls:(NSMutableArray *)URLs
{
    NSString *photos = [NSString stringWithFormat:@"%@,%@,%@", URLs[0],URLs[1],URLs[2]];
    
    
    if ([photos isEqualToString:@",,"]) {
        //不传图片
        _parma = @{@"orderGoodsId":_sendGoodsId,
                   @"orderNo":_sendOrderNo,
                   @"commodityQuality":[NSString stringWithFormat:@"%ld",(long)num1],
                   @"deliveryTime":[NSString stringWithFormat:@"%ld",(long)num2],
                   @"serviceAttitude":[NSString stringWithFormat:@"%ld",(long)num3],
                   @"commentContent":_sendTextView.text};

    } else {
        //传图片
        _parma = @{@"orderGoodsId":_sendGoodsId,
                   @"orderNo":_sendOrderNo,
                   @"commodityQuality":[NSString stringWithFormat:@"%ld",(long)num1],
                   @"deliveryTime":[NSString stringWithFormat:@"%ld",(long)num2],
                   @"serviceAttitude":[NSString stringWithFormat:@"%ld",(long)num3],
                   @"commentContent":_sendTextView.text,
                   @"commentImage":photos };
    }
    
    /****判断是否含有表情****/
    if ([WMGeneralTool judgeStringContainsEmoji:_sendTextView.text]) {
        [SVProgressHUD showErrorWithStatus:@"请不要输入表情和特殊符号！"];
        return;
    } else {
        
        [XLDataService postWithUrl:RMRequestStatusSendComments param:_parma modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
             if (error.code == 100) {
                 [SVProgressHUD showSuccessWithStatus:error.domain];
                 
                 //发表成功后 返回会员中心
                 [PRUitls delay:0.5 finished:^{
                     [self.navigationController popToRootViewControllerAnimated:YES];
                 }];
             } else {
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }
         }];
    }
}

/**
 *  添加描述相符星星图片的点击手势
 */
- (void)addDescribeStarImgsTapGesture
{
    [_describeStarImgs enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj.tag = idx;
        obj.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(describeStarImgsTapGestureClick:)];
        [obj addGestureRecognizer:tap];
    }];
}


#pragma mark - Actions


/**
 *  描述相符星星图片的点击手势方法
 */
- (void)describeStarImgsTapGestureClick:(UITapGestureRecognizer *)sender
{
    _seleteStarNum1 = sender.view.tag + 1;
    [WMGeneralTool setStarImgWithArray:_describeStarImgs withTag:sender.view.tag];
}

/**
 *  发货速度星星图片的点击手势方法
 */
- (void)sendOutSpeedStarImgsTapGestureClick:(UITapGestureRecognizer *)sender
{
    _seleteStarNum2 = sender.view.tag + 1;
    [WMGeneralTool setStarImgWithArray:_sendCommentCell.sendOutSpeedStarImgs withTag:sender.view.tag];
}

/**
 *  服务态度星星图片的点击手势方法
 */
- (void)serveAttitudeStarImgsTapGestureClick:(UITapGestureRecognizer *)sender
{
    _seleteStarNum3 = sender.view.tag + 1;
    [WMGeneralTool setStarImgWithArray:_sendCommentCell.serveAttitudeStarImgs withTag:sender.view.tag];
}


/**
 *  开始上传图片
 */
- (void)beginToUploadImagesWithUpdateHandler:(void (^)(BOOL success, NSMutableArray *imgURLs))updateHandler
{
    NSMutableArray *images = [NSMutableArray array];
    for (id obj in _selectedImages) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [images addObject: obj];
        }
    }
    
    __block int count  = 0;
    NSMutableArray *uploadedURLs = [NSMutableArray arrayWithObjects:@"", @"", @"", nil];
    for (int i = 0; i < images.count; i++) {
        UIImage *img = images[i];
        [WMGeneralTool uploadImages:img name:@"file" fileName:[NSString stringWithFormat:@"business%d.png", i] mimeType:@"image/png" callBack:^(BOOL success, NSString *url) {
            if (success) {
                uploadedURLs[i] = url;
                count++;
                if (count == images.count) {
//                    [SVProgressHUD showSuccessWithStatus:@"图片上传完成"];
                    if (updateHandler) updateHandler(YES, uploadedURLs);
                }
            }else {
                [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
                if (updateHandler) updateHandler(NO, uploadedURLs);
            }
        }];
    }
    //如果没有上传图片 就直接发表评论
    if (images.count == 0) {
        if (updateHandler) updateHandler(NO, uploadedURLs);
    }
}


/**
 *  发表评论按钮
 */
- (IBAction)sendCommentBtnClick:(UIButton *)sender
{
    if (_seleteStarNum1 == 0  || _seleteStarNum2 == 0 || _seleteStarNum3 == 0) {
        M_ALERTSHOW_(@"请选择星星数量");
    } else {
        if (_sendTextView.text.length == 0) {
            M_ALERTSHOW_(@"评论内容不能为空")
        } else {
            //先调用上传图片请求
            __weak typeof(self) weakSelf = self;
            

            [self beginToUploadImagesWithUpdateHandler:^(BOOL success, NSMutableArray *imgURLs)  {
                 if (success) {
                     //图片上传成功后发表评论
                     [weakSelf getSendCommentRequestWithCommodityQuality:_seleteStarNum1 withDeliveryTime:_seleteStarNum2 withServiceAttitude:_seleteStarNum3 withWithURls:imgURLs];
                 } else {
                     //没上传图片发表评论
                     [weakSelf getSendCommentRequestWithCommodityQuality:_seleteStarNum1 withDeliveryTime:_seleteStarNum2 withServiceAttitude:_seleteStarNum3 withWithURls:imgURLs];
                 }
             }];
        }
    }
}


- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [M_NOTIFICATION postNotificationName:@"backCommentCenterNotifi" object:nil userInfo:@{@"commentStatu": @"1"}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate & datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _sendCommentCell = [tableView dequeueReusableCellWithIdentifier:@"sendCommentCell" forIndexPath:indexPath];
    
    [_sendCommentCell.sendOutSpeedStarImgs enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendOutSpeedStarImgsTapGestureClick:)];
         [obj addGestureRecognizer:tap];
     }];
    
    [_sendCommentCell.serveAttitudeStarImgs enumerateObjectsUsingBlock:^(UIImageView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(serveAttitudeStarImgsTapGestureClick:)];
         [obj addGestureRecognizer:tap];
     }];
    
    return _sendCommentCell;
}

#pragma mark - textViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _tipsLabel.text = nil;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (M_JUDGE_EMOJI) {
        return NO;
    }
    return YES;
}

#pragma mark - 重写Setter 和 Getter

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray arrayWithArray:@[@"", @""]];
    }
    return _selectedImages;
}

@end
