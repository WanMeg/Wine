//
//  JSSMDetailVC.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 16/5/23.
//  Copyright © 2016年 JSheng. All rights reserved.
//

#import "JSSMDetailVC.h"

@interface JSSMDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *newsContentLab;

@end

@implementation JSSMDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.newsContentLab.text = _newsContent;
    self.newsTitleLab.text = _newsTitle;
}

- (IBAction)backUpVCClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
