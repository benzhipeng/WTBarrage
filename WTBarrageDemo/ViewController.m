//
//  ViewController.m
//  BarrageDemo
//
//  Created by ben on 2017/1/5.
//  Copyright © 2017年 ben. All rights reserved.
//

#import "ViewController.h"
#import "WTBarrageContainer.h"
#import "Masonry.h"
#import "WTBarrageItem.h"
@interface ViewController (){
    NSInteger index;
}
@property (strong, nonatomic) WTBarrageContainer *barrageContainer;
@property (strong, nonatomic) NSTimer*  timer;
@property (strong, nonatomic) NSMutableArray*     barrages;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.barrages = [NSMutableArray arrayWithCapacity:0];
    
    self.barrageContainer = ({
       
        WTBarrageContainer* view = [[WTBarrageContainer alloc] init];
        [self.view addSubview:view];
        view;
    });
    
    [self.barrageContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.mas_equalTo(0);
        make.height.mas_equalTo(110);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
 

}

- (IBAction)sendBarrage:(id)sender {
    
    WTBarrageContent* barrage = [[WTBarrageContent alloc] init];
    barrage.avatar = @"http://h.hiphotos.bdimg.com/album/h%3D370%3Bq%3D90/sign=95b22d5bbb12c8fcabf3f0cacc38e378/6159252dd42a2834d3a2697059b5c9ea15cebf41.jpg";
    barrage.avatarPlaceHolder = nil;
    barrage.content = @"离岸人民币隔夜存款利率飙升至纪录高点80%";
    [self.barrageContainer insertBarrages:@[barrage]];
//  
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
 
//    [self.barrageContainer insertCustomFormat:@{@"text":@"frank"}];

}

- (void)refresh{

    
//    NSString* barrage = @"离岸人民币隔夜存款利率飙升至纪录高点80%";
//    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
//    for(NSInteger i = 0;i < 10; i++){
//        NSString* tmp = [barrage substringToIndex:arc4random() % (barrage.length)];
//        [array addObject:tmp];
//    }
   
    
//    UIView* view =  [self.barrageContainer.subviews lastObject];
//    if(view && [view isKindOfClass:[WTBarrageItem class]]){
//        
//        
//
//    }else {
//    }
    
    
//    index++;
//    UIView* view = [self.barrageContainer viewWithTag:index - 1];
//    
//
//
//    if([view isKindOfClass:[WTBarrageItem class]]){
//
//
//        NSLog(@"%f",x);
//    }
//    item.tag = index;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
