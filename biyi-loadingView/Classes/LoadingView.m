//
//  LoadingView.m
//  BIYI_HomeKit
//
//  Created by hexiaolin on 2020/7/21.
//  Copyright © 2020 BIYIOranization. All rights reserved.
//

#import "LoadingView.h"
static CGFloat kWaveWidth = 50;
@interface LoadingView ()

@property (nonatomic, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) CAShapeLayer *waveLayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *upLabel;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LoadingView


+ (instancetype)sharedSingleton {
    static LoadingView *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[LoadingView alloc] init];
    });
    return _sharedSingleton;
}

-(instancetype)init
{
    if (self = [super init]) {

    }
    return  self;
}
-(void)showInView:(UIView *)fView
{
    self.frame = fView.bounds;
    self.offset = 0;
    self.speed = 6;
    [self addSubview:self.bgView];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [self.bgView addSubview:self.label];
    [self.bgView addSubview:self.upLabel];
    
    self.label.center = CGPointMake(self.bgView.frame.size.width * 0.5, self.bgView.frame.size.height * 0.5);
    self.upLabel.center = self.label.center;
    
    [self.bgView.layer insertSublayer:self.waveLayer below:self.label.layer];
    self.upLabel.layer.mask = self.shapeLayer;
    [fView addSubview:self];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(waveAction)];
    [self.displayLink addToRunLoop:NSRunLoop.currentRunLoop forMode:NSRunLoopCommonModes];
}
-(void)hide
{
    [self removeFromSuperview];
    if (self.displayLink != nil) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

- (void)updateWaveWithWidth: (CGFloat)width height: (CGFloat)height {
    CGFloat degree = M_PI/180.0;
    
    CGMutablePathRef wavePath = CGPathCreateMutable();
    CGPathMoveToPoint(wavePath, NULL, 0, height);
    
    CGFloat offsetX = 0;
    while (offsetX < width) {
        CGFloat offsetY = height * 0.5 + 10 * sinf(offsetX * degree + self.offset * degree * self.speed);
        CGPathAddLineToPoint(wavePath, NULL, offsetX, offsetY);
        offsetX += 1.0;
    }
    
    CGPathAddLineToPoint(wavePath, NULL, width, height);
    CGPathAddLineToPoint(wavePath, NULL, 0, height);
    CGPathCloseSubpath(wavePath);
    
    self.waveLayer.path = wavePath;
    self.waveLayer.fillColor = [[[UIColor blueColor] colorWithAlphaComponent:0] CGColor];
    self.shapeLayer.path = wavePath;
    
}

- (void)waveAction {
    self.offset += 1;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    [self updateWaveWithWidth:width height:height];
}


#pragma mark - setter & getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    return _bgView;
}

- (CAShapeLayer *)waveLayer {
    if (!_waveLayer) {
        _waveLayer = [[CAShapeLayer alloc] init];
        _waveLayer.frame = CGRectMake(0, 0, kWaveWidth, kWaveWidth);
    }
    return _waveLayer;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont boldSystemFontOfSize:22];
        _label.textColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            _label.backgroundColor = [UIColor tertiarySystemGroupedBackgroundColor];
        } else {
            // Fallback on earlier versions
        }
        _label.layer.cornerRadius = 5;
        _label.layer.masksToBounds = true;
        _label.text = @"比翼平台";
        [_label sizeToFit];
    }
    return _label;
}

- (UILabel *)upLabel {
    if (!_upLabel) {
        _upLabel = [[UILabel alloc] init];
        _upLabel.font = [UIFont boldSystemFontOfSize:22];
        _upLabel.textColor = [UIColor blueColor];
        _upLabel.text = @"比翼平台";
        [_upLabel sizeToFit];
    }
    return _upLabel;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.bounds = self.bgView.bounds;
        _shapeLayer.position = CGPointMake(self.label.bounds.size.width * 0.5, self.label.bounds.size.height * 0.5);
    }
    return _shapeLayer;
}
@end
