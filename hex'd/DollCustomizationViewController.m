//
//  DollCustomizationViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DollCustomizationViewController.h"
#import "DollDataManager.h"
#import "Doll.h"

@implementation DollCustomizationViewController

@synthesize specificDoll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
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
    [specificDoll release];
    
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

#pragma mark - Buttons

- (IBAction)selectHair:(UIButton *)button
{
    specificDoll.hair = [NSString stringWithFormat:@"hair%i", button.tag];
}

- (IBAction)selectShirt:(UIButton *)button
{
    specificDoll.shirt = [NSString stringWithFormat:@"shirt%i", button.tag];
}

- (IBAction)selectPants:(UIButton *)button
{
    specificDoll.pants = [NSString stringWithFormat:@"pants%i", button.tag];
}

- (IBAction)selectOther:(UIButton *)button
{
    specificDoll.other = [NSString stringWithFormat:@"other%i", button.tag];
}

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == 1) {
        [[DollDataManager sharedDollDataManager] saveDolls];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
