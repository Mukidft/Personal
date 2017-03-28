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
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawBackground:dirtyRect color: [NSColor colorWithDeviceRed:0.227 green:0.251 blue:0.337 alpha:0.6]];
    [self drawGraph:NULL fill:[NSColor colorWithDeviceRed:0 green:255 blue:255 alpha:0.3] stroke: [NSColor cyanColor]];
    
}

- (void)drawBackground: (NSRect) dirtyRect color: (NSColor*) color;
{
    [color set];
    NSRectFill(dirtyRect);
}

- (void)drawGraph: (NSPoint *) points fill: (NSColor*) fill stroke: (NSColor*) stroke
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    // Main Input
    [path moveToPoint:NSMakePoint(10, 10)];
    [path lineToPoint:NSMakePoint(400, 100)];
    [path lineToPoint:NSMakePoint(300, 200)];
    [path lineToPoint:NSMakePoint(10, 150)];
    [path closePath];
    [fill set];
    [path fill];
    
    [stroke set];
    [path stroke];

}

-(void) plotData:(Float32 *) data givenInfos: (SpectrumGraphInfo) infos;
{   
    for (UInt32  i = 0; i < infos.mNumBins; i++)
    {
        double bin = i * (double) infos.mSamplingRate / (double)(infos.mNumBins * 2);
        
        NSPoint point;
        point.x = (CGFloat) bin;
        point.y = data[i];
        
    }
    
    [self setNeedsDisplay:YES];
}
@end