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
    
    self.titleField.text = [self.note valueForKey:@"title"];
    self.bodyView.text = [self.note valueForKey:@"body"];
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
