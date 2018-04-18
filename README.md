# EmptyViewDemo
列表没有数据的时候显示自定义View提示。适用于UITableView、UICollectionView。

##截图
![](https://github.com/cjq002/EmptyViewDemo/raw/master/IMAGE/demo.png) 
 
## 使用方法
### 1导入两个文件
UIScrollView+CLEmptyView.h和UIScrollView+CLEmptyView.m
### 2引用包含头文件
#import "UIScrollView+CLEmptyView.h"
### 3设置代理CLEmptyDataSource
self.tableView.emptyDataSource = self;
### 4实现代理方法
```
#pragma mark - CLEmptyDataSource
/**
 空数据时UI设置回调
 
 @param scrollView 对象
 @return 需要展示的UI
 */
- (UIView *)cl_emptyViewDataSource:(UIScrollView *)scrollView {
    //这里想显示什么都可以自己写，量多的话，就考虑自己写个基类或封装
    CLEmtpyView *view = [[CLEmtpyView alloc]init];
    view.actionBlock = ^(UIButton *sender) {
        NSLog(@"点击事件");
    };
    return view;
}

/**
 空数据UI偏移设置回调
 
 @param scrollView 对象
 @return 偏移量
 */
- (CGPoint)cl_emptyViewOffset:(UIScrollView *)scrollView {
    return CGPointMake(0, 0);
}
```
