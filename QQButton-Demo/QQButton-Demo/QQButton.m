//
//  QQButton.m
//  QQButton-Demo
//
//  Created by 张建 on 2017/4/24.
//  Copyright © 2017年 JuZiShu. All rights reserved.
//

#import "QQButton.h"

#define kBtnW self.frame.size.width
#define kBtnH self.frame.size.height

@interface QQButton ()
//原Point
@property (nonatomic,assign)CGPoint originPoint;
//小圆视图
@property (nonatomic,strong)UIView * smallCircleView;
//绘制不规则图形
@property (nonatomic,strong)CAShapeLayer * shapeLayer;

@end
@implementation QQButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
     
        
    }
    return self;
}
//绘制不规则图形
- (CAShapeLayer *)shapeLayer{
    
    if (_shapeLayer == nil) {
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    
    return _shapeLayer;
}
//小圆视图
- (UIView *)smallCircleView{
    
    if (_smallCircleView == nil) {
        
        _smallCircleView = [[UIView alloc] init];
        _smallCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:_smallCircleView belowSubview:self];

    }
    return _smallCircleView;
}
#pragma mark ---设置角标---
- (void)setCorner:(NSString *)corner{
    
    _corner = corner;
    
    [self setTitle:_corner forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
}

#pragma mark ---refreshButton---
- (void)refreshButton{
    
    //====1.大圆
    //半径
    CGFloat cornerRadius = (kBtnH > kBtnW) ? (kBtnW / 2.0) : (kBtnH / 2.0);
    //大圆与小圆的最大距离
    _maxDistance = cornerRadius * 10;
    //切圆
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
    
    //原位置
    _originPoint = self.center;
    NSLog(@"x:%f y:%f",_originPoint.x,_originPoint.y);
    //===2.小圆
    //小圆半径
    self.smallCircleView.frame = CGRectMake(_originPoint.x - cornerRadius * 1.5 / 2.0, _originPoint.y - cornerRadius * 1.5 / 2.0, cornerRadius * 1.5 , cornerRadius * 1.5 );

       //切圆
    _smallCircleView.layer.cornerRadius = _smallCircleView.bounds.size.width / 2.0;
    
    //===3.添加拖动事件
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    //===4.添加点击事件
    [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark ---3.手势---
- (void)pan:(UIPanGestureRecognizer *)pan{
    
    
    CGPoint panPoint = [pan translationInView:self];
    
    CGPoint changePoint = self.center;
    changePoint.x += panPoint.x;
    changePoint.y += panPoint.y;
    
    //拖动后的位置
    self.center = changePoint;
    [pan setTranslation:CGPointZero inView:self];
    
    //两个圆的中心点之间的距离
    CGFloat dist = [self pointToPointDistanceWithPointA:self.center PointB:_smallCircleView.center];
    //如果距离大于最大距离
    if (dist < _maxDistance) {
        
        //小圆的大小
        CGFloat cornerRadius = kBtnH > kBtnW ? kBtnW / 2.0 : kBtnH / 2.0;
        CGFloat smallCircleRadius = cornerRadius - dist / 10;
        _smallCircleView.frame = CGRectMake(_originPoint.x - cornerRadius * 1.5 / 2.0, _originPoint.y - cornerRadius * 1.5 / 2.0, smallCircleRadius * 1.5 , smallCircleRadius * 1.5 );
        _smallCircleView.layer.cornerRadius = _smallCircleView.bounds.size.width / 2.0;
        
        if (self.smallCircleView.hidden == NO && dist > 0) {
            
            //画不规则矩形
            self.shapeLayer.path = [self pathWithBigCircleView:self SmallCircleView:_smallCircleView].CGPath;
        }
        
    }
    else {
        
        //销毁shapelayer
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
        
        //隐藏小圆
        self.smallCircleView.hidden = YES;
        
    }
    
    //手势
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        if (dist > _maxDistance) {
            
            //播放销毁动画
            [self startDestroyAnimations];
            
            //销毁全部控件
            [self killAll];
            
        }else {
            
            //移除layer
            [self.shapeLayer removeFromSuperlayer];
            self.shapeLayer = nil;
            
            //回弹动画
            [UIView animateWithDuration:0.3
                                  delay:0
                 usingSpringWithDamping:0.2
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionCurveEaseInOut animations:^{
                //回到原位置
                self.center = self.smallCircleView.center;
                
            } completion:^(BOOL finished) {
                
                //显示
                self.smallCircleView.hidden = NO;
                
            }];

            
        }
        
    }
    
}

#pragma mark ---btnClick---
- (void)btnClick:(UITapGestureRecognizer *)tap{
    
    NSLog(@"点击按钮的事件");
    
}
//两个圆中心点之间的距离
- (CGFloat)pointToPointDistanceWithPointA:(CGPoint)pointA PointB:(CGPoint)pointB{
    
    CGFloat offsetX = pointA.x - pointB.x;
    CGFloat offsetY = pointA.y - pointB.y;
    CGFloat dist = sqrtf(powf(offsetX, 2) + powf(offsetY, 2));
    
    return dist;
}
//绘制不规则路径
- (UIBezierPath *)pathWithBigCircleView:(UIView *)bigCircleView SmallCircleView:(UIView *)SmallCircleView{
    
    //大圆
    CGPoint bigCenter = bigCircleView.center;
    CGFloat cX2 = bigCenter.x;
    CGFloat cY2 = bigCenter.y;
    CGFloat cR2 = bigCircleView.bounds.size.width / 2.0;
    
    //小圆
    CGPoint smallCenter = SmallCircleView.center;
    CGFloat cX1 = smallCenter.x;
    CGFloat cY1 = smallCenter.y;
    CGFloat cR1 = SmallCircleView.bounds.size.width / 2.0;
    
    //获取圆心距离
    CGFloat dist = [self pointToPointDistanceWithPointA:bigCenter PointB:smallCenter];
    CGFloat sinθ = (cX2 - cX1) / dist;
    CGFloat cosθ = (cY2 - cY1) / dist;
    
    //坐标系基于父控件
    //小圆
    CGPoint pointA = CGPointMake(cX1 - cR1 * cosθ, cY1 + cR1 * sinθ);
    CGPoint pointB = CGPointMake(cX1 + cR1 * cosθ, cY1 - cR1 * sinθ);
    //大圆
    CGPoint pointC = CGPointMake(cX2 + cR2 * cosθ, cY2 - cR2 * sinθ);
    CGPoint pointD = CGPointMake(cX2 - cR2 * cosθ, cY2 + cR2 * sinθ);
    //A和D的中点
    CGPoint pointO = CGPointMake(pointA.x + dist / 2 * sinθ, pointA.y + dist / 2 * cosθ);
    //B和C的中点
    CGPoint pointP = CGPointMake(pointB.x + dist / 2 * sinθ, pointB.y + dist / 2 * cosθ);
    
    //bezier
    UIBezierPath * path = [UIBezierPath bezierPath];
    //A
    [path moveToPoint:pointA];
    //AB
    [path addLineToPoint:pointB];
    //绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

//播放销毁动画
- (void)startDestroyAnimations
{
    UIImageView *ainmImageView = [[UIImageView alloc] initWithFrame:self.frame];
    ainmImageView.animationImages = self.images;
    ainmImageView.animationRepeatCount = 1;
    ainmImageView.animationDuration = 0.5;
    [ainmImageView startAnimating];
    
    [self.superview addSubview:ainmImageView];
}

//销毁全部控件
- (void)killAll
{
    [self removeFromSuperview];
    [self.smallCircleView removeFromSuperview];
    self.smallCircleView = nil;
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
}


@end
