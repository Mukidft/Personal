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
    [self drawGrid];
    [self drawWetGraph:[NSColor colorWithDeviceRed:0 green:255 blue:255 alpha:0.15] stroke: [NSColor cyanColor]];
    [self drawDryGraph:[NSColor colorWithDeviceRed:255 green:0 blue:0 alpha:0.1] stroke: [NSColor orangeColor]];
}

- (void)drawBackground: (NSRect) dirtyRect color: (NSColor*) color;
{
    [color set];
    NSRectFill(dirtyRect);
}

- (void)drawGrid
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    NSSize size = [self bounds].size;
    
    if(mBins_Wet[1].x != 0)
    {
        for(int i = 0; i < size.width; i+=30)
        {
            CGPoint point;
        
            point.x = i;
            point.y = size.height;
            [path moveToPoint:NSMakePoint(point.x, 0)];
            [path lineToPoint:NSMakePoint(point.x, point.y)];
            [path closePath];
            [[NSColor colorWithDeviceRed:255 green:0 blue:255 alpha:0.006] set];
            [path stroke];
            
            point.x = size.width;
            point.y = i;
            [path moveToPoint:NSMakePoint(0, point.y)];
            [path lineToPoint:NSMakePoint(point.x, point.y)];
            [path closePath];
            [[NSColor colorWithDeviceRed:255 green:255 blue:0 alpha:0.006] set];
            [path stroke];
        }
    }
}

- (void)drawWetGraph: (NSColor*) fill stroke: (NSColor*) stroke
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    NSSize size = [self bounds].size;
    
    [path moveToPoint:NSMakePoint(0, 0)];
    
    if(mBins_Wet[1].x != 0)
    {
        for(int i = 4; i < M_BINS; i++)
        {
            CGPoint point;
            
            //Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
            point.x = ((mBins_Wet[i].x - mBins_Wet[1].x) / (mBins_Wet[M_BINS - 1].x - mBins_Wet[1].x)) * (size.width - 0) + 0;
            point.y = ((mBins_Wet[i].y - (-150)) / (6 - (-150))) * (size.height - 0) + 0;
            
            if(point.x > 0 && point.x < size.width && point.y > 0 && point.y < size.height)
                [path lineToPoint:NSMakePoint(point.x, point.y - 80)];
        }
    }
    
    [path lineToPoint:NSMakePoint(size.width, 0)];
    [path closePath];
    [fill set];
    [path fill];
    [stroke set];
    [path stroke];
}

- (void)drawDryGraph: (NSColor*) fill stroke: (NSColor*) stroke
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    NSSize size = [self bounds].size;
    
    [path moveToPoint:NSMakePoint(0, 0)];
    
    if(mBins_Dry[1].x != 0)
    {
        for(int i = 1; i < M_BINS; i++)
        {
            CGPoint point;
            
            //Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
            point.x = ((mBins_Dry[i].x - mBins_Dry[1].x) / (mBins_Dry[M_BINS - 1].x - mBins_Dry[1].x)) * (size.width - 0) + 0;
            point.y = ((mBins_Dry[i].y - (-150)) / (6 - (-150))) * (size.height - 0) + 0;
            
            if(point.x > 0 && point.x < size.width && point.y > 0 && point.y < size.height)
                [path lineToPoint:NSMakePoint(point.x, point.y - 80)];
        }
    }
    
    [path lineToPoint:NSMakePoint(size.width, 0)];
    [path closePath];
    [fill set];
    [path fill];
    [stroke set];
    [path stroke];
}

- (void) plotData:(Float32 *) WetData WetInfos:(SpectrumGraphInfo) WetInfos DryData: (Float32 *) DryData DryInfos:(SpectrumGraphInfo) DryInfos
{   
    for (UInt32  i = 0; i < WetInfos.mNumBins; i++)
    {
        double bin = i * (double) WetInfos.mSamplingRate / (double)(WetInfos.mNumBins * 2);
        
        NSPoint point;
        point.x = (CGFloat) bin;
        point.y = WetData[i];
        
        mBins_Wet[i] = point;
    }
    
    for (UInt32  i = 0; i < DryInfos.mNumBins; i++)
    {
        double bin = i * (double) DryInfos.mSamplingRate / (double)(DryInfos.mNumBins * 2);
        
        NSPoint point;
        point.x = (CGFloat) bin;
        point.y = DryData[i];
        
        mBins_Dry[i] = point;
    }
    
    [self setNeedsDisplay:YES];
}
@end