//
//  ZSDIssueView.h
//  demo
//
//  Created by zhaoxiao on 14/12/19.
//  Copyright (c) 2014年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kColumnCount 3
#define kRowCount 6
#define kItemHeight 45.0f

@class ZSDIssueView;
@protocol ZSDIssueViewDelegate <NSObject>

-(void)issueView:(ZSDIssueView *)issueView didSelectedIssue:(NSInteger)issueNO;

@end

@interface ZSDIssueView : UIView

@property (nonatomic,assign) NSInteger beginIssue;      //开始期数
@property (nonatomic,assign) NSInteger issueCount;      //当前页总期数

@property (nonatomic,assign) id<ZSDIssueViewDelegate> delegate;

@end
