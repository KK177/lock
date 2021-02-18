//
//  ViewController.m
//  unLock
//
//  Created by MacBook pro on 2021/2/17.
//

#import "ViewController.h"
#import "unLockView.h"

@interface ViewController ()

@property (nonatomic, strong) unLockView *lockView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

- (void)setUI {
    self.lockView = [[unLockView alloc] init];
    [self.view addSubview:self.lockView];
}

@end
