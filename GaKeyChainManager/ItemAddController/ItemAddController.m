//
//  ItemAddController.m
//  GaKeyChainManager
//
//  Created by GikkiAres on 2020/4/4.
//  Copyright © 2020 TinyWind. All rights reserved.
//

#import "ItemAddController.h"


@interface ItemAddController ()

@property (weak, nonatomic) IBOutlet UITextField *tfValue;
@property (weak, nonatomic) IBOutlet UITextField *tfService;
@property (weak, nonatomic) IBOutlet UITextField *tfAccessGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (assign, nonatomic) BOOL isModify;


@end

@implementation ItemAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AddKeyChainItem";
    self.isModify = NO;
    if(self.item) {
        [self configItem:self.item];
        self.isModify = YES;
    }
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithTitle:@"Make Uuid" style:UIBarButtonItemStyleDone target:self action:@selector(onClickUuidBtn)];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)configItem:(GaKeyChainItem *)item {
    self.tfAccessGroup.text = item.accessGroup;
    self.tfService.text = item.service;
    self.tfValue.text = item.value;
    self.tfAccessGroup.enabled = NO;
    self.tfService.enabled = NO;
    self.title = @"KeyChainItemDetail";
    [self.btnFinish setTitle:@"修改" forState:UIControlStateNormal];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)onClickFinshBtn:(id)sender {
    if(self.isModify) {
        self.item.value = _tfValue.text.length>0?_tfValue.text:nil;
        BOOL ret = [self.item updateValue];
        if(ret) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        GaKeyChainItem * item = [GaKeyChainItem new];
        item.value = _tfValue.text.length>0?_tfValue.text:nil;
        item.service = _tfService.text.length>0?_tfService.text:nil;
        item.accessGroup = _tfAccessGroup.text.length>0?_tfAccessGroup.text:nil;
        BOOL ret = [item saveToKeyChain];
        if(ret) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)onClickUuidBtn {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    self.tfValue.text = uuid;
    self.tfService.text = @"Uuid";
}

@end
