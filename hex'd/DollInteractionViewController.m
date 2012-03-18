//
//  DollInteractionViewController.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

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
    
    // TDL: make this a loop
    if (![specificDoll.background isEqualToString:@""]) {
        backgroundLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.background]]];
    } else {
        backgroundLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"background4.png"]]];
    }
    
    [self.view addSubview:backgroundLayer];
    [backgroundLayer release];
    
    genderLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.gender]]];
    [self.view addSubview:genderLayer];
    [genderLayer release];
    
    eyesLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.eyes]]];
    [self.view addSubview:eyesLayer];
    [eyesLayer release];
    
    cryingLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blank.png"]];
    cryingLayer.animationImages = [NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"crying1.png"],
                                   [UIImage imageNamed:@"crying2.png"],
                                   [UIImage imageNamed:@"crying3.png"],
                                   [UIImage imageNamed:@"crying4.png"],
                                   [UIImage imageNamed:@"crying5.png"], 
                                   [UIImage imageNamed:@"crying6.png"],
                                   [UIImage imageNamed:@"crying7.png"], nil];
	cryingLayer.animationDuration = 0.5;
    cryingLayer.animationRepeatCount = 1;
    cryingLayer.alpha = 0;
    [self.view addSubview:cryingLayer];
    [cryingLayer release];
    
    mouthLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.mouth]]];
    [self.view addSubview:mouthLayer];
    [mouthLayer release];
    
    hairLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.hair]]];
    [self.view addSubview:hairLayer];
    [hairLayer release];
    
    shirtLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.shirt]]];
    [self.view addSubview:shirtLayer];
    [shirtLayer release];
    
    pantsLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.pants]]];
    [self.view addSubview:pantsLayer];
    [pantsLayer release];
    
    otherLayer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.other]]];
    [self.view addSubview:otherLayer];
    [otherLayer release];
    
    fireBurnsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.fireBurnsImageData]];
    fireBurnsLayer.frame = self.view.frame;
    [self.view addSubview:fireBurnsLayer];
    [fireBurnsLayer release];
    
    lightningBurnsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.lightningBurnsImageData]];
    lightningBurnsLayer.frame = self.view.frame;
    [self.view addSubview:lightningBurnsLayer];
    [lightningBurnsLayer release];
    
    foodLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.foodImageData]];
	foodLayer.frame = self.view.frame;
    [self.view addSubview:foodLayer];
    [foodLayer release];
    
    pinsLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.pinsImageData]];
	pinsLayer.frame = self.view.frame;
    [self.view addSubview:pinsLayer];
    [pinsLayer release];
    
    drawingLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.drawingImageData]];
	drawingLayer.frame = self.view.frame;
    [self.view addSubview:drawingLayer];
    [drawingLayer release];
    
    fireLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.fireImageData]];
	fireLayer.frame = self.view.frame;
    [self.view addSubview:fireLayer];
    [fireLayer release];
    
    lightningLayer = [[UIImageView alloc] initWithImage:[UIImage imageWithData:specificDoll.lightningImageData]];
	lightningLayer.frame = self.view.frame;
    [self.view insertSubview:lightningLayer aboveSubview:fireLayer];
    [lightningLayer release];
    
    for (UIView *view in self.view.subviews) 
    {
        if ([view isKindOfClass:[UIButton class]]) [self.view bringSubviewToFront:view];
    }

    // the doll should blink
    double blinkDelay = 4;
    double blinkDuration = 0.25;
    int blinkRepeatCount = 1;
    NSMethodSignature *blinkEyesSignature = [self methodSignatureForSelector:@selector(blinkEyesWithDuration:withRepeatCount:)];
    NSInvocation *blinkEyesInvocation = [NSInvocation invocationWithMethodSignature:blinkEyesSignature];
    [blinkEyesInvocation setTarget:self];
    [blinkEyesInvocation setSelector:@selector(blinkEyesWithDuration:withRepeatCount:)];
    [blinkEyesInvocation setArgument:&blinkDuration atIndex:2];
    [blinkEyesInvocation setArgument:&blinkRepeatCount atIndex:3];
    
    blinkTimer = [NSTimer scheduledTimerWithTimeInterval:blinkDelay invocation:blinkEyesInvocation repeats:YES];
    
    // the doll should feel better over time
    emotionTimer = [NSTimer scheduledTimerWithTimeInterval:blinkDelay
                                     target:self
                                   selector:@selector(feelingBetter)
                                   userInfo:nil
                                    repeats:YES];
    
