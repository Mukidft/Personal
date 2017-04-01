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
    NSPoint mBins[M_BINS];
}

-(void) plotData:(Float32 *) data givenInfos:(SpectrumGraphInfo) infos;
- (void)drawBackground: (NSRect) dirtyRect color: (NSColor*) color;
- (void)drawGraph: (NSColor*) fill stroke: (NSColor*) stroke;
- (void)drawGrid;

@end

#endif /* UI_GraphView_h */
