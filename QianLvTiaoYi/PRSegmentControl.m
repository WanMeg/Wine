//
//  PRSegmentControl.m
//  QianLvTiaoYi
//
//  Created by JiaSheng on 15/11/2.
//  Copyright © 2015年 JSheng. All rights reserved.
//

#import "PRSegmentControl.h"

@interface PRSegmentControl()<UITextFieldDelegate>

@property (nonatomic, strong) IBInspectable UITextField *textField;
@property (nonatomic, assign, getter=isLeftTap) BOOL leftTap;
@property (nonatomic, assign, getter=isRightTap) BOOL rightTap;
@end

@implementation PRSegmentControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.maxValue = 99;
    self.minValue = 0;
    self.cornerRadius = 0;
    self.borderColor = [UIColor grayColor];
    self.borderWidth = 1;
    self.tintColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
    self.fontColor = [UIColor darkTextColor];
    self.fontSize = 12;
    
    self.textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_textField];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = _cornerRadius;
    self.layer.masksToBounds = _cornerRadius > 0 ? YES : NO;
    
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
    
    _textField.textColor = _fontColor;
    _textField.font = [UIFont systemFontOfSize:_fontSize];
    _textField.frame = CGRectMake(CGRectGetWidth(self.frame)*0.33, 0, CGRectGetWidth(self.frame)*0.33, CGRectGetHeight(self.frame));
    if (_currentValue < _minValue) {
        _textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_minValue];
    }else if(_currentValue > _maxValue) {
        _textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_maxValue];
    }else{
        _textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_currentValue];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    //点击控件左侧
     CGPoint location = [touch locationInView:self];
    if (location.x < CGRectGetWidth(self.frame)/2){
        _leftTap = YES;
    }else{
        _rightTap = YES;
    }
    [self setNeedsDisplay];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (self.isEnabled) {
        [super endTrackingWithTouch:touch withEvent:event];
        [self endEditing:YES];
        [self handleTouch:touch];
//        [self clearsContextBeforeDrawing];
        [self setNeedsDisplay];
    }
}

- (void)handleTouch: (UITouch *)touch {
    CGPoint location = [touch locationInView:self];
    _currentValue = _textField.text.intValue;
      _leftTap = NO;
      _rightTap = NO;
    //点击控件左侧
    if (location.x < CGRectGetWidth(self.frame)/2) {
        if (_currentValue > _minValue) {
            _currentValue--;
        }else{
            _currentValue = _minValue;
        }
    //点击控件右侧
    }else{
        if (_currentValue < _maxValue) {
            _currentValue++;
        }else{
            _currentValue = _maxValue;
        }
    }
    //delegate 传递改变值
    if ([_delegate respondsToSelector:@selector(segmentControl:changedValue:)]) {
        [_delegate segmentControl:self changedValue:_currentValue];
    }
    _textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_currentValue];
}

- (void)setCurrentValue:(NSUInteger)currentValue {
    _currentValue = currentValue;
    _textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)currentValue];
}


#pragma mark - TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = [NSString stringWithFormat:@"%@%@", textField.text, string];
    //通过退格键
    if ([string isEqualToString:@""]) {
        _currentValue = str.intValue;
        return YES;
    }
    
    //过滤掉除去数字以外的字符
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filter = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    if([filter isEqualToString:@""]){
        return NO;
    }
    
    //大于最大值，则改变为最大值，返回否
    if (str.intValue > _maxValue) {
        textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_maxValue];
        _currentValue = _maxValue;
        return NO;
    }
    //小于最小值，则改变为最小值，返回否
    if (str.intValue < _minValue) {
        textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_minValue];
        _currentValue = _minValue;
        return NO;
    }
    _currentValue = str.intValue;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    _currentValue = textField.text.intValue;
    if (textField.text.intValue > _maxValue) {
        _currentValue = _maxValue;
    }
    if (textField.text.intValue < _minValue) {
        _currentValue = _minValue;
    }
    textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_currentValue];
    //delegate 传递改变值
    if ([_delegate respondsToSelector:@selector(segmentControl:changedValue:)]) {
        [_delegate segmentControl:self changedValue:_currentValue];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_currentValue > _maxValue) {
        _currentValue = _maxValue;
    }
    if (_currentValue < _minValue) {
        _currentValue = _minValue;
    }
    textField.text = [NSString stringWithFormat:@"%ld", (unsigned long)_currentValue];
    
    if ([_delegate respondsToSelector:@selector(didBeginEditingWithSegmentControl:)]) {
        [_delegate didBeginEditingWithSegmentControl:self];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

    UIColor *color = _borderColor;
    [color set];
    
    UIBezierPath *aPath1 = [UIBezierPath bezierPath];
    aPath1.lineWidth = _borderWidth;
    aPath1.lineCapStyle = kCGLineCapRound;
    aPath1.lineJoinStyle = kCGLineCapRound;
    [aPath1 moveToPoint: CGPointMake(CGRectGetWidth(self.frame)*0.33, 0)];
    [aPath1 addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)*0.33, CGRectGetHeight(self.frame))];
    [aPath1 closePath];
    [aPath1 stroke];
    
    UIBezierPath *aPath2 = [UIBezierPath bezierPath];
    aPath2.lineWidth = _borderWidth;
    aPath2.lineCapStyle = kCGLineCapRound;
    aPath2.lineJoinStyle = kCGLineCapRound;
    
    [aPath2 moveToPoint: CGPointMake(CGRectGetWidth(self.frame)*0.66, 0)];
    [aPath2 addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)*0.66, CGRectGetHeight(self.frame))];
    [aPath2 closePath];
    [aPath2 stroke];
    
    UIColor *tapedColor = [UIColor colorWithRed:0xee/255.0 green:0xee/255.0 blue:0xee/255.0 alpha:1.0];
    UIColor *unTapColor = _tintColor;
//    CGFloat fSize = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    UIFont *font = [UIFont boldSystemFontOfSize: _fontSize];
    
    CGRect minusRect = CGRectMake(0, 0, CGRectGetWidth(self.frame)*0.33, CGRectGetHeight(self.frame));
    if (_leftTap) {
         [self drawString:@"－" inRect:minusRect font:font textColor:tapedColor];
    }else{
        [self drawString:@"－" inRect:minusRect font:font textColor:unTapColor];
    }
    
    CGRect plusRect = CGRectMake(CGRectGetWidth(self.frame)*0.66, 0, CGRectGetWidth(self.frame)*0.33, CGRectGetHeight(self.frame));
    if (_rightTap) {
        [self drawString:@"＋" inRect:plusRect font:font textColor:tapedColor];
    }else{
        [self drawString:@"＋" inRect:plusRect font:font textColor:unTapColor];
    }
}

//画一个居中文本
- (void)drawString:(NSString *)text inRect:(CGRect)contextRect font:(UIFont *)font textColor:(UIColor *)textColor
{
    CGFloat fontHeight = font.lineHeight;
    CGFloat yOffset = floorf((contextRect.size.height - fontHeight) / 2.0) + contextRect.origin.y;
    
    CGRect textRect = CGRectMake(contextRect.origin.x, yOffset, contextRect.size.width, fontHeight);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    [text drawInRect:textRect withAttributes:@{NSKernAttributeName: @(0.0),
                                               NSForegroundColorAttributeName: textColor,
                                               NSFontAttributeName: font,
                                               NSParagraphStyleAttributeName: paragraphStyle}];
}

@end
