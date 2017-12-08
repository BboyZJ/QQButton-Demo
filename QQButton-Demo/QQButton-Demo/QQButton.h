//
//  QQButton.h
//  QQButton-Demo
//
//  Created by 张建 on 2017/4/24.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQButton : UIButton

//设置角标
@property (nonatomic,strong)NSString * corner;

//大圆脱离小圆的最大距离
@property (nonatomic,assign)CGFloat maxDistance;

//按钮消失的动画图片数组
@property (nonatomic,strong)NSMutableArray * images;

//刷新按钮
- (void)refreshButton;

@end
