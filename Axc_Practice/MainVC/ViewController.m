//
//  ViewController.m
//  Axc_Practice
//
//  Created by AxcLogo on 2018/10/22.
//  Copyright © 2018 AxcLogo. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"

@interface ViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self settingArrays];
}
- (void)settingArrays{
    [self.dataListArray addObject:[MianModel VCName:@"HollowOutVC" title:@"镂空二维码练习" disTitle:@"-"]];
    [self.dataListArray addObject:[MianModel VCName:@"CircularSpectrumVC" title:@"圆形频谱练习" disTitle:@"-"]];
    
    [self.tableView reloadData];
}
- (void)createUI{
    self.title = @"Axc测试练习工程";
    [self AxcBase_settingTableType:UITableViewStylePlain
                           nibName:@"MainTableViewCell"
                            cellID:@"axc"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MianModel *model = self.dataListArray[indexPath.row];
    [self AxcTool_pushVCName:model.VCName];
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"axc"];
    cell.model = self.dataListArray[indexPath.row];
    return cell;
}


@end
