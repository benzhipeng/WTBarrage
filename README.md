最近在做直播这块方面的内容，然后有个弹幕的需求需要我们实现一下。一开始为了图方便就直接使用了一个第三方的库BarrageRenderer，star数目也比较多，用起来也挺方便，唯一的不好的地方就是定制弹幕的灵活性不是很强，但是用在项目里已经足够了。大概的效果如下：![](https://ww1.sinaimg.cn/large/006tKfTcgy1fckaismzx3j30d6046dg9.jpg)

但是这种效果有个不好的地方，就是弹幕之间有遮挡，产品说这样不行，需要改进。两种方案，第一是动源码，第二就是自己写一个。尝试了第一种方案之后发现可执行性不是很高，而且周期比较长。为了后面的可扩展性就索性自己写一个吧。
弹幕的主要构成如图:
![](https://ww4.sinaimg.cn/large/006tKfTcgy1fckairvffdj30h405sq3g.jpg)

弹幕由一个大的container包着，每一行都是一个rowContainer,大的container的高度由row数目来决定，弹幕item是在rowContainer里面显示的。使用的时候只需要初始化WTBarrageContainer就行了。

## WTBarrageContainer

```objective-c
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.row1 = ({
            WTBarrageRowContainer* view = [[WTBarrageRowContainer alloc] init];
            [self addSubview:view];
            view;
        });

        [self.row1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.and.trailing.and.top.mas_equalTo(0);
            make.height.mas_equalTo(44);
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
    }
    return self;
}
```

 初始化方法中，创建WTBarrageRowContainer的实例，并将其放到WTBarrageContainer视图层级中。

WTBarrageRowContainer的属性rowContainerBlock返回一个barrage内容用于填充弹幕。

```objective-c
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
```

insertBarrages方法用于外部塞入弹幕。这边在往数组里面插入数据的时候，新起了一个同步线程，该任务包裹在串行队列里面，主要是涉及到数组的插入和删除，这样就能保证数组的安全性。

## WTBarrageRowContainer

该类主要提供了两个方法

```objective-c
- (void)start{
  	......
}

- (void)stop{
	.....
}
```

分别是控制弹幕的开始显示，和结束显示。start方法中初始化了一个定时器，用于定时从数组中获取弹幕，部分代码如下:

```objective-c
- (void)startTimer{

    if(!self.barrageTimer){
        self.barrageTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.barrageTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)refresh{
    
    WTBarrageItem* lastItem = [self.barrages lastObject];
    if(lastItem){ //代码片段
	    //========================================
        CGPoint pt = lastItem.layer.presentationLayer.position;
        CGSize size = lastItem.layer.presentationLayer.bounds.size;
        CGFloat x = pt.x + size.width / 2 + 40;
        if(x > [UIScreen mainScreen].bounds.size.width){
            return;
        }
        //========================================
        [self loadBarrage];
    }else {
        [self loadBarrage];
    }
}
```

这边主要是定时器定时获取弹幕的这个方法 refresh ,里面有一段代码(已经标注)。这边就是保证弹幕之间不会重叠的代码了。主要是思路是从数组中获取到最后一个弹幕，然后获取到这个弹幕的位置，判断是否去取下一个弹幕。

## WTBarrageItem

这个类就是用于初始化弹幕的实例，里面可以进行可定制化的布局，部分实现方法如下:

```objective-c
+ (instancetype)barrageItemWithContent:(WTBarrageContent*)content{

    WTBarrageItem* item = [[WTBarrageItem alloc] init];
    CGSize size =  [item systemLayoutSizeFittingSize:CGSizeMake(CGFLOAT_MAX, 44)]; //弹幕的子视图用autolayout进行布局，就可以使用该方法获取到整个视图的实际宽度。
    item.frame = CGRectMake(s_w, 0, size.width, 44);
    return item;
}
```

接下来就是要让弹幕移动了，实现代码如下:

```objective-c
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
  	//============需要解释的代码============
    CGFloat w = self.frame.size.width + [UIScreen mainScreen].bounds.size.width;
    [animation setDuration: (CGFloat)(w / 100)]; 
    //============需要解释的代码============
    [self.layer addAnimation:animation forKey:@"kAnimation_BarrageScene"];
}
```

上面标注的地方，当时想了很久，如果设置成定值的话，由于每个弹幕的宽度不等，移动时间定的话，那么移动的速度肯定就会不同，所以就会导致还会有弹幕之间发生重叠的情况发生。所以这边是肯定不可以设置成定值的。

弹幕之间不同的地方就是宽度不等，如果给一个基准，比如100，弹幕的移动距离除以100，所获得的时间就是不一样的了，然后每个弹幕的速率就会不一样，避免了重叠的情况发生。接下来就是怎么管理这些弹幕的问题了。

弹幕移动动画结束的时候，就说明该弹幕已经不需要显示了，那么就需要从视图上移除该弹幕。CABasicAnimation动画有个代理方法，如下:

```objective-c
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{   
    if(flag){
        if(self.finishedBlock){
            self.finishedBlock(self);
        }
    }
}
```

动画结束时调用相应的代理方法，然后去实现视图的移除，部分代码如下:

```objective-c
WTBarrageItem* item = [WTBarrageItem barrageItemWithContent:barrageText];
[item animate:^(WTBarrageItem *_item) {
    [weakSelf.barrages removeObject:_item];
    [_item removeFromSuperview];
}];
```

最后附上demo地址:[https://github.com/benzhipeng/WTBarrage.git]()