//    NSLog(@"Lightning retain count: %d", [lightningLayer retainCount]);
//    
//    NSLog(@"name: %@", specificDoll.name);
//    NSLog(@"gender: %@", specificDoll.gender);
//    NSLog(@"eyes: %@", specificDoll.eyes);
//    NSLog(@"mouth: %@", specificDoll.mouth);
//    NSLog(@"hair: %@", specificDoll.hair);
//    NSLog(@"shirt: %@", specificDoll.shirt);
//    NSLog(@"pants: %@", specificDoll.pants);
//    NSLog(@"other: %@", specificDoll.other);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [blinkTimer invalidate];
    [emotionTimer invalidate];
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
                                                                            style:UIBarButtonItemStyleDone
                                                                           target:self
                                                                            action:@selector(toCustomizationView:)];
    self.navigationItem.rightBarButtonItem = customizationButton;
    
    [customizationButton release];
    
    // reset face
    specificDoll.eyes = @"neutraleyes";
    specificDoll.mouth = @"neutralmouth";
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
        //[self feelingWorse];
        //[self bodyAnimation];
        
        if (pinButtonPressed) {
            [self wince];
            [self feelingWorse];
        } else if (fireButtonPressed) {
            [self ouch];
            [self feelingWorse];
        } else if (lightningButtonPressed) {
            double lightningDelay = 0.3;
            [NSTimer scheduledTimerWithTimeInterval:lightningDelay
                                             target:self 
                                           selector:@selector(wince) 
                                           userInfo:nil 
                                            repeats:NO];
            [NSTimer scheduledTimerWithTimeInterval:lightningDelay
                                             target:self 
                                           selector:@selector(feelingWorse) 
                                           userInfo:nil 
                                            repeats:NO];
            
            double blinkAnimationDuration = 0.15;
            int bodyRepeatCount = 2;
            NSInvocation *bodyInvocation = [NSInvocation invocationWithMethodSignature:
                                            [self methodSignatureForSelector:
                                             @selector(bodyAnimationWithDuration:withRepeatCount:)]];
            [bodyInvocation setTarget:self];
            [bodyInvocation setSelector:@selector(bodyAnimationWithDuration:withRepeatCount:)];
            [bodyInvocation setArgument:&blinkAnimationDuration atIndex:2];
            [bodyInvocation setArgument:&bodyRepeatCount atIndex:3];
            [NSTimer scheduledTimerWithTimeInterval:lightningDelay invocation:bodyInvocation repeats:NO];
            
        } else if (foodButtonPressed) {
            [self wince];
        } else {
            [self wince];
        }
        
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
                                       selector:@selector(addBurn:)
                                       userInfo:fireBurnsLayer
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
									   selector:@selector(addBurn:)
									   userInfo:lightningBurnsLayer
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

- (void)addBurn:(NSTimer *)timer
{
    UIImageView *layer = [timer userInfo];
    
    UIImage *image = [UIImage imageNamed:@"burn.png"];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [layer.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [image drawInRect:CGRectMake(firstPoint.x - 17, firstPoint.y - 20, 40.0f, 35.0f)];
    layer.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveDolls];
}

- (void)vibrate
{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);	
}

