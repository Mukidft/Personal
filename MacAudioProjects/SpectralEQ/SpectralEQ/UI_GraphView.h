//
//  UI_GraphView.h
//  SpectralEQ
//
//  Created by Owl on 2/16/17.
//  Copyright © 2017 DeepakChennakkadan. All rights reserved.
//

#ifndef UI_GraphView_h
#define UI_GraphView_h

#import <Foundation/Foundation.h>
#import <AppKit/NSView.h>
#import "SpectralEQDefinitions.h"

#define M_BINS 512

@interface UI_GraphView : NSView
{
    NSPoint mBins_Wet[M_BINS];
    NSPoint mBins_Dry[M_BINS];
}

- (void) plotData:(Float32 *) WetData WetInfos:(SpectrumGraphInfo) WetInfos DryData: (Float32 *) DryData DryInfos:(SpectrumGraphInfo) DryInfos;
- (void)drawBackground: (NSRect) dirtyRect color: (NSColor*) color;
- (void)drawWetGraph: (NSColor*) fill stroke: (NSColor*) stroke;
- (void)drawDryGraph: (NSColor*) fill stroke: (NSColor*) stroke;
- (void)drawGrid;

@end

#endif /* UI_GraphView_h */
