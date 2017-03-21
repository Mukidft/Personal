//
//  UI_GraphView.m
//  SpectralEQ
//
//  Created by Owl on 2/16/17.
//  Copyright © 2017 DeepakChennakkadan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import <AppKit/NSGraphicsContext.h>
#import "UI_GraphView.h"
#include <iostream>


@implementation UI_GraphView

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Background
    [[NSColor colorWithDeviceRed:0.227 green:0.251 blue:0.337 alpha:0.6] set];
    NSRectFill(dirtyRect);
    
    /*
    NSRect bounds = [self bounds];
    CGFloat emptySpace = 40;
    CGFloat lineWidth = 2;
    
    CGFloat width;
    [self setPath:[NSBezierPath bezierPath]];
    if (NSMaxX(bounds) > NSMaxY(bounds)) {
        width = NSMaxY(bounds) - emptySpace;
    } else {
        width = NSMaxX(bounds) - emptySpace;
    }
    [path moveToPoint: (NSPoint) {width/-2, 0}];
    [path lineToPoint: (NSPoint) {width/2, 0}];
    
    [path setLineWidth: lineWidth];
    [path stroke];
    
    NSRectFill(dirtyRect);
     */
    
    NSPoint tp[] = { 10, 10, 400, 100, 300, 200, 10, 150 };
    
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    // Main Input
    [path moveToPoint:tp[0]];
    [path lineToPoint:tp[1]];
    [path lineToPoint:tp[2]];
    [path lineToPoint:tp[3]];
    [path closePath];
    [[NSColor colorWithDeviceRed:0 green:255 blue:255 alpha:0.3] set];
    [path fill];
    
    [[NSColor cyanColor] set];
    [path stroke];
    
}

-(void) plotData:(Float32 *) data givenInfos: (SpectrumGraphInfo) infos;
{
    for (UInt32  i = 0; i < infos.mNumBins; i++)
    {
        double freq = i * (double) infos.mSamplingRate / (double)(infos.mNumBins * 2);    
    }

}
@end