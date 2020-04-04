//
//  HomeViewController.m
//  GaCameraViewProject
//
//  Created by GikkiAres on 2020/3/28.
//  Copyright © 2020 GikkiAres. All rights reserved.
//

#import "HomeViewController.h"
#import <Security/Security.h>
#import "GaKeyChainUtility.h"
#import "ItemAddController.h"



#define kUuid @"UuidKey"
#define kAccessGroup @"tinywind"


@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray <GaKeyChainItem *> * arrKeyChainItem;



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSLog(@"HomeViewController viewDidLoad.");
    [self configNavigationBar];
    self.title = @"GaKeyChainManager";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryAllKeyChainItem];
}

- (void)configNavigationBar{
    
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickAddBtn)];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)queryAllKeyChainItem {
    self.arrKeyChainItem = [GaKeyChainUtility queryAllKeyChainItem];
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrKeyChainItem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell =
    [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    GaKeyChainItem * item  = self.arrKeyChainItem[indexPath.row];
    cell.textLabel.text = item.service;
    cell.detailTextLabel.text = item.value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GaKeyChainItem * item = self.arrKeyChainItem[indexPath.row];
    ItemAddController * vc = [ItemAddController new];
    NSLog(@"%@",[item toString]);
    vc.item = item;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        GaKeyChainItem * item = self.arrKeyChainItem[indexPath.row];
        BOOL ret = [item removeFormKeyChain];
        if(ret) {
            [self queryAllKeyChainItem];
        }
    }
}

#pragma mark 4 Event
-(void)onClickAddBtn {
    ItemAddController *vc = [ItemAddController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
