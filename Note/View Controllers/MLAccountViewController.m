//
//  MLAccountViewController.m
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import "MLAccountViewController.h"

@interface MLAccountViewController ()

@end

@implementation MLAccountViewController

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

    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave handler:^(id sender){
        NSString *email = self.emailField.text;
        NSString *password = self.passwordField.text;
        // FIXME: passwordはKeychainに入れないと審査時にリジェクトされます。
        [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
        [[MLNoteClient sharedClient] setEmail:email password:password];
        [SVProgressHUD showSuccessWithStatus:@"Saved"];
        [self.emailField resignFirstResponder];
        [self.passwordField resignFirstResponder];
    }];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.emailField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"email"];
    self.passwordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEmailField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
}
@end
