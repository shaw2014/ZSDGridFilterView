//
//  ZSDGridFilterView.m
//  demo
//
//  Created by zhaoxiao on 14/12/16.
//  Copyright (c) 2014年 zhaoxiao. All rights reserved.
//

#import "ZSDGridFilterView.h"
#import "ZSDIssueView.h"

#define kDefaultHeight ((kItemHeight * kRowCount) + 5.0f)     //高度
#define kNumCountPerPage (kColumnCount * kRowCount)                //每页的期数

@interface ZSDGridFilterView ()<UIScrollViewDelegate,ZSDIssueViewDelegate>
{
    UIScrollView *issueScrollView;
    NSMutableArray *issueArray;
    
}

@property (nonatomic,assign) BOOL haveMore;
@property (nonatomic,assign) NSInteger currentPageIndex;

@end

@implementation ZSDGridFilterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        issueArray = [[NSMutableArray alloc]initWithCapacity:3];
        
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    CGRect frect = CGRectZero;
    frect.size.width = self.bounds.size.width;
    frect.size.height = kDefaultHeight;
    frect.origin.y = -frect.size.height;
    issueScrollView = [[UIScrollView alloc]initWithFrame:frect];
    issueScrollView.backgroundColor = [UIColor clearColor];
    issueScrollView.showsHorizontalScrollIndicator = NO;
    issueScrollView.showsVerticalScrollIndicator = NO;
    issueScrollView.alwaysBounceVertical = NO;
    issueScrollView.pagingEnabled = YES;
    issueScrollView.scrollEnabled = YES;
    issueScrollView.delegate = self;
    [self addSubview:issueScrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackground:)];
    [self addGestureRecognizer:tapGesture];
}

//设置最大期数
-(void)setMaxIssueNum:(NSInteger)maxIssueNum
{
    if(_maxIssueNum != maxIssueNum)
    {
        _maxIssueNum = maxIssueNum;
        
        [self createIssueViews];
    }
}

//创建期数视图
-(void)createIssueViews
{
    [self clear];
    
    int createPageCount = 0;
    int pages = ceilf((CGFloat)_maxIssueNum / kNumCountPerPage);
    if(pages <= 2)
    {
        createPageCount = pages;
    }
    else
    {
        createPageCount = 3;
    }
    
    CGRect frect = CGRectZero;
    NSInteger issueCount = 0;
    //最多创建3个可重用的子视图
    for (int i = 0; i < createPageCount; i++) {
        frect.origin.x = i * issueScrollView.bounds.size.width;
        frect.origin.y = 0;
        frect.size.width = issueScrollView.bounds.size.width;
        frect.size.height = kDefaultHeight;
        ZSDIssueView *issueView = [[ZSDIssueView alloc]initWithFrame:frect];
        if(i < createPageCount - 1)
        {
            issueCount = kNumCountPerPage;
        }
        else
        {
            issueCount = ((_maxIssueNum - i * kNumCountPerPage) > kNumCountPerPage ? kNumCountPerPage : (_maxIssueNum - i * kNumCountPerPage));
        }
        issueView.issueCount = issueCount;
        issueView.beginIssue = _maxIssueNum - i * kNumCountPerPage;
        issueView.delegate = self;
        [issueScrollView addSubview:issueView];     //添加到scrollview
        [issueArray addObject:issueView];           //添加到数组中
    }
    
    if((_maxIssueNum - createPageCount * kNumCountPerPage) > 0)
    {
        _haveMore = YES;
    }
    
    issueScrollView.contentSize = CGSizeMake(issueScrollView.bounds.size.width * createPageCount, issueScrollView.bounds.size.height);
}

#pragma mark -ZSDIssueViewDelegate
-(void)issueView:(ZSDIssueView *)issueView didSelectedIssue:(NSInteger)issueNO
{
    if(_delegate && [_delegate respondsToSelector:@selector(gridView:didSelectedIssue:)])
    {
        [_delegate gridView:self didSelectedIssue:issueNO];
    }
    
    [self dismissView];
}

//清除view和数组
-(void)clear
{
    for (ZSDIssueView *issueView in issueArray) {
        [issueView removeFromSuperview];
    }
    [issueArray removeAllObjects];
}

