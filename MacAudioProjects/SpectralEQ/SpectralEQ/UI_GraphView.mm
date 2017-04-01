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
    [self drawGraph:[NSColor colorWithDeviceRed:0 green:255 blue:255 alpha:0.3] stroke: [NSColor cyanColor]];
    
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
    
    for(int i = 1; i < M_BINS; ++i)
    {
        CGPoint point;
        
        point.x = ((mBins[i].x - mBins[1].x) / (mBins[M_BINS - 1].x - mBins[1].x)) * (size.width - 0) + 0;
        point.y = size.height;
        
        [path lineToPoint:NSMakePoint(point.x, size.height)];
    }
}

- (void)drawGraph: (NSColor*) fill stroke: (NSColor*) stroke
{
    NSBezierPath* path = [NSBezierPath bezierPath];
    
    NSSize size = [self bounds].size;
    
    [path moveToPoint:NSMakePoint(0, 0)];
    
    if(mBins[1].x != 0)
    {
        for(int i = 1; i < M_BINS; i++)
        {
            //std::cout << mBins[i].x << "     " << mBins[i].y << std::endl;
            
            CGPoint point;
            
            point.x = ((mBins[i].x - mBins[1].x) / (mBins[M_BINS - 1].x - mBins[1].x)) * (size.width - 0) + 0;
            point.y = ((mBins[i].y - (-150)) / (6 - (-150))) * (size.height - 0) + 0;
            
            
            //std::cout << point.x << "     " << point.y << std::endl;
            //Result := ((Input - InputLow) / (InputHigh - InputLow)) * (OutputHigh - OutputLow) + OutputLow;
            
            if(point.x > 0 && point.x < size.width && point.y > 0 && point.y < size.height)
                [path lineToPoint:NSMakePoint(point.x, point.y - 100)];
        }
    }
    
    [path lineToPoint:NSMakePoint(size.width, 0)];
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
        
        mBins[i] = point;
    }
    
    [self setNeedsDisplay:YES];
}
@end