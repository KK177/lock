//
//  unLockView.m
//  unLock
//
//  Created by MacBook pro on 2021/2/17.
//

#import "unLockView.h"

@interface unLockView()

@property (nonatomic, strong)NSMutableArray *selectBtnArray;

@property (nonatomic, assign)CGPoint currentPoint;

@end

@implementation unLockView

- (NSMutableArray *)selectBtnArray {
    if (!_selectBtnArray) {
        _selectBtnArray = [NSMutableArray array];
    }
    return _selectBtnArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(60, 250, 300, 300);
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return  self;
}

- (void)setUI {
    for (int i=0; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.userInteractionEnabled = NO;
        [btn setImage:[UIImage imageNamed:@"锁"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"解锁"] forState:UIControlStateSelected];
        int btnWH = 80;
        //列数
        int colums = 3;
        //行数
        int rows = 3;
        //间隙
        int margin = (300 - 3 * btnWH) / 4;
        btn.frame = CGRectMake(margin+(margin+btnWH)*(i%colums),margin+(margin+btnWH)*(i/rows), btnWH, btnWH);
        btn.layer.cornerRadius = 40;
        [self addSubview:btn];
    }
}

//返回手指点的位置的point
- (CGPoint)getCurrentPoint:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    return [touch locationInView:self];
}
//判断point是否在button上
- (UIButton *)btnContainsPoint:(CGPoint)point {
    for (UIButton *btn  in self.subviews) {
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIButton *btn = [self btnContainsPoint:[self getCurrentPoint:touches]];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.currentPoint = [self getCurrentPoint:touches];
    UIButton *btn = [self btnContainsPoint:self.currentPoint];
    if (btn && btn.selected == NO) {
        btn.selected = YES;
        [self.selectBtnArray addObject:btn];
    }
    
    //重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //取消选中的按钮
    NSMutableString *str = [NSMutableString string];
    for (UIButton *btn in self.selectBtnArray) {
        btn.selected = NO;
        [str appendFormat:@"%ld",btn.tag];
    }
    //清空路径
    [self.selectBtnArray removeAllObjects];
    [self setNeedsDisplay];
    //选中按钮的顺序是否匹配密码
    if ([str isEqual:@"0124678"]) {
        NSLog(@"密码正确");
    }else {
        NSLog(@"密码错误");
    }
}
- (void)drawRect:(CGRect)rect {
    if (self.selectBtnArray.count) {
        //创建路径
        UIBezierPath *path = [UIBezierPath bezierPath];
        //根据选中的btn绘制路径
        for (int i=0; i<self.selectBtnArray.count; i++) {
            UIButton *btn = self.selectBtnArray[i];
            if (i == 0) {
                //设置路径起点
                [path moveToPoint:btn.center];
            }else {
                //连线
                [path addLineToPoint:btn.center];
            }
        }
        //再添加一根线到最后一个按钮
        [path addLineToPoint:self.currentPoint];
        //设置绘制状态
        [path setLineWidth:8];
        [[UIColor lightGrayColor] set];
        [path setLineJoinStyle:kCGLineJoinRound];
        //绘制路径
        [path stroke];
    }
}
@end
