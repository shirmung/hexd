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
}

@property (nonatomic, retain) Doll *specificDoll;

- (IBAction)selectHair:(UIButton *)button;
- (IBAction)selectShirt:(UIButton *)button;
- (IBAction)selectPants:(UIButton *)button;
- (IBAction)selectOther:(UIButton *)button;

- (IBAction)dismissView:(UIBarButtonItem *)barButtonItem;

@end
