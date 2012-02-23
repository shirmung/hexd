//
//  DollInteractionViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "DollInteractionViewController.h"
#import "DollDataManager.h"
#import "Doll.h"
#import "DollCustomizationViewController.h"

@implementation DollInteractionViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *view in self.view.subviews) 
    {
        if (![view isKindOfClass:[UIButton class]]) [view removeFromSuperview];
    }
    
    genderLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.gender]]];
    [self.view addSubview:genderLayer];
    
    hairLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.hair]]];
    [self.view addSubview:hairLayer];
    
    shirtLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.shirt]]];
    [self.view addSubview:shirtLayer];
    
    pantsLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.pants]]];
    [self.view addSubview:pantsLayer];
    
    otherLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.other]]];
    [self.view addSubview:otherLayer];
    
    fireBurnsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.fireBurnsImageData]];
    fireBurnsLayer.frame = self.view.frame;
    [self.view addSubview:fireBurnsLayer];
    
    lightningBurnsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.lightningBurnsImageData]];
    lightningBurnsLayer.frame = self.view.frame;
    [self.view addSubview:lightningBurnsLayer];
    
    foodLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.foodImageData]];
	foodLayer.frame = self.view.frame;
    [self.view addSubview:foodLayer];
    
    pinsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.pinsImageData]];
	pinsLayer.frame = self.view.frame;
    [self.view addSubview:pinsLayer];
    
    drawingLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.drawingImageData]];
	drawingLayer.frame = self.view.frame;
    [self.view addSubview:drawingLayer];
    
    fireLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.fireImageData]];
	fireLayer.frame = self.view.frame;
    [self.view addSubview:fireLayer];
    
    lightningLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.lightningImageData]];
	lightningLayer.frame = self.view.frame;
    [self.view addSubview:lightningLayer];
}

