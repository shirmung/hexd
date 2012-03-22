//
//  AddDollViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/7/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "AddDollViewController.h"
#import "DollDataManager.h"
#import "Doll.h"

@implementation AddDollViewController

@synthesize nameTextField, genderSegmentedControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [nameTextField release];
    [genderSegmentedControl release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Text field

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    [textField resignFirstResponder];
    
    return NO;
}

#pragma mark - Buttons

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == 1) {
        Doll *newDoll = [[[Doll alloc] init] autorelease];
        newDoll.name = nameTextField.text;
        
        if (genderSegmentedControl.selectedSegmentIndex == 0) newDoll.gender = @"male";
        else if (genderSegmentedControl.selectedSegmentIndex == 1) newDoll.gender = @"female";
        else if (genderSegmentedControl.selectedSegmentIndex == 2) newDoll.gender = @"othergender";
        
        [[[DollDataManager sharedDollDataManager] dolls] addObject:newDoll];
        [[DollDataManager sharedDollDataManager] saveDolls];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Update Dolls Data" object:self];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
