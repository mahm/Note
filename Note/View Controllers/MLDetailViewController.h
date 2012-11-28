//
//  MLDetailViewController.h
//  Note
//
//  Created by mah_lab on 2012/11/28.
//  Copyright (c) 2012年 mah-lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDetailViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *note;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *bodyView;

@end
