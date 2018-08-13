//
//  JSCommentBaskTVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/18.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSCommentBaskTVC.h"

#import "JSCommentBaskCell1.h"
#import "JSCommentBaskCell2.h"
#import "PRImageManager.h"

@interface JSCommentBaskTVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property(nonatomic,strong)JSCommentBaskCell2 *commentBaskcell2;

@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (weak, nonatomic) UIImageView *currentIV;  //当前选择上传的图片视图
@property (nonatomic, strong) UIActionSheet *sheet;

@end

@implementation JSCommentBaskTVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSLog(@"1 %d", _comments.commodityQuality);
//    NSLog(@"2 %d", _comments.mallGoodsCommentId);
//    NSLog(@"3 %@", _comments.goodsImg);
//    NSLog(@"4 %d",_comments.orderGoodsId);

}


#pragma mark - Private

/**
 *  请求评价晒单
 */
- (void)getCommentUpdateRequestWithWithURls:(NSMutableArray *)URLs
{
    
    NSString *photos = nil;
    
    switch (_selectedImages.count) {
        case 0:{
            photos = @"";
        }
            break;
        case 1:{
            photos = [NSString stringWithFormat:@"%@", URLs[0]];
        }
            break;
        case 2:{
            photos = [NSString stringWithFormat:@"%@,%@", URLs[0],URLs[1]];
        }
            break;
        case 3:{
            photos = [NSString stringWithFormat:@"%@,%@,%@", URLs[0],URLs[1],URLs[2]];
        }
            break;
        default:
            break;
    }

    
    NSDictionary *param = @{@"mallGoodsCommentId":[NSString stringWithFormat:@"%d",_comments.mallGoodsCommentId],@"commentContent":_commentBaskcell2.baskCell2TextView.text,@"commentImage": photos};
    
    [XLDataService getWithUrl:RMRequestStatusCommentsUpdate param:param modelClass:nil responseBlock:^(id dataObj, NSError *error)
    {
        if (error.code == 100) {
            [SVProgressHUD showSuccessWithStatus:error.domain];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

#pragma mark - Action Click

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [M_NOTIFICATION postNotificationName:@"backCommentCenterNotifi" object:nil userInfo:@{@"commentStatu": @"2"}];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  添加晒单图片
 */
- (IBAction)addCommentBaskImgBtnClick:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    
    [sheet showInView:self.view];
}

/**
 *  提交评价晒单
 */
- (IBAction)commitCommentBaskBtnClick:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    
    [WMGeneralTool beginToUploadImagesWithImgArray:_selectedImages withUpdateHandler:^(BOOL success, NSMutableArray *imgURLs) {
        if (success) {
            [weakSelf getCommentUpdateRequestWithWithURls:imgURLs];
        } else {
            [weakSelf getCommentUpdateRequestWithWithURls:imgURLs];
        }
    }];
    
}


/**
 *  发图片点击手势
 */
- (void)commentBackUpdatePhotoImgClick:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    _sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    _sheet.tag = sender.view.tag;
    _currentIV = (UIImageView *)sender.view;
    
    [_sheet showInView:self.view];
}

#pragma mark - actionSheetDelegate

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
        UIImageView *img = _commentBaskcell2.baskImageView[1];
        img.userInteractionEnabled = YES;
        img.image = [UIImage imageNamed:@"upcasex.png"];
        
    }
    
    if (_sheet.tag == 1) {
        UIImageView *img = _commentBaskcell2.baskImageView[2];
        img.userInteractionEnabled = YES;
        img.image = [UIImage imageNamed:@"upcasex.png"];
    }
    
    self.selectedImages[_currentIV.tag] = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return M_HEADER_HIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        JSCommentBaskCell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:@"CommentBaskCell1" forIndexPath:indexPath];
        [cell1.baskCell1HeadImg sd_setImageWithURL:[NSURL URLWithString:_comments.goodsImg] placeholderImage:[UIImage imageNamed:@"noimage"]];
        
        for (int i = 0; i < _comments.commodityQuality; i ++) {
            UIImageView *starImg = cell1.baskStarsImg[i];
            starImg.image = [UIImage imageNamed:@"pjhongxing"];
        }
        
        
        return cell1;
    }
    else
    {
        _commentBaskcell2 = [tableView dequeueReusableCellWithIdentifier:@"CommentBaskCell2" forIndexPath:indexPath];
        
        [_commentBaskcell2.baskImageView enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             obj.tag = idx;
             
             UIImageView *img = _commentBaskcell2.baskImageView[0];
             img.userInteractionEnabled = YES;
             
             UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentBackUpdatePhotoImgClick:)];
             [obj addGestureRecognizer:tap];
         }];
        
        if (_comments.commentContent.length == 0) {
            _commentBaskcell2.baskCell2TextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            _commentBaskcell2.baskCell2TextView.hidden = NO;
            _commentBaskcell2.baskCell2TextView.delegate = self;
        } else {
            [_commentBaskcell2.baskCell2TipsLab removeFromSuperview];
            
            _commentBaskcell2.baskCell2TextView.editable = NO;
            _commentBaskcell2.baskCell2TextView.text = _comments.commentContent;
        }
        
        return _commentBaskcell2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 135;
    } else {
        return 160;
    }
}

#pragma mark - UITextViewDelegate

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _commentBaskcell2.baskCell2TipsLab.text = nil;

    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSInteger count;
    count = 500 - textView.text.length;
    [_commentBaskcell2.baskCell2NumberLab setText:[NSString stringWithFormat:@"%ld", (long)count]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.location >= 500)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"输入的内容不能超过500字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return NO;
    }else{
        //        NSLog(@"%lu",(unsigned long)textView.text.length);
        return YES;
    }
}

#pragma mark - 重写Setter 和 Getter

- (NSMutableArray *)selectedImages {
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray arrayWithArray:@[@"", @""]];
    }
    return _selectedImages;
}

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
