//
//  WTBarrageRowContainer.m
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import "WTBarrageRowContainer.h"


@interface WTBarrageRowContainer ()
@property (nonatomic,strong) NSTimer*               barrageTimer;
@property (nonatomic,strong) NSMutableArray*        barrages;
@end

@implementation WTBarrageRowContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.barrages = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)start{
    
    [self startTimer];
}

- (void)stop{
    
    self.rowContainerBlock = nil;
    [self stopTimer];
}

- (void)startTimer{

    if(!self.barrageTimer){
        self.barrageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.barrageTimer forMode:NSRunLoopCommonModes];
    }
}


- (void)stopTimer{
    
    if(self.barrageTimer){
        [self.barrageTimer invalidate];
        self.barrageTimer = nil;
    }
}

- (void)refresh{
    
    WTBarrageItem* lastItem = [self.barrages lastObject];
    if(lastItem){
        CGPoint pt = lastItem.layer.presentationLayer.position;
        CGSize size = lastItem.layer.presentationLayer.bounds.size;
        CGFloat x = pt.x + size.width / 2 + 40;
        if(x > [UIScreen mainScreen].bounds.size.width){
            return;
        }
        [self loadBarrage];
    }else {
        [self loadBarrage];
    }
}


- (void)loadBarrage{
    
    __weak __typeof(self)weakSelf = self;
    WTBarrageContent* barrageText = nil;
    if(self.rowContainerBlock){
        barrageText = self.rowContainerBlock();
    }
    if(barrageText){
        WTBarrageItem* item = [WTBarrageItem barrageItemWithContent:barrageText];
        [item animate:^(WTBarrageItem *_item) {
            [weakSelf.barrages removeObject:_item];
            [_item removeFromSuperview];
        }];
        [self.barrages addObject:item];
        [self addSubview:item];
    }
}

@end