- (void)saveDolls
{
    specificDoll.pinsImageData = UIImagePNGRepresentation(pinsLayer.image);
    specificDoll.fireImageData = UIImagePNGRepresentation(fireLayer.image);
    specificDoll.fireBurnsImageData = UIImagePNGRepresentation(fireBurnsLayer.image);
    specificDoll.lightningImageData = UIImagePNGRepresentation(lightningLayer.image);
    specificDoll.lightningBurnsImageData = UIImagePNGRepresentation(lightningBurnsLayer.image);
    specificDoll.foodImageData = UIImagePNGRepresentation(foodLayer.image);
    specificDoll.drawingImageData = UIImagePNGRepresentation(drawingLayer.image);

    [[DollDataManager sharedDollDataManager] saveDolls];
}

#pragma mark - Emotions

#define SAD -5
#define REALLY_SAD -15
#define CRYING -25

// time heals all wounds
- (void)feelingBetter
{
    if (specificDoll.emotionLevel < 0)
    {
        // change emotion level
        specificDoll.emotionLevel += 1;
        
        // adjust facial expression
        if (specificDoll.emotionLevel >= SAD && specificDoll.emotionLevel <= 0) {
            specificDoll.eyes = @"neutraleyes";
            specificDoll.mouth = @"neutralmouth";
        } else if (specificDoll.emotionLevel >= REALLY_SAD && specificDoll.emotionLevel < SAD) {
            specificDoll.eyes = @"sadeyes1.png";
            specificDoll.mouth = @"sadmouth1.png";
        } else if (specificDoll.emotionLevel >= CRYING && specificDoll.emotionLevel < REALLY_SAD) {
            cryingLayer.alpha = 0;
        }
        [eyesLayer setImage:[UIImage imageNamed:specificDoll.eyes]];
        [mouthLayer setImage:[UIImage imageNamed:specificDoll.mouth]];
    }
    
    //NSLog(@"emotion level: %d", specificDoll.emotionLevel);
}

// time wounds all heals
- (void)feelingWorse
{
    if (specificDoll.emotionLevel > CRYING-5)
    {
        // change emotion level
        specificDoll.emotionLevel -= 1;
        
        // adjust facial expression
        if (specificDoll.emotionLevel <= SAD && specificDoll.emotionLevel > REALLY_SAD) {
            specificDoll.eyes = @"sadeyes1";
            specificDoll.mouth = @"sadmouth1";
        } else if ( specificDoll.emotionLevel <= REALLY_SAD && specificDoll.emotionLevel > CRYING) {
            specificDoll.eyes = @"sadeyes2";
            specificDoll.mouth = @"sadmouth2";
        }
        
        [eyesLayer setImage:[UIImage imageNamed:specificDoll.eyes]];
        [mouthLayer setImage:[UIImage imageNamed:specificDoll.mouth]];
    }
    
    if ( specificDoll.emotionLevel <= CRYING) {
        NSLog(@"cry");
        cryingLayer.alpha = 1;
        [cryingLayer startAnimating];
    }
    
    //NSLog(@"emotion level: %d", specificDoll.emotionLevel);
}

#pragma mark - Facial expressions

// the doll will have atomic actions: squeeze eyes, open mouth
// the doll will make more actions by mixing and matching atomic actions

// wince after being stuck with a pin
- (void)wince
{
    double winceDuration = 0.25;    
    [self squeezeEyesWithDuration:winceDuration];
    [self openMouthWithDuration:winceDuration];
}

