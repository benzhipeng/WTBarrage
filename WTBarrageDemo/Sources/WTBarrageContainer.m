//
//  WTBarrageContainer.m
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import "WTBarrageContainer.h"
#import "Masonry.h"


@interface WTBarrageContainer ()
@property (nonatomic,strong) dispatch_queue_t   barrageQueue;
@property (nonatomic,strong) NSMutableArray*    barrages;
@property (nonatomic,strong) WTBarrageRowContainer* row1;
@property (nonatomic,strong) WTBarrageRowContainer* row2;
@end

@implementation WTBarrageContainer


- (void)dealloc{
    
    [self stop];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.barrages = [NSMutableArray arrayWithCapacity:0];
        self.barrageQueue = dispatch_queue_create(nil, nil);
        
        self.row1 = ({
            WTBarrageRowContainer* view = [[WTBarrageRowContainer alloc] init];
            [self addSubview:view];
            view;
        });
        
        self.row2 = ({
            WTBarrageRowContainer* view = [[WTBarrageRowContainer alloc] init];
            [self addSubview:view];
            view;
        });
        
        
        [self.row1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.and.top.mas_equalTo(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.row2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.mas_equalTo(0);
            make.top.mas_equalTo(self.row1.mas_bottom).offset(10);
            make.height.mas_equalTo(50);
        }];
        
  
        __weak __typeof(self)weakSelf = self;
        self.row1.rowContainerBlock = ^WTBarrageContent*() {
        
            WTBarrageContent* barrage = [weakSelf getBarrage];
            if(!barrage){
                return nil;
            }
            dispatch_barrier_sync(weakSelf.barrageQueue, ^{
                [weakSelf.barrages removeObject:barrage];
            });
            return barrage;
        };
        
        self.row2.rowContainerBlock = ^WTBarrageContent*() {
            
            WTBarrageContent* barrage = [weakSelf getBarrage];
            if(!barrage){
                return nil;
            }
            dispatch_barrier_sync(weakSelf.barrageQueue, ^{
                [weakSelf.barrages removeObject:barrage];
            });
            return barrage;
        };
        
        [self start];
    }
    return self;
}

- (void)insertBarrages:(NSArray*)barrages{

    dispatch_barrier_sync(self.barrageQueue, ^{
        [self.barrages addObjectsFromArray:barrages];
    }); 
}

- (WTBarrageContent *)getBarrage{
    
    if(self.barrages.count <= 0){
        return nil;
    }
    return [self.barrages firstObject];
}

- (void)start{
    
    [self.row1 start];
    [self.row2 start];
}

- (void)stop{
    [self.row1 stop];
    [self.row2 stop];
}
@end
