//
//  Doll.h
//  hex'd
//
//  Created by Shirmung Bielefeld on 1/2/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Doll : NSObject
{
    NSString *name;
    NSString *gender;
    NSString *eyes;
    NSString *mouth;
    NSString *hair;
    NSString *shirt;
    NSString *pants;
    NSString *other;
    
    int emotion;
    
    NSData *pinsImageData;
    NSData *fireImageData;
    NSData *fireBurnsImageData;
	NSData *lightningImageData;
    NSData *lightningBurnsImageData;
	NSData *foodImageData;
    NSData *drawingImageData;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *eyes;
@property (nonatomic, retain) NSString *mouth;
@property (nonatomic, retain) NSString *hair;
@property (nonatomic, retain) NSString *shirt;
@property (nonatomic, retain) NSString *pants;
@property (nonatomic, retain) NSString *other;

@property (nonatomic, assign) int emotionLevel;

@property (nonatomic, retain) NSData *pinsImageData;
@property (nonatomic, retain) NSData *fireImageData;
@property (nonatomic, retain) NSData *fireBurnsImageData;
@property (nonatomic, retain) NSData *lightningImageData;
@property (nonatomic, retain) NSData *lightningBurnsImageData;
@property (nonatomic, retain) NSData *foodImageData;
@property (nonatomic, retain) NSData *drawingImageData;

@end
