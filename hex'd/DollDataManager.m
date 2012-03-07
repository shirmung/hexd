//
//  DollDataManager.m
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "DollDataManager.h"
#import "Doll.h"

@implementation DollDataManager

@synthesize dolls;

static DollDataManager *sharedDollDataManager;

+ (DollDataManager *)sharedDollDataManager
{
    if (sharedDollDataManager == nil) 
    {
        sharedDollDataManager = [[DollDataManager alloc] init];
    }
    
    return sharedDollDataManager;
}

- (id)init
{
    if (self = [super init]) 
    {
        dolls = [[NSMutableArray alloc] init];
        
        NSString *dollsFilePath = [NSString stringWithString:[self dollsFilePath]];
        BOOL dollsFileExists = [[NSFileManager defaultManager] fileExistsAtPath:dollsFilePath];
                                      
        if (dollsFileExists)
        {
            NSDictionary *dollsData = [NSDictionary dictionaryWithContentsOfFile:dollsFilePath];

            for (NSString *dollKey in dollsData)
            {
                NSDictionary *detailsOfDoll = [dollsData objectForKey:dollKey];
                    
                Doll *doll = [[Doll alloc] init];
                
                doll.name = [detailsOfDoll objectForKey:@"name"];
                doll.gender = [detailsOfDoll objectForKey:@"gender"];
                doll.eyes = [detailsOfDoll objectForKey:@"eyes"];
                doll.mouth = [detailsOfDoll objectForKey:@"mouth"];
                doll.hair = [detailsOfDoll objectForKey:@"hair"];
                doll.shirt = [detailsOfDoll objectForKey:@"shirt"];
                doll.pants = [detailsOfDoll objectForKey:@"pants"];
                doll.other = [detailsOfDoll objectForKey:@"other"];
                
                doll.pinsImageData = [detailsOfDoll objectForKey:@"pinsImageData"];
                doll.fireImageData = [detailsOfDoll objectForKey:@"fireImageData"];
                doll.fireBurnsImageData = [detailsOfDoll objectForKey:@"fireBurnsImageData"];
                doll.lightningImageData = [detailsOfDoll objectForKey:@"lightningImageData"];
                doll.lightningBurnsImageData = [detailsOfDoll objectForKey:@"lightningBurnsImageData"];
                doll.foodImageData = [detailsOfDoll objectForKey:@"foodImageData"];
                doll.drawingImageData = [detailsOfDoll objectForKey:@"drawingImageData"];
                    
                [self.dolls addObject:doll];
                
                [doll release];
            }
        }
    }
    
    return self;
}

- (void)dealloc
{
    [dolls release];
    
    [super dealloc];
}
            
- (void)saveDolls
{
    NSMutableDictionary *dollsData = [[NSMutableDictionary alloc] init];
    
    for (Doll *doll in dolls)
    {
        NSMutableDictionary *detailsOfDoll = [[NSMutableDictionary alloc] init];
        
        [detailsOfDoll setObject:doll.name forKey:@"name"];
        [detailsOfDoll setObject:doll.gender forKey:@"gender"];
        [detailsOfDoll setObject:doll.eyes forKey:@"eyes"];
        [detailsOfDoll setObject:doll.mouth forKey:@"mouth"];
        [detailsOfDoll setObject:doll.hair forKey:@"hair"];
        [detailsOfDoll setObject:doll.shirt forKey:@"shirt"];
        [detailsOfDoll setObject:doll.pants forKey:@"pants"];
        [detailsOfDoll setObject:doll.other forKey:@"other"];
        
        if (doll.pinsImageData != nil) [detailsOfDoll setObject:doll.pinsImageData forKey:@"pinsImageData"];
        if (doll.fireImageData != nil) [detailsOfDoll setObject:doll.fireImageData forKey:@"fireImageData"];
        if (doll.fireBurnsImageData != nil) [detailsOfDoll setObject:doll.fireBurnsImageData forKey:@"fireBurnsImageData"];
        if (doll.lightningImageData != nil) [detailsOfDoll setObject:doll.lightningImageData forKey:@"lightningImageData"];
        if (doll.lightningBurnsImageData != nil) [detailsOfDoll setObject:doll.lightningBurnsImageData forKey:@"lightningBurnsImageData"];
        if (doll.foodImageData != nil) [detailsOfDoll setObject:doll.foodImageData forKey:@"foodImageData"];
        if (doll.drawingImageData != nil) [detailsOfDoll setObject:doll.drawingImageData forKey:@"drawingImageData"];

        [dollsData setObject:detailsOfDoll forKey:[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
        
        [detailsOfDoll release];
    }

    [dollsData writeToFile:[self dollsFilePath] atomically:YES];
    
    [dollsData release];
}

- (NSString *)dollsFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:@"userDollsData.plist"];
}

@end
