//
//  MLDetailViewController.m
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import "MLDetailViewController.h"

@interface MLDetailViewController ()
@end

@implementation MLDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.note) {
        [self setupForEditMode];
    } else {
        [self setupForCreateMode];
    }
    
}

- (void) setupForEditMode
{
    self.titleField.text = [self.note valueForKey:@"title"];
    self.bodyView.text = [self.note valueForKey:@"body"];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave handler:^(id sender) {
        [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
        [[MLNoteClient sharedClient] putNoteWithId:[[self.note valueForKey:@"id"] integerValue] title:self.titleField.text body:self.bodyView.text success:^(AFHTTPRequestOperation *operation, id responseObject){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"done!"];
        } failure:^(int statusCode, NSString *errorString){
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];

    }];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void) setupForCreateMode
{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave handler:^(id sender) {
        [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
        [[MLNoteClient sharedClient] createNoteWithTitle:self.titleField.text body:self.bodyView.text success:^(AFHTTPRequestOperation *operation, id responseObject){
            [self.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"done!"];
        } failure:^(int statusCode, NSString *errorString){
            [SVProgressHUD dismiss];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleField:nil];
    [self setBodyView:nil];
    [super viewDidUnload];
}

@end
