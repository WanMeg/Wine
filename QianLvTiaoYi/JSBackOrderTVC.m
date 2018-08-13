//
//  JSBackOrderTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/6/7.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSBackOrderTVC.h"
#import "PRImageManager.h"

@interface JSBackOrderTVC ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *goodsPrice;
@property (weak, nonatomic) IBOutlet UILabel *goodsNum;

@property (weak, nonatomic) IBOutlet UIView *minusBtn;
@property (weak, nonatomic) IBOutlet UIView *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *applyforNum;
@property (weak, nonatomic) IBOutlet UILabel *maxNum;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *backGoodsLabs;
@property (nonatomic, assign) NSInteger selectIndex;

@property (weak, nonatomic) IBOutlet UILabel *tipsLab;
@property (weak, nonatomic) IBOutlet UITextView *questionDesTV;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *updateImgViews;
@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (weak, nonatomic) UIImageView *currentIV;  //当前选择上传的图片视图


@end

@implementation JSBackOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectIndex = 0;
    UILabel *label = _backGoodsLabs[0];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor redColor];
    
    _questionDesTV.delegate = self;
    [self setBasicInfo];
}

#pragma mark - Private Methods

- (void)setBasicInfo
{
    _minusBtn.layer.borderWidth = 1.0f;
    _minusBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _applyforNum.layer.borderWidth = 1.0f;
    _applyforNum.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _questionDesTV.layer.borderWidth = 1.0f;
    _questionDesTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _questionDesTV.layer.cornerRadius = 4.0f;
    _questionDesTV.clipsToBounds = YES;
    
    
    for (UILabel *label in _backGoodsLabs) {
        label.layer.borderWidth = 1.0f;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    
    //商品信息赋值
    [_goodsImg sd_setImageWithURL:[NSURL URLWithString:_backOrderGoods.goodsImgUrl] placeholderImage:[UIImage imageNamed:@"noimage"]];
    _goodsName.text = _backOrderGoods.goodsName;
    _goodsPrice.text = [NSString stringWithFormat:@"￥%.2f", _backOrderGoods.goodsRealityPrice];
    _goodsNum.text = [NSString stringWithFormat:@"数量:%d 件", _backOrderGoods.quantity];
    
    _maxNum.text = [NSString stringWithFormat:@"您最多可以提交的数量为%d件",_backOrderGoods.quantity];
    
    
    [_backGoodsLabs enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backGoodsLabTapClick:)];
         [obj addGestureRecognizer:tap];
     }];
    
    [_updateImgViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backOrderUploadBusinesPhoto:)];
         [obj addGestureRecognizer:tap];
     }];
}


- (void)backGoodsLabTapClick:(UITapGestureRecognizer *)sender
{
    _selectIndex = sender.view.tag;
    for (int i = 0; i < _backGoodsLabs.count; i++) {
        UILabel *label = _backGoodsLabs[i];
        if (i == sender.view.tag) {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor redColor];
        } else {
            label.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor blackColor];
        }
    }
}

/**
 * 图片点击手势
 **/
- (void)backOrderUploadBusinesPhoto:(UITapGestureRecognizer *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    sheet.tag = sender.view.tag;
    _currentIV = (UIImageView *)sender.view;
    [sheet showInView:self.view];
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
    
    //如果没有上传图片 就直接申请补货
    if (images.count == 0) {
        if (updateHandler) updateHandler(NO, uploadedURLs);
    }
}

#pragma mark - Http Request

/**
 *  申请补货请求
 */
- (void)applyforReplenishingOrderGoodsRequestWith:(NSMutableArray *)imgUrls
{
    NSString *imgStr = [NSString stringWithFormat:@"%@,%@,%@", imgUrls[0], imgUrls[1], imgUrls[2]];
    
    NSString *text = nil;
    if (_questionDesTV.text.length == 0) {
        text = @"";
    } else {
        text = _questionDesTV.text;
    }
    
    NSDictionary *param = @{@"orderNo":_backOrderNo,
                            @"refundCause":[NSString stringWithFormat:@"%ld",(long)_selectIndex],
                            @"refundExplain":_questionDesTV.text,
                            @"auditingNum":text,
                            @"goodsId":_backOrderGoods.orderGoodsId,
                            @"refundExplainImg":imgStr};
    
    /****判断输入是否含有表情****/

    if ([WMGeneralTool judgeStringContainsEmoji:_questionDesTV.text]) {
        [SVProgressHUD showErrorWithStatus:@"请不要输入表情和特殊符号！"];
        return;
    } else {
        [XLDataService postWithUrl:RMRequestStatusReplenishingOrderGoods param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
         {
             if (error.code == 100) {
                 [SVProgressHUD showSuccessWithStatus:error.domain];
                 [self.navigationController popToRootViewControllerAnimated:YES];
             } else {
                 [SVProgressHUD showErrorWithStatus:error.domain];
             }
         }];
    }
    
}


#pragma mark - Actions

/**
 *  返回上一界面
 */
- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  减号按钮点击事件
 */
- (IBAction)minusButtonClick:(id)sender
{
    if ([_applyforNum.text intValue] <= 1) {
        [SVProgressHUD showInfoWithStatus:@"申请数量最少为1件!"];
    } else {
        int number = [_applyforNum.text intValue];
        int num = number -1;
        _applyforNum.text = [NSString stringWithFormat:@"%d",num];
    }
}

/**
 *  加号按钮点击事件
 */
- (IBAction)addButtonClick:(id)sender
{
    if ([_applyforNum.text intValue] < _backOrderGoods.quantity) {
        int number = [_applyforNum.text intValue];
        int num = number +1;
        _applyforNum.text = [NSString stringWithFormat:@"%d",num];
    } else {
        [SVProgressHUD showInfoWithStatus:_maxNum.text];
    }
}

/**
 *  提交按钮点击事件
 */
- (IBAction)goNextButtonClick:(id)sender
{
    //上传图片
    __weak typeof(self) weakSelf = self;
    
    [self beginToUploadImagesWithUpdateHandler:^(BOOL success, NSMutableArray *imgURLs)
    {
        if (success) {
            [weakSelf applyforReplenishingOrderGoodsRequestWith:imgURLs];
        } else {
            [weakSelf applyforReplenishingOrderGoodsRequestWith:imgURLs];
        }
    }];
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
    self.selectedImages[_currentIV.tag] = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - textViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _tipsLab.text = nil;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (M_JUDGE_EMOJI) {
        return NO;
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - 重写Setter 和 Getter

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray arrayWithArray:@[@"", @"", @""]];
    }
    return _selectedImages;
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
