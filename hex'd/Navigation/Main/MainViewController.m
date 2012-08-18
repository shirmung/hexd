//
//  MainViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "MainViewController.h"
#import "DollsViewController.h"
#import "HelpViewController.h"
#import "CreditsViewController.h"

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"darkestchild" ofType:@"mp3"]] error:NULL];
        [backgroundMusic setNumberOfLoops:-1];
        [backgroundMusic prepareToPlay];
        [backgroundMusic play];
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
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated 
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

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
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIButtons

-(IBAction)toggleMusic:(UIButton *)button 
{
	if ([backgroundMusic isPlaying]) {
		[button setSelected:YES];
		[backgroundMusic stop];
	} else {
		[button setSelected:NO];
		[backgroundMusic play];
	}
}

- (IBAction)toAnotherView:(UIButton *)button
{
    if (button.tag == 1) {
        DollsViewController *dollsViewController = [[DollsViewController alloc] init];
        [[self navigationController] pushViewController:dollsViewController animated:YES];
        
        [dollsViewController release];
    } else if (button.tag == 2) {
        HelpViewController *helpViewController = [[HelpViewController alloc] init];
        [[self navigationController] pushViewController:helpViewController animated:YES];
        
        [helpViewController release];
    } else if (button.tag == 3) {
        CreditsViewController *creditsViewController = [[CreditsViewController alloc] init];
        [[self navigationController] pushViewController:creditsViewController animated:YES];
        
        [creditsViewController release];
    }
}

@end
