//
//  VSMainTableViewController.m
//  VSBlockStudy
//
//  Created by cooperLink on 16/1/13.
//  Copyright © 2016年 VS. All rights reserved.
//

#import "VSMainTableViewController.h"
#import "NSString+VSExtendedString.h"

NSString *const reuseIdentifier = @"reuseIdentifier";

@interface VSMainTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSDictionary *viewControllerNames;

@end

@implementation VSMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _dataSource = @[@"About Block",@"ARC --> Block",@"MRC --> Block",@"Block and Delegate"];
    _viewControllerNames = @{@"About Block" : @"VSBlockViewController",
                             @"ARC --> Block" : @"VSARCBlockViewController",
                             @"MRC --> Block" : @"VSMRCBlockViewController",
                             @"Block and Delegate" : @"VSBlockAndDelegateViewController"};
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = _dataSource[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = _viewControllerNames[_dataSource[indexPath.row]];
    if (vcName.isNotEmpty) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        vc.title = _dataSource[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = indexPath.row % 2 ? [UIColor greenColor] : [UIColor orangeColor];
}



@end
