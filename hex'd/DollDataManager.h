//
//  DollDataManager.h
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DollDataManager : NSObject
{
    NSMutableArray *dolls;
    NSArray *sortDescriptors;
}

@property (nonatomic, retain) NSMutableArray *dolls;

+ (DollDataManager *)sharedDollDataManager;

- (void)saveDolls;
- (void)sort;

@end
