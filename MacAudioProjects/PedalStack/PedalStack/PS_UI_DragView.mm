/*****************************************************************************/
/*!
 \file   PS_UI_DropView.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for a Custom Drop View class for Drag 
 & Drop
 */
/*****************************************************************************/


#import "PS_UI_DragView.h"

@implementation PS_UI_DragView

NSString *kPrivateDropUTI = @"com.Deepak.PedalStack";

- (id)initWithCoder:(NSCoder *)coder
{
    self=[super initWithCoder:coder];
    
    if ( self )
    {
        [self registerForDraggedTypes:[NSImage imageTypes]];
    }
    
    return self;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets valid pasteboard type
 
 \return
 Returns a valid pasteboard type
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+ (NSString*)pasteboardType
{
    return kPrivateDropUTI;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets an array with valid pasteboard type
 
 \return
 Returns an array with valid pasteboard type
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
+ (NSArray*)pasteboardTypes
{
    return [NSArray arrayWithObject:[self pasteboardType]];
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Sets the name of the effect dropped in
 
 \param name
 (Name of the effect)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
- (void)setName: (NSString *) name
{
    effect_name = name;
}

- (void)mouseDown:(NSEvent*)event
{
    /*------------------------------------------------------
     catch mouse down events in order to start drag
     --------------------------------------------------------*/
    
    /* Dragging operation occur within the context of a special pasteboard (NSDragPboard).
     * All items written or read from a pasteboard must conform to NSPasteboardWriting or
     * NSPasteboardReading respectively.  NSPasteboardItem implements both these protocols
     * and is as a container for any object that can be serialized to NSData. */
    
    NSPasteboardItem *pbItem = [NSPasteboardItem new];
    /* Our pasteboard item will support public.tiff, public.pdf, and our custom UTI (see comment in -draggingEntered)
     * representations of our data (the image).  Rather than compute both of these representations now, promise that
     * we will provide either of these representations when asked.  When a receiver wants our data in one of the above
     * representations, we'll get a call to  the NSPasteboardItemDataProvider protocol method –pasteboard:item:provideDataForType:. */
    [pbItem setDataProvider:self forTypes:[[self class] pasteboardTypes]];
    
    //create a new NSDraggingItem with our pasteboard item.
    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    [pbItem release];
    
    /* The coordinates of the dragging frame are relative to our view.  Setting them to our view's bounds will cause the drag image
     * to be the same size as our view.  Alternatively, you can set the draggingFrame to an NSRect that is the size of the image in
     * the view but this can cause the dragged image to not line up with the mouse if the actual image is smaller than the size of the
     * our view. */
    NSRect draggingRect = self.bounds;
    
    /* While our dragging item is represented by an image, this image can be made up of multiple images which
     * are automatically composited together in painting order.  However, since we are only dragging a single
     * item composed of a single image, we can use the convince method below. For a more complex example
     * please see the MultiPhotoFrame sample. */
    [dragItem setDraggingFrame:draggingRect contents:[self image]];
    
    //create a dragging session with our drag item and ourself as the source.
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:[NSArray arrayWithObject:[dragItem autorelease]] event:event source:self];
    //causes the dragging item to slide back to the source if the drag fails.
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    
    draggingSession.draggingFormation = NSDraggingFormationNone;
}

- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    /*------------------------------------------------------
     NSDraggingSource protocol method.  Returns the types of operations allowed in a certain context.
     --------------------------------------------------------*/
    switch (context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationCopy;
            
            //by using this fall through pattern, we will remain compatible if the contexts get more precise in the future.
        case NSDraggingContextWithinApplication:
        default:
            return NSDragOperationCopy;
            break;
    }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    /*------------------------------------------------------
     accept activation click as click in window
     --------------------------------------------------------*/
    //so source doesn't have to be the active window
    return YES;
}

- (void)pasteboard:(NSPasteboard *)sender item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    /*------------------------------------------------------
     method called by pasteboard to support promised
     drag types.
     --------------------------------------------------------*/
    //sender has accepted the drag and now we need to send the data for the type we promised
    
    if ( [type compare: [[self class] pasteboardType]] == NSOrderedSame )
    {
        [sender setData:[effect_name dataUsingEncoding: NSASCIIStringEncoding] forType: [[self class] pasteboardType]];
    }
}
@end