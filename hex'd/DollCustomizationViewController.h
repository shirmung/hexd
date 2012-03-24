//
//  DollCustomizationViewController.h
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Doll;

@interface DollCustomizationViewController : UIViewController
{
    Doll *specificDoll;
    
    NSString *tempHair;
    NSString *tempShirt;
    NSString *tempPants;
    NSString *tempOther;
    NSString *tempBackground;
    
    UIScrollView *hairScrollView;
    UIScrollView *shirtScrollView;
    UIScrollView *pantsScrollView;
    UIScrollView *otherScrollView;
    UIScrollView *backgroundScrollView;
}

@property (nonatomic, retain) Doll *specificDoll;

@property (nonatomic, retain) NSString *tempHair;
@property (nonatomic, retain) NSString *tempShirt;
@property (nonatomic, retain) NSString *tempPants;
@property (nonatomic, retain) NSString *tempOther;
@property (nonatomic, retain) NSString *tempBackground;

@property (nonatomic, retain) IBOutlet UIScrollView *hairScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *shirtScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *pantsScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *otherScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *backgroundScrollView;

@end
