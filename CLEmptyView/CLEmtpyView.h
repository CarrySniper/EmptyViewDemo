//
//  CLEmtpyView.h
//  EmptyViewDemo
//
//  Created by CJQ on 2018/4/18.
//  Copyright © 2018年 CJQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLEmtpyViewActionBlock)(UIButton *sender);

@interface CLEmtpyView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, copy) CLEmtpyViewActionBlock actionBlock;

@end
