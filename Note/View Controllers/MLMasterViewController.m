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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[MLNoteClient sharedClient] getIndexWhenSuccess:^(AFHTTPRequestOperation *operation, id responseObject){
        _notes = [responseObject objectFromJSONData];
        NSLog(@"[Success] %@", _notes);
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
    NSLog(@"%@", note);

    cell.textLabel.text = [note valueForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MLDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MLDetailViewController"];
    vc.note = [_notes objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
