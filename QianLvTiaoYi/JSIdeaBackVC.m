//
//  JSIdeaBackVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/4/27.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSIdeaBackVC.h"
#import "JSIdeaListView.h"
@interface JSIdeaBackVC ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topTwoViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *topColorLabels;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *ideaFourBtns;
@property (weak, nonatomic) IBOutlet UITextView *ideaTextView;

@property (weak, nonatomic) IBOutlet UILabel *ideaTipLab;

@property (weak, nonatomic) IBOutlet UILabel *ideaWordNumLab;

@property (nonatomic, copy) NSString *ideaTitle;
@property (nonatomic, strong) JSIdeaListView *ideaListView;

@end

@implementation JSIdeaBackVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *label = _topColorLabels[0];
    label.backgroundColor = [UIColor redColor];
    
    [self addThreeViewsTapClick];
    _ideaTextView.delegate = self;
}


#pragma mark - Private

/**
 *  上面两个view添加点击手势
 */
- (void)addThreeViewsTapClick
{
    [_topTwoViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         obj.tag = idx;
         obj.userInteractionEnabled = YES;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOfThreeViews:)];
         [obj addGestureRecognizer:tap];
     }];
}

/**
 *  创建留言列表view
 */
- (void)createIdeaListView
{
    _ideaListView = [[NSBundle mainBundle]loadNibNamed:@"JSIdeaListView" owner:self options:nil].firstObject;
    _ideaListView.frame = CGRectMake(0, 44, WIDTH, HEIGHT-44);
    [self.view addSubview:_ideaListView];
}

#pragma mark - Request

/**
 *  提交意见请求
 */
- (void)commitIdeaRequestWithTitle:(NSString *)title withContent:(NSString *)content
{
    [XLDataService postWithUrl:RMRequestStatusIdeaTroaction param:@{@"Title":title,@"Content":content} modelClass:nil responseBlock:^(id dataObj, NSError *error)
     {
         if (error.code == 100) {
             [SVProgressHUD showSuccessWithStatus:@"反馈成功"];
             [self.navigationController popToRootViewControllerAnimated:YES];
         } else {
             [SVProgressHUD showErrorWithStatus:error.domain];
         }
     }];
}

#pragma mark - Actions

/**
 *  上面两个view点击手势方法
 */
- (void)handleTapOfThreeViews:(UITapGestureRecognizer *)sender
{
    for (int i = 0; i < _topColorLabels.count; i++) {
        UILabel *label = _topColorLabels[i];
        if (i == sender.view.tag) {
            label.backgroundColor = [UIColor redColor];
        } else {
            label.backgroundColor = [UIColor whiteColor];
        }
    }
    
    if (sender.view.tag == 0) {
        [_ideaListView removeFromSuperview];
    } else {
        [self createIdeaListView];
    }
}

/**
 *  意见类型按钮方法
 */
- (IBAction)ideaKindButtonClick:(UIButton *)sender
{
    _ideaTitle = sender.titleLabel.text;

    for (int i = 0; i < _ideaFourBtns.count; i++) {
        UIButton *button = _ideaFourBtns[i];
        
        if (i == sender.tag - 10) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
        }
    }
}

- (IBAction)backUpVCClick:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  提交按钮  
 */
- (IBAction)commitButtonClick:(id)sender
{
    if (_ideaTitle == NULL) {
        [SVProgressHUD showErrorWithStatus:@"请选择问题类型"];
    } else {
        if (_ideaTextView.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"描述问题不能为空"];
        } else {
            [self commitIdeaRequestWithTitle:_ideaTitle withContent:_ideaTextView.text];
        }
    }
}

#pragma mark - UITextViewDelegate


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _ideaTipLab.text = nil;
    
    return YES;
}

/*

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(range.location >= 100) {
        [SVProgressHUD showErrorWithStatus:@"输入内容不能超过100字"];
        return NO;
    } else {
//        NSLog(@"%lu",(unsigned long)textView.text.length);
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger count;
    count = 100 - textView.text.length;
    [_ideaWordNumLab setText:[NSString stringWithFormat:@"%ld", (long)count]];
    if (count <= 0) {
        [_ideaWordNumLab setText:@"0"];
        [SVProgressHUD showErrorWithStatus:@"输入内容不能超过100字"];
    }
}

*/


@end
