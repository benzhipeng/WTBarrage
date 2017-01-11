//
//  WTBarrageItem.m
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import "WTBarrageItem.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define WT_UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface WTBarrageItem ()<CAAnimationDelegate>
@property (nonatomic,strong) UILabel *barrageItemLabel;
@property (nonatomic,strong) UIView  *contentView;
@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIImageView *trailImageView;
@property (nonatomic,copy) WTBarrageItemFinishedBlock finishedBlock;
@end

@implementation WTBarrageItem

- (void)addDashBorder{
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = WT_UIColorFromRGB(0x774520).CGColor;
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.contentView.bounds cornerRadius:10].CGPath;
    borderLayer.lineWidth = 1.f;
    borderLayer.lineCap = @"square";
    borderLayer.lineDashPattern = @[@3, @3];
    [self.contentView.layer addSublayer:borderLayer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView = ({
            
            UIView* view = [UIView new];
            view.layer.cornerRadius = 10;
            view.layer.masksToBounds = YES;
            view.backgroundColor = WT_UIColorFromRGB(0xe1eef8);
            view.alpha = 0.7f;
            [self addSubview:view];
            view;
        });
        
        self.avatarImageView = ({
            UIImageView* view = [[UIImageView alloc] init];
            view.layer.cornerRadius = 25;
            view.layer.masksToBounds = YES;
            [self addSubview:view];
            view;
        });
        
        self.trailImageView = ({
            UIImageView* view = [[UIImageView alloc] init];
            [self addSubview:view];
            view;
        });
        
        self.barrageItemLabel  = ({
            UILabel* label  = [[UILabel alloc] init];
            label.textColor = WT_UIColorFromRGB(0x774520);
            label.font = [UIFont systemFontOfSize:15];
            [self addSubview:label];
            label;
        });
        
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(20);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
            make.trailing.mas_equalTo(self.trailImageView.mas_trailing);
        }];
        
        [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.top.and.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
        }];
        
    
        [self.barrageItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.avatarImageView.mas_trailing);
            make.bottom.mas_equalTo(0);
            make.trailing.mas_equalTo(self.trailImageView.mas_leading).offset(10);
        }];
        
        [self.trailImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.mas_equalTo(0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
            make.trailing.mas_equalTo(0);
        }];
        
    }
    return self;
}


+ (instancetype)barrageItemWithContent:(WTBarrageContent*)content{

    NSString *avatarIcon = content.avatar;
    CGFloat s_w = [UIScreen mainScreen].bounds.size.width;
    WTBarrageItem* item = [[WTBarrageItem alloc] init];
    [item.avatarImageView sd_setImageWithURL:[NSURL URLWithString:avatarIcon] placeholderImage:content.avatarPlaceHolder];
    item.barrageItemLabel.text = content.content;
    item.trailImageView.image = content.trailImage;
    CGSize size =  [item systemLayoutSizeFittingSize:CGSizeMake(CGFLOAT_MAX, 50)];
    item.frame = CGRectMake(s_w, 0, size.width, 50);
    return item;
    
}


//返回一个Frame的中心点
CGPoint CenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

- (void)animate:(WTBarrageItemFinishedBlock)block{
    
    self.finishedBlock = block;
    CGRect goalFrame = self.frame;
    goalFrame.origin  = CGPointMake(-CGRectGetWidth(self.frame), CGRectGetMinY(self.frame));;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    animation.removedOnCompletion = true;
    animation.autoreverses = false;
    animation.fillMode = kCAFillModeForwards;
    [animation setToValue:[NSValue valueWithCGPoint:CenterPoint(goalFrame)]];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    CGFloat w = self.frame.size.width + [UIScreen mainScreen].bounds.size.width;
    [animation setDuration: (CGFloat)(w / 100)];
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}

- (void)animationDidStart:(CAAnimation *)anim{
    
    [self addDashBorder];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if(flag){
        if(self.finishedBlock){
            self.finishedBlock(self);
        }
    }
}
@end
