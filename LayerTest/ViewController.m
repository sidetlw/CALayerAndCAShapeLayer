//
//  ViewController.m
//  LayerTest
//
//  Created by test on 16/2/29.
//  Copyright © 2016年 Mrtang. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
@import QuartzCore;

@interface ViewController ()
//@property (nonatomic) UIView *myView;
@property (nonatomic) CAShapeLayer *loadingLayer;
@property (nonatomic) NSTimer *timer;
@end

@implementation ViewController

//static inline double radians (double degrees) {return degrees * M_PI/180;}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // self.myView = [[UIView alloc] init];
   // self.myView.bounds = CGRectMake(0, 0, 100, 100);
  // self.myView.center = self.view.center;
   // NSLog(@"self.view.center.x = %f  y= %f width = %f",self.view.center.x,self.view.center.y,self.view.bounds.size.width);
    //self.myView.frame = CGRectMake(100, 20, 100, 100);
    //[self.view addSubview:self.myView];
    
    
    
    
    
    [self drawImage];
    //[self.view.layer addSublayer:[self CircleLayer]];
   // [self drawHalfCircle];
    
    
    
    
    
//    self.myView.transform = CGAffineTransformMakeScale(1, -1);
//    self.myView.transform =  CGAffineTransformTranslate(self.myView.transform, 0, -200);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 使用layer.contents来展示图片
- (void)drawImageWithContent
{
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = self.view.center;
    layer.cornerRadius = 50.0;
    
    layer.masksToBounds = YES;
    layer.borderColor = ([UIColor redColor].CGColor);
    layer.borderWidth = 1.0;
    
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"xuwei"].CGImage);
    [self.view.layer addSublayer:layer];
    
}

- (void)drawImage
{
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.position = self.view.center;
    layer.cornerRadius = 50.0;
    // 要设置此属性才能裁剪成圆形，但是添加此属性后，下面设置的阴影就没有了。
    layer.masksToBounds = YES;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 1.0;
    
    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"xuwei"].CGImage);

    // 指定代理
    //layer.delegate = self;
    
    // 添加到父图层上
    [self.view.layer addSublayer:layer];
    
    // 当设置masksToBounds为YES后，要想要阴影效果，就需要额外添加一个图层作为阴影图层了
    CALayer *shadowLayer = [CALayer layer];
    shadowLayer.position = layer.position;
    shadowLayer.bounds = layer.bounds;
    shadowLayer.cornerRadius = layer.cornerRadius;
    shadowLayer.shadowOpacity = 1.0;
    shadowLayer.shadowColor = [UIColor blackColor].CGColor;
    shadowLayer.shadowOffset = CGSizeMake(2, 1);
    shadowLayer.borderWidth = layer.borderWidth;
    shadowLayer.borderColor = [UIColor whiteColor].CGColor;
    [self.view.layer insertSublayer:shadowLayer below:layer];
    
    // 调用此方法，否则代理不会调用
    //[layer setNeedsDisplay];
}

#pragma mark - layer delegate
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);

    CGContextScaleCTM(ctx, 1, -1); //坐标轴是ios的默认坐标轴，y轴朝下，执行垂直翻转
    CGContextTranslateCTM(ctx, 0, -100);//此时，y轴朝上，将y下移即可
    
    UIImage *image = [UIImage imageNamed:@"xuwei"];
    CGContextDrawImage(ctx, CGRectMake(0, 0, 100, 100), image.CGImage);

    CGContextRestoreGState(ctx);
}


#pragma mark - 实现loading动画，与本文件其他地方代码是解耦的
- (CAShapeLayer *)CircleLayer {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    // 指定frame，只是为了设置宽度和高度
    circleLayer.frame = CGRectMake(0, 0, 200, 200);
    // 设置居中显示
    circleLayer.position = self.view.center;
    // 设置填充颜色
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    // 设置线宽
    circleLayer.lineWidth = 2.0;
    // 设置线的颜色
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    
    // 使用UIBezierPath创建路径
    CGRect frame = CGRectMake(0, 0, 200, 200);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:frame];
    
    // 设置CAShapeLayer与UIBezierPath关联
    circleLayer.path = circlePath.CGPath;
    
    // 将CAShaperLayer放到某个层上显示
    //[self.view.layer addSublayer:circleLayer];
    
    return circleLayer;
}

- (void)drawHalfCircle {
    self.loadingLayer = [self CircleLayer];
    [self.view.layer addSublayer:self.loadingLayer];

    // 这个是用于指定画笔的开始与结束点
    self.loadingLayer.strokeStart = 0.0;
    self.loadingLayer.strokeEnd = 0.0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(updateCircle)
                                                userInfo:nil
                                                 repeats:YES];
    
    }

- (void)updateCircle
{
    if (self.loadingLayer.strokeEnd < 1.0 && self.loadingLayer.strokeStart < 1.0) {
        self.loadingLayer.strokeEnd += 0.1;
    }
    else if(self.loadingLayer.strokeEnd >= 1.0 && self.loadingLayer.strokeStart < 1.0)
    {
        self.loadingLayer.strokeStart += 0.1;
    }
    else if(self.loadingLayer.strokeEnd >= 1.0 && self.loadingLayer.strokeStart >= 1.0)
    {
        [self.timer invalidate];
        self.timer = nil;
        [self.loadingLayer removeFromSuperlayer];
    }

}

- (IBAction)startTapped:(id)sender
{
    [self drawHalfCircle];
}
#pragma mark -

@end