- (BOOL)canBecomeFirstResponder 
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
    
	[self becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = specificDoll.name;
    
    UIBarButtonItem *customizationButton = [[UIBarButtonItem alloc] initWithTitle:@"Customize" 
                                                                            style:UIBarButtonItemStyleBordered 
                                                                           target:self
                                                                            action:@selector(toCustomizationView:)];
    self.navigationItem.rightBarButtonItem = customizationButton;
    
    [customizationButton release];
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

#pragma mark - Touch/movement methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = [touches anyObject];
    firstPoint = [touch locationInView:self.view];
    
	CGMutablePathRef bodyPath = CGPathCreateMutable();
    
	CGPathMoveToPoint(bodyPath, NULL, 199, 25);
	CGPathAddLineToPoint(bodyPath, NULL, 148, 37);
	CGPathAddLineToPoint(bodyPath, NULL, 115, 82);
	CGPathAddLineToPoint(bodyPath, NULL, 112, 123);
    CGPathAddLineToPoint(bodyPath, NULL, 112, 145);
    CGPathAddLineToPoint(bodyPath, NULL, 132, 163);
    CGPathAddLineToPoint(bodyPath, NULL, 187, 192);
    CGPathAddLineToPoint(bodyPath, NULL, 108, 248);
    CGPathAddLineToPoint(bodyPath, NULL, 168, 228);
    CGPathAddLineToPoint(bodyPath, NULL, 158, 293);
    CGPathAddLineToPoint(bodyPath, NULL, 159, 397);
    CGPathAddLineToPoint(bodyPath, NULL, 182, 300);
    CGPathAddLineToPoint(bodyPath, NULL, 208, 302);
    CGPathAddLineToPoint(bodyPath, NULL, 231, 398);
    CGPathAddLineToPoint(bodyPath, NULL, 234, 285);
    CGPathAddLineToPoint(bodyPath, NULL, 218, 224);
    CGPathAddLineToPoint(bodyPath, NULL, 281, 244);
    CGPathAddLineToPoint(bodyPath, NULL, 201, 189);
    CGPathAddLineToPoint(bodyPath, NULL, 254, 170);
    CGPathAddLineToPoint(bodyPath, NULL, 277, 157);
    CGPathAddLineToPoint(bodyPath, NULL, 277, 125);
    CGPathAddLineToPoint(bodyPath, NULL, 275, 74);
    CGPathAddLineToPoint(bodyPath, NULL, 249, 37);
	CGPathCloseSubpath(bodyPath);
    
	bodyHit = CGPathContainsPoint(bodyPath, NULL, firstPoint, NO);
	
    CGPathRelease(bodyPath);
    
    if (bodyHit)
    {
        [self bodyAnimation];
        
        bodyHit = NO;
    }
    
    if (pinButtonPressed) {
		UIImage *image = [UIImage imageNamed:@"pin.png"];
		
		UIGraphicsBeginImageContext(self.view.frame.size);
		[pinsLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[image drawInRect:CGRectMake(firstPoint.x - 7, firstPoint.y - 45, 40.0f, 60.0f)];
		pinsLayer.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	} else if (fireButtonPressed) {
        [self fireAnimation];
        
        [NSTimer scheduledTimerWithTimeInterval:0.2
                                         target:self
                                       selector:@selector(addBurn)
                                       userInfo:nil
                                        repeats:NO];
    } else if (lightningButtonPressed) {
		[NSTimer scheduledTimerWithTimeInterval:0.3
										 target:self 
									   selector:@selector(vibrate) 
									   userInfo:nil 
										repeats:NO];
		
        [self lightningAnimation];
		
		[NSTimer scheduledTimerWithTimeInterval:0.4
										 target:self
									   selector:@selector(addBurn)
									   userInfo:nil
										repeats:NO];
    } else if (foodButtonPressed) {
        NSString *file = @"";
        if (tomatoButtonPressed) file= @"tomato";
        else if (eggButtonPressed) file = @"egg";
            
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", file]];
        
		UIGraphicsBeginImageContext(self.view.frame.size);
		[foodLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[image drawInRect:CGRectMake(firstPoint.x - 20, firstPoint.y - 22, 40.0f, 45.0f)];
		foodLayer.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    } else if (drawingButtonPressed) {
        fingerSwiped = NO;
		
		lastPoint = firstPoint;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (drawingButtonPressed) 
    {
		fingerSwiped = YES;
		
		UITouch *touch = [touches anyObject];	
        firstPoint = [touch locationInView:self.view];
		
		UIGraphicsBeginImageContext(self.view.frame.size);
		[drawingLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
		
        if (eraserPressed) {
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 12);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        } else {
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3);
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), howMuchRed, howMuchGreen, howMuchBlue, 1.0);
        }
		
		CGContextBeginPath(UIGraphicsGetCurrentContext());
		CGContextMoveToPoint(UIGraphicsGetCurrentContext(),lastPoint.x, lastPoint.y);
		CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), firstPoint.x, firstPoint.y);
		CGContextStrokePath(UIGraphicsGetCurrentContext());
		drawingLayer.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		lastPoint = firstPoint;
		
		fingerMoved++;
		
		if (fingerMoved == 10) {
			fingerMoved = 0;
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	if (drawingButtonPressed) 
    {
        if (!fingerSwiped) 
        {
			UIGraphicsBeginImageContext(self.view.frame.size);
			[drawingLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
			CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);

            if (eraserPressed) {
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 6);
                CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            } else {
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3);
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), howMuchRed, howMuchGreen, howMuchBlue, 1.0);
            }
            
			CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
			CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
			CGContextStrokePath(UIGraphicsGetCurrentContext());
			drawingLayer.image = UIGraphicsGetImageFromCurrentImageContext();
			UIGraphicsEndImageContext();
		}
	}
    
    [self saveDolls];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event 
{
	if (event.type == UIEventSubtypeMotionShake) 
    {
		if (drawingButtonPressed == YES) {
            drawingLayer.image = nil;
		} else if (pinButtonPressed == YES) {
			pinsLayer.image = nil;
		} else if (fireButtonPressed == YES) {
			fireBurnsLayer.image = nil;
		} else if (lightningButtonPressed == YES) {
			lightningBurnsLayer.image = nil;
		} else if (foodButtonPressed == YES) {
			foodLayer.image = nil;
		} else {
            drawingLayer.image = nil;
			pinsLayer.image = nil;
            fireBurnsLayer.image = nil;
            lightningBurnsLayer.image = nil;
            foodLayer.image = nil;
		}
        
        [self saveDolls];
	}
}

