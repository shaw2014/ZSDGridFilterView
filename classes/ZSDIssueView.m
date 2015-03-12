//
//  ZSDIssueView.m
//  demo
//
//  Created by zhaoxiao on 14/12/19.
//  Copyright (c) 2014年 zhaoxiao. All rights reserved.
//

#import "ZSDIssueView.h"
#import "ZSDGridFilterView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kBaseTag 1000

@interface ZSDIssueView ()

@end

@implementation ZSDIssueView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = UIColorFromRGB(0xE5E5E5);
    }
    
    return self;
}

-(void)setIssueCount:(NSInteger)issueCount
{
    if(_issueCount != issueCount)
    {
        _issueCount = issueCount;
        
        [self clearSubviews];
        [self createSubviews];
    }
}

-(void)setBeginIssue:(NSInteger)beginIssue
{
    if(_beginIssue != beginIssue)
    {
        _beginIssue = beginIssue;
        
        [self layoutSubviews];
    }
}

-(void)createSubviews
{
    CGFloat width = (self.bounds.size.width - (kColumnCount - 1)) / (CGFloat)kColumnCount;
    
    for (int i = 0; i < _issueCount; i++) {
        CGRect frect = CGRectZero;
        frect.origin.x = (i % kColumnCount) * (width + 1);
        frect.origin.y = (i / kColumnCount) * (kItemHeight + 1);
        frect.size.width = width;
        frect.size.height = kItemHeight;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:frect];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitle:[NSString stringWithFormat:@"标题%d",i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:kBaseTag + i];
        [self addSubview:btn];
    }
    
    NSInteger rowCount = ceilf((CGFloat)_issueCount / kColumnCount);
    if(rowCount > kRowCount)
    {
        rowCount = kRowCount;
    }
    CGFloat totalHeight = rowCount * kItemHeight + (rowCount - 1);
    CGRect frect = self.frame;
    frect.size.height = totalHeight;
    self.frame = frect;
}

-(void)clearSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < _issueCount; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:kBaseTag + i];
        [btn setTitle:[NSString stringWithFormat:@"第%ld期",_beginIssue - i] forState:UIControlStateNormal];
        
        ZSDGridFilterView *gridFilterView = (ZSDGridFilterView *)self.delegate;
        if(_beginIssue - i == gridFilterView.currentIssue)
        {
            [btn setTitleColor:UIColorFromRGB(0xDA4453) forState:UIControlStateNormal];
        }
        else
        {
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        }
    }
}

-(void)buttonAction:(UIButton *)sender
{
    NSInteger selIndex = sender.tag - kBaseTag;
    NSInteger selectedIssue = _beginIssue - selIndex;
    
    if(_delegate && [_delegate respondsToSelector:@selector(issueView:didSelectedIssue:)])
    {
        [_delegate issueView:self didSelectedIssue:selectedIssue];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
