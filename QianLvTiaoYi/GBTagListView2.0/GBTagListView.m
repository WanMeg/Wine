//
//  GBTagListView.m
//  升级版流式标签支持点击
//
//  Created by 张国兵 on 15/8/16.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTagListView.h"
#define HORIZONTAL_PADDING 10.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       8.0f
#define BOTTOM_MARGIN      8.0f
#define KBtnTag            0
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface GBTagListView(){
    CGFloat KTagMargin;//左右tag之间的间距
    CGFloat KBottomMargin;//上下tag之间的间距
}

@end
@implementation GBTagListView
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        totalHeight=0;
        self.frame=frame;
        _tagArr=[[NSMutableArray alloc]init];
        self.canTouch = YES;
    }
    return self;
}

- (void)awakeFromNib {
    totalHeight=0;
    _tagArr=[[NSMutableArray alloc]init];
}

- (CGFloat)setTagWithItemCount:(NSUInteger)count fetchString:(NSString *(^)(int index))fetchString{
    
    [[self subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    previousFrame = CGRectZero;
    
    for (int i = 0; i < count; i++) {
        NSString *str = fetchString(i);
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        tagBtn.userInteractionEnabled=_canTouch;
        
        [tagBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [tagBtn setTitleColor:_buttonTintColor forState:UIControlStateSelected];
        tagBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [tagBtn setTitle: str forState:UIControlStateNormal];
        tagBtn.tag=KBtnTag+i;
        tagBtn.layer.cornerRadius=3;
        tagBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        tagBtn.layer.borderWidth=0.5;
        tagBtn.clipsToBounds=YES;
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
        CGSize Size_str=[str sizeWithAttributes:attrs];
        Size_str.width += HORIZONTAL_PADDING*3;
        Size_str.height += VERTICAL_PADDING*3;
        CGRect newRect = CGRectZero;
        if(KTagMargin&&KBottomMargin){
            
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + KTagMargin > self.bounds.size.width) {
                newRect.origin = CGPointMake(8, previousFrame.origin.y + Size_str.height + KBottomMargin);
                totalHeight +=Size_str.height + KBottomMargin;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + KTagMargin, previousFrame.origin.y);
            }
            [self setHight:self andHight:totalHeight+Size_str.height + KBottomMargin];
            
        }else{
            if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
                
                newRect.origin = CGPointMake(8, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
                totalHeight +=Size_str.height + BOTTOM_MARGIN;
            }
            else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        }
        newRect.size = Size_str;
        [tagBtn setFrame:newRect];
        previousFrame=tagBtn.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:tagBtn];
    }
    return CGRectGetHeight(self.frame);
}

#pragma mark-改变控件高度
- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

-(void)tagBtnClick:(UIButton*)button{
    button.selected=!button.selected;
    [self didSelectItemWithTag:button.tag];
}

-(void)didSelectItemWithTag:(NSInteger)tag{
    if (self.didselectItemBlock) {
            self.didselectItemBlock(tag);
    }
    for(UIView*view in self.subviews){
        if([view isKindOfClass:[UIButton class]]){
            UIButton*tempBtn=(UIButton*)view;
            if (tempBtn.tag == tag) {
                [tempBtn setSelected:YES];
                 tempBtn.layer.borderColor = _buttonTintColor.CGColor;
            }else{
                [tempBtn setSelected:NO];
                tempBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            }
        }
    }
}

-(void)setMarginBetweenTagLabel:(CGFloat)Margin AndBottomMargin:(CGFloat)BottomMargin{
    KTagMargin=Margin;
    KBottomMargin=BottomMargin;
}
@end