-(void)reuseIssueViewWithIndex:(NSInteger)index
{
    if(index == 2 || index == 0)
    {
        if(index == 2)
        {
            ZSDIssueView *lastIssueView = issueArray[2];
            if(lastIssueView.issueCount == kNumCountPerPage && lastIssueView.beginIssue - lastIssueView.issueCount > 0)
            {//还有更多
                _haveMore = YES;
            }
            else
            {
                _haveMore = NO;
            }
            
            if(_haveMore)
            {
                ZSDIssueView *issueView = issueArray[0];
                issueView.beginIssue = lastIssueView.beginIssue - kNumCountPerPage;
                
                NSInteger issueCount = 0;
                if(issueView.beginIssue >= kNumCountPerPage)
                {
                    issueCount = kNumCountPerPage;
                }
                else
                {
                    issueCount = issueView.beginIssue;
                }
                issueView.issueCount = issueCount;
                
                [issueArray removeObject:issueView];
                [issueArray addObject:issueView];
                
                [self resetSubviews];
            }
        }
        else
        {
            ZSDIssueView *firstIssueView = issueArray[0];
            if(firstIssueView.beginIssue < _maxIssueNum)
            {
                _haveMore = YES;
            }
            else
            {
                _haveMore = NO;
            }
            
            if(_haveMore)
            {
                ZSDIssueView *issueView = issueArray[2];
                issueView.beginIssue = firstIssueView.beginIssue + kNumCountPerPage;
                issueView.issueCount = kNumCountPerPage;
                
                [issueArray removeObject:issueView];
                [issueArray insertObject:issueView atIndex:0];
                
                [self resetSubviews];
            }
        }
    }
}

//重置子视图
-(void)resetSubviews
{
    //删除原有的子视图
    for (ZSDIssueView *issueView in issueScrollView.subviews) {
        [issueView removeFromSuperview];
    }
    
    //添加重新排列的视图
    for (ZSDIssueView *issueView in issueArray) {
        NSInteger index = [issueArray indexOfObject:issueView];
        CGRect frame = issueView.frame;
        frame.origin.x = index * frame.size.width;
        issueView.frame = frame;
        
        [issueScrollView addSubview:issueView];
    }
    
    //滑动到中间的显示区域
    CGRect visibleRect = CGRectMake(issueScrollView.bounds.size.width, 0, issueScrollView.bounds.size.width, issueScrollView.bounds.size.height);
    [issueScrollView scrollRectToVisible:visibleRect animated:NO];

//    [issueScrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    self.currentPageIndex = 1;
    
//    NSLog(@"%f=======",issueScrollView.contentOffset.x);
}

-(void)tapBackground:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self];
    if(!CGRectContainsPoint(issueScrollView.frame, point))
    {
        [self dismissView];
    }
    else
    {
        CGPoint tempPoint = [self convertPoint:point toView:issueScrollView];
        
        ZSDIssueView *issueView = [issueArray objectAtIndex:_currentPageIndex];
        NSInteger lineCount = issueView.issueCount % kColumnCount == 0 ? issueView.issueCount / kColumnCount : issueView.issueCount / kColumnCount + 1;
        if(tempPoint.y > lineCount * kItemHeight)
        {
            [self dismissView];
        }
    }
}

//界面显示
-(void)showInView:(UIView *)baseView
{
    for (UIView *view in baseView.subviews) {
        if([view isKindOfClass:[ZSDGridFilterView class]])
        {
            return;
        }
    }
    
    CGRect frect = issueScrollView.frame;
    frect.origin.y = 0;
    
    [baseView addSubview:self];
    [UIView animateWithDuration:0.5f animations:^{
        issueScrollView.frame = frect;
    }];
    
    ZSDIssueView *issueView = [issueArray objectAtIndex:_currentPageIndex];
    [issueView layoutSubviews];
}

//界面消失
-(void)dismissView
{
    CGRect frect = issueScrollView.frame;
    frect.origin.y = -frect.size.height;
    
    [UIView animateWithDuration:0.5f animations:^{
        issueScrollView.frame = frect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = ceilf(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    if(self.currentPageIndex != pageIndex)
    {
        self.currentPageIndex = pageIndex;
        [self reuseIssueViewWithIndex:pageIndex];
    }
    
    ZSDIssueView *issueView = [issueArray objectAtIndex:_currentPageIndex];
    [issueView layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
