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
@synthesize tempHair, tempShirt, tempPants, tempOther, tempBackground;
@synthesize hairScrollView, shirtScrollView, pantsScrollView, otherScrollView, backgroundScrollView;

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
    [specificDoll release];
    
    [tempHair release];
    [tempShirt release];
    [tempPants release];
    [tempOther release];
    [tempBackground release];
    
    [hairScrollView release];
    [shirtScrollView release];
    [pantsScrollView release];
    [otherScrollView release];
    [backgroundScrollView release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [hairScrollView setScrollEnabled:YES];
    [hairScrollView setContentSize:CGSizeMake(560, 70)];
    
    [shirtScrollView setScrollEnabled:YES];
    [shirtScrollView setContentSize:CGSizeMake(833, 70)];

    [pantsScrollView setScrollEnabled:YES];
    [pantsScrollView setContentSize:CGSizeMake(560, 70)];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    self.tempHair = specificDoll.hair;
    self.tempShirt = specificDoll.shirt;
    self.tempPants = specificDoll.pants;
    self.tempOther = specificDoll.other;
    self.tempBackground = specificDoll.background;
    
    // highlight the doll's selected buttons
    for (id button in hairScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && [button tag] == [self hair]) [button setSelected:YES];
    }
    
    for (id button in shirtScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && [button tag] == [self shirt]) [button setSelected:YES];
    }
            
    for (id button in pantsScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && [button tag] == [self pants]) [button setSelected:YES];
    }
          
    for (id button in otherScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && [button tag] == [self other]) [button setSelected:YES];
    }

    for (id button in backgroundScrollView.subviews) {
        if ([button isKindOfClass:[UIButton class]] && [button tag] == [self background]) [button setSelected:YES];
    }
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
    if ([button isSelected]) {
        specificDoll.hair = @"";
        
        [button setSelected:NO];
    } else {
        for (id button in hairScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }

        specificDoll.hair = [NSString stringWithFormat:@"hair%i", button.tag];

        [button setSelected:YES];
    }
}

- (IBAction)selectShirt:(UIButton *)button
{
    if ([button isSelected]) {
        specificDoll.shirt = @"";
        
        [button setSelected:NO];
    } else {
        for (id button in shirtScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        for (id button in otherScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        specificDoll.shirt = [NSString stringWithFormat:@"shirt%i", button.tag];
        specificDoll.other = @"";
        
        [button setSelected:YES];
    }
}

- (IBAction)selectPants:(UIButton *)button
{
    if ([button isSelected]) {
        specificDoll.pants = @"";
        
        [button setSelected:NO];
    } else {
        for (id button in pantsScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        for (id button in otherScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }

        specificDoll.pants = [NSString stringWithFormat:@"pants%i", button.tag];
        specificDoll.other = @"";
        
        [button setSelected:YES];
    }
}

- (IBAction)selectOther:(UIButton *)button
{
    if ([button isSelected]) {
        specificDoll.other = @"";
        
        [button setSelected:NO];
    } else {
        for (id button in otherScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        for (id button in shirtScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        for (id button in pantsScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        specificDoll.other = [NSString stringWithFormat:@"other%i", button.tag];
        specificDoll.shirt = @"";
        specificDoll.pants = @"";
        
        [button setSelected:YES];
    }
}

- (IBAction)selectBackground:(UIButton *)button
{
    if ([button isSelected]) {
        specificDoll.background = @"";
        
        [button setSelected:NO];
    } else {
        for (id button in backgroundScrollView.subviews) {
            if ([button isKindOfClass:[UIButton class]]) [button setSelected:NO];
        }
        
        specificDoll.background = [NSString stringWithFormat:@"background%i", button.tag];
        
        [button setSelected:YES];
    }
}

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == 1) {
        [[DollDataManager sharedDollDataManager] saveDolls];
    } else {
        specificDoll.hair = self.tempHair;
        specificDoll.shirt = self.tempShirt;
        specificDoll.pants = self.tempPants;
        specificDoll.other = self.tempOther;
        specificDoll.background = self.tempBackground;
        
        [[DollDataManager sharedDollDataManager] saveDolls];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Helper methods
// helper method to get specific doll's hair
- (int)hair
{
    if (![specificDoll.hair isEqualToString:@""]) {
        return [[specificDoll.hair substringFromIndex:4] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's shirt
- (int)shirt
{
    if (![specificDoll.shirt isEqualToString:@""]) {
        return [[specificDoll.shirt substringFromIndex:5] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's pants
- (int)pants
{
    if (![specificDoll.pants isEqualToString:@""]) {
        return [[specificDoll.pants substringFromIndex:5] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's other
- (int)other
{
    if (![specificDoll.other isEqualToString:@""]) {
        return [[specificDoll.other substringFromIndex:5] intValue];
    }
    
    return 0;
}

- (int)background
{
    if (![specificDoll.background isEqualToString:@""]) {
        return [[specificDoll.background substringFromIndex:10] intValue];
    }
    
    return 0;
}

@end
