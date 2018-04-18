//
//  UIScrollView+CLEmptyView.h
//  EmptyViewDemo
//
//  Created by CJQ on 2018/4/18.
//  Copyright © 2018年 CJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLEmptyDataSource;

#pragma mark - Class Object
@interface UIScrollView (CLEmptyView)

@property (assign, nonatomic) id<CLEmptyDataSource> emptyDataSource;

@end


#pragma mark - CLEmptyDataSource
@protocol  CLEmptyDataSource<NSObject>
@optional

/**
 空数据时UI设置回调

 @param scrollView 对象
 @return 需要展示的UI
 */
- (UIView *)cl_emptyViewDataSource:(UIScrollView *)scrollView;

/**
 空数据UI偏移设置回调

 @param scrollView 对象
 @return 偏移量
 */
- (CGPoint)cl_emptyViewOffset:(UIScrollView *)scrollView;

@end