// ouch after being burned
- (void)ouch
{
    // blink twice
    double blinkLength = 0.35;
    double squeezeLength = 1;
    int repeatCount = 2;
    double ouchDelay = blinkLength * repeatCount;

    [self blinkEyesWithDuration:blinkLength withRepeatCount:repeatCount];
    
    // open mouth
    NSMethodSignature *mouthSignature = [self methodSignatureForSelector:@selector(openMouthWithDuration:)];
    NSInvocation *mouthInvocation = [NSInvocation invocationWithMethodSignature:mouthSignature];
    [mouthInvocation setTarget:self];
    [mouthInvocation setSelector:@selector(openMouthWithDuration:)];
    [mouthInvocation setArgument:&squeezeLength atIndex:2];
    
    [NSTimer scheduledTimerWithTimeInterval:ouchDelay invocation:mouthInvocation repeats:NO];
    
    // squeeze eyes
    NSMethodSignature *eyesSignature = [self methodSignatureForSelector:@selector(squeezeEyesWithDuration:)];
    NSInvocation *squeezeEyesInvocation = [NSInvocation invocationWithMethodSignature:eyesSignature];
    [squeezeEyesInvocation setTarget:self];
    [squeezeEyesInvocation setSelector:@selector(squeezeEyesWithDuration:)];
    [squeezeEyesInvocation setArgument:&squeezeLength atIndex:2];
    
    [NSTimer scheduledTimerWithTimeInterval:ouchDelay invocation:squeezeEyesInvocation repeats:NO];
    
    // animate body
    double bodyAnimationDuration = 0.2;
    int bodyRepeatCount = 5;
    NSInvocation *bodyInvocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(bodyAnimationWithDuration:withRepeatCount:)]];
    [bodyInvocation setTarget:self];
    [bodyInvocation setSelector:@selector(bodyAnimationWithDuration:withRepeatCount:)];
    [bodyInvocation setArgument:&bodyAnimationDuration atIndex:2];
    [bodyInvocation setArgument:&bodyRepeatCount atIndex:3];
    [NSTimer scheduledTimerWithTimeInterval:ouchDelay invocation:bodyInvocation repeats:NO];
    
}

// blink (eyes blink for 1/3 of animation)
- (void)blinkEyesWithDuration:(double)duration withRepeatCount:(int)numTimes
{
    UIImage *image1 = [UIImage imageNamed: [self imageName:@"blinkedeyes"]];
    UIImage *image2 = [UIImage imageNamed: [self imageName: specificDoll.eyes]];
    NSArray *animation = [NSArray arrayWithObjects: image1, image1, image2, image2, nil];
    [self animateLayer:eyesLayer withImages:animation withDuration:duration withRepeatCount:numTimes];
}

// squeeze eyes
- (void)squeezeEyesWithDuration:(double)duration
{
    UIImage *image1 = [UIImage imageNamed: [self imageName:@"squeezedeyes"]];
    NSArray *animation = [NSArray arrayWithObject: image1];
    [self animateLayer:eyesLayer withImages:animation withDuration:duration withRepeatCount:1];
}

// open mouth
- (void)openMouthWithDuration:(double)duration
{
    UIImage *image1 = [UIImage imageNamed: [self imageName:@"openmouth"]];
    NSArray *openAnimation = [NSArray arrayWithObject:image1];
    
    [self animateLayer:mouthLayer withImages:openAnimation withDuration:duration withRepeatCount:1];
    
    NSString *fileName = @"";
    
    if (fireButtonPressed) {
        if (![specificDoll.gender isEqualToString:@"othergender"]) {
            fileName = [NSString stringWithFormat:@"%@2", specificDoll.gender];
        } else {
            fileName = @"male2";
        }
    } else {
        if (![specificDoll.gender isEqualToString:@"othergender"]) {
            fileName = [NSString stringWithFormat:@"%@1", specificDoll.gender];
        } else {
            fileName = @"male1";
        }  
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:filePath], &soundID);
    AudioServicesPlaySystemSound (soundID);	
}

// helper method for animations
- (void)animateLayer:(UIImageView *)layer withImages:(NSArray *)images withDuration:(double)duration withRepeatCount:(int)repeatCount
{
    layer.animationImages = images;
    layer.animationDuration = duration;
    layer.animationRepeatCount = repeatCount;

    [layer startAnimating];
}

// helper method for getting file types
- (NSString *)imageName:(NSString *)name 
{
    NSString *format = @"png";
    return [NSString stringWithFormat:@"%@.%@", name, format];
}

#pragma mark - Animations

