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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self)
    {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
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
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    for (id button in self.view.subviews) 
    {
        if ([button isKindOfClass:[UIButton class]]) 
        {
            // highlight hair
            if ([[button currentTitle] isEqualToString:@"hair"]) 
            {
                if ([button tag] == [self hair]) 
                {
                    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hair%ibuttonselected.png", [button tag]]] forState:UIControlStateSelected];
                    [button setSelected:YES];
                }
            }
            
            // highlight shirt
            if ([[button currentTitle] isEqualToString:@"shirt"]) 
            {
                if ([button tag] == [self shirt]) 
                {
                    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shirt%ibuttonselected.png", [button tag]]] forState:UIControlStateSelected];
                    [button setSelected:YES];
                }
            }
            
            // highlight pants
            if ([[button currentTitle] isEqualToString:@"pants"]) 
            {
                if ([button tag] == [self pants]) 
                {
                    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pants%ibuttonselected.png", [button tag]]] forState:UIControlStateSelected];
                    [button setSelected:YES];
                }
            }
            
            // highlight other
            if ([[button currentTitle] isEqualToString:@"other"]) 
            {
                if ([button tag] == [self other]) 
                {
                    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"other%ibuttonselected.png", [button tag]]] forState:UIControlStateSelected];
                    [button setSelected:YES];
                }
            }
            
            if ([[button currentTitle] isEqualToString:@"background"]) 
            {
                if ([button tag] == [self background]) [button setSelected:YES];
            }
        }
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
    // if the button was selected, then unselect it
    if ([button isSelected]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hair%ibutton.png", button.tag]] forState:UIControlStateNormal];
        
        // unselect the hair
        specificDoll.hair = @"";
        [button setSelected:NO];
    } else { // otherwise select it, unselect previous hair
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"hair%ibuttonselected.png", button.tag]] forState:UIControlStateSelected];
        
        // deselect other hair buttons
        for (id butt in self.view.subviews) 
        {
            if ([butt isKindOfClass:[UIButton class]] && [[butt currentTitle] isEqualToString:@"hair"]) 
            {
                [butt setSelected:NO];
            }
        }
        
        // select the hair
        specificDoll.hair = [NSString stringWithFormat:@"hair%i", button.tag];
        [button setSelected:YES];
    }
}

- (IBAction)selectShirt:(UIButton *)button
{
    // if the button was selected, then unselect it
    if ([button isSelected]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shirt%ibutton.png", button.tag]] forState:UIControlStateNormal];
        
        // unselect the shirt
        specificDoll.shirt = @"";
        [button setSelected:NO];
    } else { // otherwise select it, unselect previous shirt
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shirt%ibuttonselected.png", button.tag]] forState:UIControlStateSelected];
        
        // deselect other shirt buttons
        for (id butt in self.view.subviews)
        {
            if ([butt isKindOfClass:[UIButton class]] && ([[butt currentTitle] isEqualToString:@"shirt"] || [[butt currentTitle] isEqualToString:@"other"])) 
            {
                [butt setSelected:NO];
            }
        }
        
        // select the shirt
        specificDoll.shirt = [NSString stringWithFormat:@"shirt%i", button.tag];
        specificDoll.other = @"";
        
        [button setSelected:YES];
    }
}

- (IBAction)selectPants:(UIButton *)button
{
    // if the button was selected, then unselect it
    if ([button isSelected]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pants%ibutton.png", button.tag]] forState:UIControlStateNormal];
        
        // unselect the pants
        specificDoll.pants = @"";
        [button setSelected:NO];
    } else { // otherwise select it, unselect previous pants
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pants%ibuttonselected.png", button.tag]] forState:UIControlStateSelected];
        
        // deselect other pants buttons
        for (id butt in self.view.subviews) 
        {
            if ([butt isKindOfClass:[UIButton class]] && ([[butt currentTitle] isEqualToString:@"pants"] || [[butt currentTitle] isEqualToString:@"other"]))  
            {
                [butt setSelected:NO];
            }
        }
        
        // select the pants
        specificDoll.pants = [NSString stringWithFormat:@"pants%i", button.tag];
        specificDoll.other = @"";
        
        [button setSelected:YES];
    }
}

- (IBAction)selectOther:(UIButton *)button
{
    // if the button was selected, then unselect it
    if ([button isSelected]) {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"other%ibutton.png", button.tag]] forState:UIControlStateNormal];
        
        // unselect the other
        specificDoll.other = @"";
        [button setSelected:NO];
    } else { // otherwise select it, unselect previous other
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"other%ibuttonselected.png", button.tag]] forState:UIControlStateSelected];
        
        // deselect other other buttons
        for (id butt in self.view.subviews) 
        {
            if ([butt isKindOfClass:[UIButton class]] && ([[butt currentTitle] isEqualToString:@"other"] || [[butt currentTitle] isEqualToString:@"shirt"] || [[butt currentTitle] isEqualToString:@"pants"])) {
                [butt setSelected:NO];
            }
        }
        
        // select the other
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
        for (id button in self.view.subviews) 
        {
            if ([button isKindOfClass:[UIButton class]] && [[button currentTitle] isEqualToString:@"background"]) 
            {
                [button setSelected:NO];
            }
        }
        
        specificDoll.background = [NSString stringWithFormat:@"background%i", button.tag];
        [button setSelected:YES];
    }
}

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem
{
    if (barButtonItem.tag == 1) 
    {
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
    if (![specificDoll.hair isEqualToString:@""]) 
    {
        return [[specificDoll.hair substringFromIndex:4] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's shirt
- (int)shirt
{
    if (![specificDoll.shirt isEqualToString:@""]) 
    {
        return [[specificDoll.shirt substringFromIndex:5] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's pants
- (int)pants
{
    if (![specificDoll.pants isEqualToString:@""]) 
    {
        return [[specificDoll.pants substringFromIndex:5] intValue];
    }
    
    return 0;
}

// helper method to get specific doll's other
- (int)other
{
    if (![specificDoll.other isEqualToString:@""]) 
    {
        return [[specificDoll.other substringFromIndex:5] intValue];
    }
    
    return 0;
}

- (int)background
{
    if (![specificDoll.background isEqualToString:@""]) 
    {
        return [[specificDoll.background substringFromIndex:10] intValue];
    }
    
    return 0;
}

@end
