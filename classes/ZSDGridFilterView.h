//
//  ZSDGridFilterView.h
//  demo
//
//  Created by zhaoxiao on 14/12/16.
//  Copyright (c) 2014年 zhaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZSDGridFilterView;
@protocol ZSDGridFilterViewDelegate <NSObject>

-(void)gridView:(ZSDGridFilterView *)gridView didSelectedIssue:(NSInteger)issue;

@end

@interface ZSDGridFilterView : UIView

@property (nonatomic,assign) NSInteger maxIssueNum;     //最大期数
@property (nonatomic,assign) NSInteger currentIssue;    //当前期数

@property (nonatomic,assign) id<ZSDGridFilterViewDelegate> delegate;

//界面显示
-(void)showInView:(UIView *)baseView;

@end
