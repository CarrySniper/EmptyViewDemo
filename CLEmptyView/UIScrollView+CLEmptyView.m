//
//  UIScrollView+CLEmptyView.m
//  EmptyViewDemo
//
//  Created by CJQ on 2018/4/18.
//  Copyright © 2018年 CJQ. All rights reserved.
//

#import "UIScrollView+CLEmptyView.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>

static char emptyDataSourceKey;
static char emptyViewKey;

@interface UIScrollView ()
@property (nonatomic, readonly) UIView *emptyView;
@end

@implementation UIScrollView (CLEmptyView)


#pragma mark - Setting
- (void)setEmptyDataSource:(id<CLEmptyDataSource>)emptyDataSource {
    if (emptyDataSource) {
        objc_setAssociatedObject(self, &emptyDataSourceKey, emptyDataSource, OBJC_ASSOCIATION_ASSIGN);
        //黑科技 面向切面编程 AOP
        [self aspect_hookSelector:@selector(reloadData)
                      withOptions:AspectPositionAfter
                       usingBlock:^(id<AspectInfo> aspectInfo) {
             [self makeEmptyView];
         } error:NULL];
    }
}

#pragma mark - Getting
- (id<CLEmptyDataSource>)emptyDataSource {
    return objc_getAssociatedObject(self, &emptyDataSourceKey);
}

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, &emptyViewKey);
}

#pragma mark - 显示管理
- (void)makeEmptyView {
    self.emptyView.hidden = YES;
    for (UIView *view in [self.emptyView subviews]) {
        [view removeFromSuperview];
    }
    if ([self itemsCount] == 0 &&
        self.emptyDataSource &&
        [self.emptyDataSource respondsToSelector:@selector(cl_emptyViewDataSource:)]
        ) {
        UIView *view = [self.emptyDataSource cl_emptyViewDataSource:self];
        if (view) NSAssert([view isKindOfClass:[UIView class]], @"You must return a valid UIView object for -emptyViewDataSource:");
        
        // runtime
        objc_setAssociatedObject(self, &emptyViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:view];
        
        // 设置位置偏移
        CGPoint offset = [self emptyViewOffset];
        CGRect frame = view.frame;
        
        // 禁止将 AutoresizingMask 转换为 Constraints
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 添加 centerX 约束
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:offset.x];
        
        // 添加 centerY 约束
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:offset.y];
        
        // 添加 width 约束
        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:frame.size.width];

        // 添加 height 约束
        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:frame.size.height];
        
        //把约束添加到父视图上
        NSArray *array = @[widthConstraint, heightConstraint, centerXConstraint, centerYConstraint];
        [self addConstraints:array];
        
        
        NSLog(@"没有数据，显示空数据UI");
    }else{
    }
}

#pragma mark 空数据UI偏移设置回调
- (CGPoint)emptyViewOffset {
    CGPoint offset = CGPointMake(0, 0);
    if (self.emptyDataSource && [self.emptyDataSource respondsToSelector:@selector(cl_emptyViewOffset:)]) {
        offset = [self.emptyDataSource cl_emptyViewOffset:self];
    }
    return offset;
}

- (NSInteger)itemsCount {
    NSInteger items = 0;
    
    // UIScollView doesn't respond to 'dataSource' so let's exit
    if (![self respondsToSelector:@selector(dataSource)]) {
        return items;
    }
    
    // UITableView support
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *tableView = (UITableView *)self;
        id <UITableViewDataSource> dataSource = tableView.dataSource;
        
        NSInteger sections = tableView.numberOfSections;
        
        if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource tableView:tableView numberOfRowsInSection:section];
            }
        }
    }
    // UICollectionView support
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *collectionView = (UICollectionView *)self;
        id <UICollectionViewDataSource> dataSource = collectionView.dataSource;
        
        NSInteger sections = collectionView.numberOfSections;
        
        if (dataSource && [dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
            for (NSInteger section = 0; section < sections; section++) {
                items += [dataSource collectionView:collectionView numberOfItemsInSection:section];
            }
        }
    }
    return items;
}

@end


//#pragma mark -
//#pragma mark 黑科技 替换系统方法（影响全局，有很多安全隐患！）
//- (void)swizzlingMethod {
//    Class class = [self class];
//
//    SEL originalSelector = @selector(reloadData);
//    SEL swizzledSelector = @selector(cl_reloadData);
//
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
