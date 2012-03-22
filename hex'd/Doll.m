//
//  Doll.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "Doll.h"

@implementation Doll

@synthesize name, gender, eyes, mouth, hair, shirt, pants, other, background;
@synthesize pinsImageData, fireImageData, fireBurnsImageData, lightningImageData, lightningBurnsImageData, foodImageData, drawingImageData;
@synthesize emotionLevel;

-(id)init
{
    if (self = [super init]) {
        name = @"";
        gender = @"";
        eyes = @"neutraleyes";
        mouth = @"neutralmouth";
        hair = @"";
        shirt = @"";
        pants = @"";
        other = @"";
        background = @"";
        
        emotion = 0;
    }
    
    return self;
}

-(void)dealloc
{
    [name release];
    [gender release];
    [eyes release];
    [mouth release];
    [hair release];
    [shirt release];
    [pants release];
    [other release];
    [background release];
    
    [pinsImageData release];
    [fireImageData release];
    [fireBurnsImageData release];
    [lightningImageData release];
    [lightningBurnsImageData release];
    [foodImageData release];
    [drawingImageData release];
    
    [super dealloc];
}

@end
