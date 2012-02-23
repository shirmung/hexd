//
//  AddDollViewController.h
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/7/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddDollViewController : UIViewController
{    
    UITextField *nameTextField;
    UISegmentedControl *genderSegmentedControl;
}

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *genderSegmentedControl;

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem;

@end