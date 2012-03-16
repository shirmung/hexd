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
    
//    if ([button isSelected]) {
//		//[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@button.png", specificDoll.hair]] forState:UIControlStateNormal];
//		[button setSelected:NO];
//	} else {
//        //[button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@buttonselected.png", specificDoll.hair]] forState:UIControlStateSelected];
//		[button setSelected:YES];
//		
//		for (UIView *view in self.view.subviews) 
//        {
//			if ([view isKindOfClass:[UIButton class]]) 
//            {
//				if([view.image hasPrefix:@"shirt"] && ![view isEqual: sender]) [view setSelected:NO];
//			}
//		}
//	}
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

- (IBAction)selectBackground:(UIButton *)button
{
    specificDoll.background = [NSString stringWithFormat:@"background%i", button.tag];
}

- (void)updateSelections
{
    
}

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == 1) 
    {
        [[DollDataManager sharedDollDataManager] saveDolls];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
