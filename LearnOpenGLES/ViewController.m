//
//  ViewController.m
//  LearnOpenGLES
//
//  Created by 刘微 on 2017/5/9.
//  Copyright © 2017年 waynezxcv. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>


#define NUMBER 1

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,strong) NSMutableArray* dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (NSInteger i = 0; i < NUMBER; i ++) {
        NSString* className = [NSString stringWithFormat:@"LearnOpenGLESViewController_%ld",(long)i + 1];
        [self.dataSource addObject:className];
    }
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Class cls = objc_getClass([[self.dataSource objectAtIndex:indexPath.row] UTF8String]);
    id object = [[cls alloc] init];
    if ([object isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:object animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdeintifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdeintifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdeintifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}
@end