- (void)bodyAnimationWithDuration:(double)animationDuration withRepeatCount:(int)repeatCount
{
    genderLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.gender]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.gender]], nil];
	genderLayer.animationDuration = animationDuration;
	genderLayer.animationRepeatCount = repeatCount;
    
    shirtLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.shirt]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.shirt]], nil];
	shirtLayer.animationDuration = animationDuration;
	shirtLayer.animationRepeatCount = repeatCount;
    
    pantsLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.pants]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.pants]], nil];
	pantsLayer.animationDuration = animationDuration;
	pantsLayer.animationRepeatCount = repeatCount;
    
    otherLayer.animationImages = [NSArray arrayWithObjects: [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", specificDoll.other]],[UIImage imageNamed:[NSString stringWithFormat:@"%@out.png", specificDoll.other]], nil];
	otherLayer.animationDuration = animationDuration;
	otherLayer.animationRepeatCount = repeatCount;

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
    
    [button setSelected:YES];
    
    for (id otherButton in self.view.subviews) 
    {
        if ([otherButton isKindOfClass:[UIButton class]] && [otherButton tag] != button.tag)
        {
            [otherButton setSelected:NO];
        }
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
    
    [button setSelected:YES];
    
    for (id otherButton in self.view.subviews) 
    {
        if ([otherButton isKindOfClass:[UIButton class]] && [otherButton tag] >= 6 && [otherButton tag] <= 7)
        {
            if ([otherButton tag] != button.tag) [otherButton setSelected:NO];
        }
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
    
    [button setSelected:YES];
        
    for (id otherButton in self.view.subviews) 
    {
        if ([otherButton isKindOfClass:[UIButton class]] && [otherButton tag] >= 8 && [otherButton tag] <= 14)
        {
            if ([otherButton tag] != button.tag) [otherButton setSelected:NO];
        }
    }
}

- (void)optionsVisibility
{
    for (id view in self.view.subviews) 
    {
        if ([view isKindOfClass:[UIButton class]]) 
        { 
            if (drawingButtonPressed == YES && [view tag] >= 8 && [view tag] <= 14) {
                [view setHidden:NO];
                
                if ([view tag] == 8) [view setSelected:YES];
            } else if (drawingButtonPressed == NO && [view tag] >= 8 && [view tag] <= 14) {
                [view setHidden:YES];
            }

            if (foodButtonPressed == YES && [view tag] >= 6 && [view tag] <= 7) {
                [view setHidden:NO];
                
                if ([view tag] == 6) [view setSelected:YES];
            } else if (foodButtonPressed == NO && [view tag] >= 6 && [view tag] <= 7) {
                [view setHidden:YES];
            }
        }
    }
}

- (IBAction)shareDoll:(UIButton *)button
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(window.frame.size);
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef temp = CGImageCreateWithImageInRect([screenshot CGImage], CGRectMake(0, 20, 320, 460));
    croppedImage = [[UIImage alloc] initWithCGImage:temp];
    CGImageRelease(temp);

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self 
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Photo Album", @"Email", nil];
    actionSheet.actionSheetStyle = UIBarStyleBlackTranslucent;

    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index 
{
    if (index == 0) {
        UIImageWriteToSavedPhotosAlbum(croppedImage, nil, nil, nil);
    } else if (index == 1) {
        if ([MFMailComposeViewController canSendMail]) 
        {
            MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
            mailComposeViewController.mailComposeDelegate = self;
            mailComposeViewController.subject = @"Check out the voodoo doll that I created with hex'd!";
            
            NSData *croppedImageData = UIImagePNGRepresentation(croppedImage);
            [mailComposeViewController addAttachmentData:croppedImageData mimeType:@"image/png" fileName:@"croppedImageData.png"];
            
            [self presentModalViewController:mailComposeViewController animated:YES];
            [mailComposeViewController release];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)mailComposeViewController didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error 
{
	[self becomeFirstResponder];
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)toCustomizationView:(UIBarButtonItem *)barButtonItem
{
    DollCustomizationViewController *dollCustomizationViewController = [[DollCustomizationViewController alloc] init];
    dollCustomizationViewController.specificDoll = specificDoll;
    
    [self.navigationController presentModalViewController:dollCustomizationViewController animated:YES];
    
    [dollCustomizationViewController release];
}

@end