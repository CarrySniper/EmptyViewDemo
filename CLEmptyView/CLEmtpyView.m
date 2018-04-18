//
//  CLEmtpyView.m
//  EmptyViewDemo
//
//  Created by CJQ on 2018/4/18.
//  Copyright © 2018年 CJQ. All rights reserved.
//

#import "CLEmtpyView.h"

@implementation CLEmtpyView

- (instancetype)init
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    // 得到第n个UIView作为底部容器
    self = (CLEmtpyView *)[nibViews objectAtIndex:0];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.button.layer.cornerRadius = 22.0;
        self.button.layer.masksToBounds = YES;
        self.button.layer.borderWidth = 0.5;
        self.button.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return self;
}

- (IBAction)clickAction:(id)sender {
    if (self.actionBlock) {
        self.actionBlock(sender);
    }
}

@end