- (void)addBurn
{
    UIImage *image = [UIImage imageNamed:@"burn.png"];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [lightningBurnsLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [image drawInRect:CGRectMake(firstPoint.x - 17, firstPoint.y - 20, 40.0f, 35.0f)];
    lightningBurnsLayer.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)vibrate
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);	
}

- (void)saveDolls
{
    specificDoll.pinsImageData = UIImagePNGRepresentation(pinsLayer.image);
    specificDoll.fireImageData = UIImagePNGRepresentation(fireLayer.image);
    specificDoll.lightningImageData = UIImagePNGRepresentation(lightningLayer.image);
    specificDoll.foodImageData = UIImagePNGRepresentation(foodLayer.image);
    specificDoll.drawingImageData = UIImagePNGRepresentation(drawingLayer.image);
    specificDoll.lightningBurnsImageData = UIImagePNGRepresentation(lightningBurnsLayer.image);
    
    [[DollDataManager sharedDollDataManager] saveDolls];
}

#pragma mark - Animations

- (void)bodyAnimation
{
    genderLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.gender]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.gender]], nil];
	genderLayer.animationDuration = 0.2;
	genderLayer.animationRepeatCount = 5;
    
    shirtLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.shirt]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.shirt]], nil];
	shirtLayer.animationDuration = 0.2;
	shirtLayer.animationRepeatCount = 5;
    
    pantsLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.pants]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.pants]], nil];
	pantsLayer.animationDuration = 0.2;
	pantsLayer.animationRepeatCount = 5;
    
    otherLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.other]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.other]], nil];
	otherLayer.animationDuration = 0.2;
	otherLayer.animationRepeatCount = 5;

    [genderLayer startAnimating];
    [shirtLayer startAnimating];
    [pantsLayer startAnimating];
    [otherLayer startAnimating];
}

- (void)fireAnimation
{
    NSMutableArray *fireAnimation = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"flame1.png"], [UIImage imageNamed:@"flame2.png"], nil];
	
    for (int i = 0; i < [fireAnimation count]; i++) 
    {			
        UIImage *image = [fireAnimation objectAtIndex:i];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [fireLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [image drawInRect:CGRectMake(firstPoint.x - 18, firstPoint.y - 59, 35.0f, 57.0f)];
        fireLayer.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [fireAnimation replaceObjectAtIndex:i withObject:fireLayer.image];
        
        fireLayer.image = nil;
    }
    
    fireLayer.animationImages = fireAnimation;
    fireLayer.animationRepeatCount = 8;
    
    [fireLayer startAnimating];
}

