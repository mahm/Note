//
//  MLMasterViewController.m
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import "MLMasterViewController.h"
#import "MLDetailViewController.h"

@interface MLMasterViewController () {
    NSMutableArray *_notes;
}
@end

@implementation MLMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //----------------------------------------------------
    // 新規登録ボタン
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd handler:^(id sender) {
        MLDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MLDetailViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //----------------------------------------------------
    // 表示時にサーバ上のデータを読み込む
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[MLNoteClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        _notes = [[NSMutableArray alloc] initWithArray:[responseObject objectFromJSONData]];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(int statusCode, NSString *errorString){
        // 認証されていない場合はアカウントの設定画面に飛ばす
        if (statusCode == 401) {
            [self.tabBarController setSelectedIndex:1];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *note = [_notes objectAtIndex:indexPath.row];
    cell.textLabel.text = [note valueForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MLDetailViewController"];
    vc.note = [_notes objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

    // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //----------------------------------------------------
        // サーバ上から削除できた場合に削除アニメーションを実行する
        [SVProgressHUD showWithStatus:@"Sending" maskType:SVProgressHUDMaskTypeBlack];
        NSDictionary *note = [_notes objectAtIndex:indexPath.row];
        [[MLNoteClient sharedClient] destroyNoteWithId:[[note valueForKey:@"id"] integerValue] success:^(AFHTTPRequestOperation *operation, id responseObject){
            [SVProgressHUD dismiss];
            [_notes removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil] withRowAnimation:YES];
            [SVProgressHUD showSuccessWithStatus:@"done!"];
        } failure:^(int statusCode, NSString *errorString){
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
}

@end
