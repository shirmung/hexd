//
//  DollsViewController.h
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DollsViewController : UIViewController <UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *dollsTableView;
    
    UIBarButtonItem *fixedSpaceBarButtonItem;
    UIBarButtonItem *editBarButtonItem;
}

@property (nonatomic, retain) IBOutlet UITableView *dollsTableView;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *fixedSpaceBarButtonItem;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editBarButtonItem;

@end