- (void)lightningAnimation
{
    NSMutableArray *lightningAnimation = [[NSMutableArray alloc] initWithObjects: [UIImage imageNamed:@"lightning1.png"], [UIImage imageNamed:@"lightning2.png"], [UIImage imageNamed:@"lightning3.png"], [UIImage imageNamed:@"lightning3.png"], [UIImage imageNamed:@"lightning4.png"], [UIImage imageNamed:@"lightning5.png"], nil];
    
    for (int i = 0; i < [lightningAnimation count]; i++) 
    {			
        UIImage *image = [lightningAnimation objectAtIndex:i];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        [lightningLayer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [image drawInRect:CGRectMake(firstPoint.x - 25, firstPoint.y - 165, 115.0f, 175.0f)];
        lightningLayer.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [lightningAnimation replaceObjectAtIndex:i withObject:lightningLayer.image];
        
        lightningLayer.image = nil;
    }
    
    lightningLayer.animationImages = lightningAnimation;
    lightningLayer.animationRepeatCount = 1;
    
    [lightningLayer startAnimating];
}

#pragma mark - Buttons

- (IBAction)selectInteraction:(UIButton *)button
{
    if (button.tag == 1) {
        pinButtonPressed = YES; 
        
        fireButtonPressed = NO;
        lightningButtonPressed = NO;
        foodButtonPressed = NO;
        drawingButtonPressed = NO;
    } else if (button.tag == 2) {
        fireButtonPressed = YES;
        
        pinButtonPressed = NO;
        lightningButtonPressed = NO;
        foodButtonPressed = NO;
        drawingButtonPressed = NO;
    } else if (button.tag == 3) {
        lightningButtonPressed = YES;
        
        pinButtonPressed = NO;
        fireButtonPressed = NO;
        foodButtonPressed = NO;
        drawingButtonPressed = NO;
    } else if (button.tag == 4) {
        foodButtonPressed = YES;
        tomatoButtonPressed = YES;
        
        pinButtonPressed = NO;
        fireButtonPressed = NO;
        lightningButtonPressed = NO;
        drawingButtonPressed = NO;
    } else if (button.tag == 5) {
        drawingButtonPressed = YES;
        
        pinButtonPressed = NO;
        fireButtonPressed = NO;
        lightningButtonPressed = NO;
        foodButtonPressed = NO;
    }
    
    [self optionsVisibility];
}

- (IBAction)foodOptions:(UIButton *)button
{
    if (button.tag == 6) {
        tomatoButtonPressed = YES;
        eggButtonPressed = NO;
    } else if (button.tag == 7) {
        tomatoButtonPressed = NO;
        eggButtonPressed = YES;
    }
}

- (IBAction)drawingOptions:(UIButton *)button
{
    if (button.tag == 8) {
        howMuchRed = 0.0;
        howMuchBlue = 0.0;
        howMuchGreen = 0.0;
    } else if (button.tag == 9) {
        howMuchRed = 1.0;
        howMuchBlue = 0.0;
        howMuchGreen = 0.0;
    } else if (button.tag == 10) {
        howMuchRed = 1.0;
        howMuchBlue = 0.0;
        howMuchGreen = 1.0;
    } else if (button.tag == 11) {
        howMuchRed = 0.0;
        howMuchBlue = 0.0;
        howMuchGreen = 1.0;
    } else if (button.tag == 12) {
        howMuchRed = 0.0;
        howMuchBlue = 1.0;
        howMuchGreen = 0.0;
    } else if (button.tag == 13) {
        howMuchRed = 0.5;
        howMuchBlue = 1.0;
        howMuchGreen = 0.0;
    } 
    
    if (button.tag == 14) {
        eraserPressed = YES;
    } else {
        eraserPressed = NO;
    }
}

- (void)optionsVisibility
{
    for (UIView *view in self.view.subviews) 
    {
        if ([view isKindOfClass:[UIButton class]]) 
        { 
            if (drawingButtonPressed == YES && view.tag >= 8 && view.tag <= 14) view.hidden = NO;
            else if (drawingButtonPressed == NO && view.tag >= 8 && view.tag <= 14) view.hidden = YES;

            if (foodButtonPressed == YES && view.tag >= 6 && view.tag <= 7) view.hidden = NO;
            else if (foodButtonPressed == NO && view.tag >= 6 && view.tag <= 7) view.hidden = YES;
        }
    }
}

- (IBAction)toCustomizationView:(UIBarButtonItem *)barButtonItem
{
    DollCustomizationViewController *dollCustomizationViewController = [[DollCustomizationViewController alloc] init];
    dollCustomizationViewController.specificDoll = specificDoll;
    
    [self.navigationController presentModalViewController:dollCustomizationViewController animated:YES];
    
    [dollCustomizationViewController release];
}

@end