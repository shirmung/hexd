//
//  DollsViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DollsViewController.h"
#import "DollDataManager.h"
#import "Doll.h"
#import "AddDollViewController.h"
#import "DollInteractionViewController.h"

@implementation DollsViewController

@synthesize dollsTableView;
@synthesize fixedSpaceBarButtonItem, editBarButtonItem;

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
    [dollsTableView release];
    
    [fixedSpaceBarButtonItem release];
    [editBarButtonItem release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"My Voodoo Dolls";
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (![userDefaults objectForKey:@"hasUsed"]) {
        [userDefaults setObject:@"YES" forKey:@"hasUsed"];
        [userDefaults synchronize];
        
        Doll *newDoll = [[Doll alloc] init];
        newDoll.name = @"Jack";
        newDoll.gender = @"male";
        
        [[[DollDataManager sharedDollDataManager] dolls] addObject:newDoll];
        [[DollDataManager sharedDollDataManager] saveDolls];
    
        [newDoll release];
    }

    [[DollDataManager sharedDollDataManager] sort];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDollsData:) name:@"Update Dolls Data" object:nil];
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

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DollDataManager sharedDollDataManager] dolls] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Doll *specificDoll = [[[DollDataManager sharedDollDataManager] dolls] objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = specificDoll.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[[DollDataManager sharedDollDataManager] dolls] removeObjectAtIndex:[indexPath row]];
        [[DollDataManager sharedDollDataManager] saveDolls];
        [dollsTableView reloadData];
    } 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Doll *doll = [[[DollDataManager sharedDollDataManager] dolls] objectAtIndex:[indexPath row]];
    
    DollInteractionViewController *dollInteractionViewController = [[DollInteractionViewController alloc] init];
    dollInteractionViewController.specificDoll = doll;
    
    [self.navigationController pushViewController:dollInteractionViewController animated:YES];
    
    [dollInteractionViewController release];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDollsData:(NSNotification *)notification
{
    [[DollDataManager sharedDollDataManager] sort];
    [dollsTableView reloadData];
}

#pragma mark - UIButtons

- (IBAction)addDoll:(UIBarButtonItem *)barButtonItem
{
    AddDollViewController *addDollViewController = [[AddDollViewController alloc] init];
    [self.navigationController presentModalViewController:addDollViewController animated:YES];
    
    [addDollViewController release];
}

- (IBAction)toggleEditMode:(UIBarButtonItem *)barButtonItem
{
    if ([dollsTableView isEditing]) {
        [dollsTableView setEditing:FALSE animated:YES];
        
        self.editBarButtonItem.title = @"Edit";
        self.editBarButtonItem.style = UIBarButtonItemStyleBordered;
        
        self.fixedSpaceBarButtonItem.width = 217;
    } else {
        [dollsTableView setEditing:TRUE animated:YES];
        
        self.editBarButtonItem.title = @"Done";
        self.editBarButtonItem.style = UIBarButtonItemStyleDone;
        
        self.fixedSpaceBarButtonItem.width = 211;
    }
}

@end