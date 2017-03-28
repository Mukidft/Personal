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

@interface UI_GraphView : NSView
{
}

-(void) plotData:(Float32 *) data givenInfos:(SpectrumGraphInfo) infos;
- (void)drawBackground: (NSRect) dirtyRect color: (NSColor*) color;
- (void)drawGraph: (NSPoint *) points fill: (NSColor*) fill stroke: (NSColor*) stroke;

@end

#endif /* UI_GraphView_h */
