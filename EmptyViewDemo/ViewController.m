//
//  ViewController.m
//  EmptyViewDemo
//
//  Created by CJQ on 2018/4/19.
//  Copyright © 2018年 CJQ. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "UIScrollView+CLEmptyView.h"
#import "CLEmtpyView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, CLEmptyDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.emptyDataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)addData:(id)sender {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [_dataArray addObject:[NSString stringWithFormat:@"这是UILabel，Num=%d", arc4random()]];
    [self.tableView reloadData];
}

- (IBAction)clearData:(id)sender {
    [_dataArray removeAllObjects];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.label.text = _dataArray[indexPath.row];
    
    return cell;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
