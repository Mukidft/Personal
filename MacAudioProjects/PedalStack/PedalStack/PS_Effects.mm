/*****************************************************************************/
/*!
 \file   PS_Effects.mm
 \author Deepak Chennakkadan
 \par    email: deepak.chennakkadan\@digipen.edu
 \par    DigiPen login: deepak.chennakkadan
 \par    Course: MUS470
 \par    Project: PedalStack
 \date   12/13/2016
 \brief
 This file contains the implementation for the effects class consisting methods 
 to modify add, remove and modify individual effects.
 */
/*****************************************************************************/

#include "PS_Effects.h"
#include <iostream>

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Class Constructor
 
 \param effect
 (Effect ID)
 
 \param graph
 (Audio Unit Graph)
 
 \param outNode
 (Output Node)
 
 \param streamDesc
 (Audio Stream Basic Description)
 
 \return
 Does not return anything
*/
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
PS_Effects::PS_Effects(UInt32 effect, AUGraph graph, AUNode outNode, AudioStreamBasicDescription streamDesc) : _effectID(effect), _graph(graph), _output(outNode), _streamDesc(streamDesc)
{
    FillDescription();
    AddEffectNode();
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Fills description structure as an effect type
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::FillDescription()
{
    _effectDesc = {kAudioUnitType_Effect, _effectID, kAudioUnitManufacturer_Apple, 0, 0};
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Adds the effect node to the Audio Unit graph
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::AddEffectNode()
{
    _result = AUGraphAddNode(_graph, &_effectDesc, &_effectNode);
    
    ErrorCheck(NodeAdded);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Manages input and output node connections
 
 \param input
 (Input node)
 
 \param output
 (Output node)
 
 \param inBus
 (Input bus number)
 
 \param outBus
 (Output bus number)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::ConnectEffectIO(AUNode input, AUNode output, UInt32 inBus, UInt32 outBus)
{
    _result = AUGraphConnectNodeInput(_graph, input, inBus, output, outBus);
    
    ErrorCheck(NodeConnected);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Disconencts the and removes the effect node from the graph
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::DisconnectEffectIO()
{
    _result = AUGraphDisconnectNodeInput(_graph, _effectNode, 0);
    
    AUGraphRemoveNode(_graph, _effectNode);
    
    ErrorCheck(NodeConnected);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Manages input and output node connections
 
 \param input
 (Input node)
 
 \param output
 (Output node)
 
 \param inBus
 (Input bus number)
 
 \param outBus
 (Output bus number)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::SetEffectParameter(AudioUnitParameterID paramID, AudioUnitParameterValue paramVal)
{
    _result = AudioUnitSetParameter(_effectAU, paramID, kAudioUnitScope_Global, 0, paramVal, 0);
    
    ErrorCheck(NodeParameter);
}

void PS_Effects::SetStreamDescription(AudioUnit outAU)
{
    UInt32 size = sizeof(_streamDesc);
    
    _result = AudioUnitGetProperty(outAU,
                                   kAudioUnitProperty_StreamFormat,
                                   kAudioUnitScope_Input,
                                   0,
                                   &_streamDesc,
                                   &size );
    
    ErrorCheck(NodeGetProperty);
    
    
    _result = AudioUnitSetProperty(_effectAU,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  0,
                                  &_streamDesc,
                                  sizeof(_streamDesc) );
    
    ErrorCheck(NodeSetProperty);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the Audio Unit Node for the Effect
 
 \return
 Returns the effect node
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
AUNode PS_Effects::GetEffectNode()
{
    return _effectNode;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the Audio Unit for the Effect
 
 \return
 Returns the audio unit
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
AudioUnit PS_Effects::GetEffectAU()
{
    return _effectAU;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the effect ID
 
 \return
 Returns the effect ID
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
UInt32 PS_Effects::GetEffectID()
{
    return _effectID;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the Audio Component Description structure for the effect
 
 \return
 Returns the Audio Component Description structure for the effect
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
AudioComponentDescription PS_Effects::GetEffectDescription()
{
    return _effectDesc;
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Gets the node information from the graph
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::GetEffectInfo()
{
    
    _result = AUGraphNodeInfo(_graph, _effectNode, NULL, &_effectAU);
    
    ErrorCheck(NodeInfo);
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Checks for return error codes
 
 \param error
 (Error Code)
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::ErrorCheck(ErrorType error)
{
    if(_result)
    {
        switch(error)
        {
            case NodeAdded:
                printf("Effect Node could not be added! Result: %d\n", _result);
                break;
            case NodeConnected:
                printf("Effect Node could not be connected! Result: %d\n", _result);
                break;
            case NodeInfo:
                printf("Could not get AU Graph Node information! Result: %d\n", _result);
                break;
            case NodeParameter:
                printf("Could not set parameter! Result: %d\n", _result);
                break;
            case NodeSetProperty:
                printf("Could not set property! Result: %d\n", _result);
                break;
            case NodeGetProperty:
                printf("Could not get property! Result: %d\n", _result);
                break;
            default:
                break;
        
        }
    }
}

/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
/*!
 \brief
 Prints out the stream description structure
 
 \return
 Does not return anything
 */
/*+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
void PS_Effects::PrintStreamDescription()
{
    std::cout << "STREAM DESCRIPTION START" << std::endl << std::endl;
    std::cout << "mBitsPerChannel:   " << _streamDesc.mBitsPerChannel << std::endl;
    std::cout << "mBytesPerFrame:    " << _streamDesc.mBytesPerFrame << std::endl;
    std::cout << "mBytesPerPacket:   " << _streamDesc.mBytesPerPacket << std::endl;
    std::cout << "mChannelsPerFrame: " << _streamDesc.mChannelsPerFrame << std::endl;
    std::cout << "mFormateFlags:     " << _streamDesc.mFormatFlags << std::endl;
    std::cout << "mFormatID:         " << _streamDesc.mFormatID << std::endl;
    std::cout << "mFramesPerPacket:  " << _streamDesc.mFramesPerPacket << std::endl;
    std::cout << "mReserved:         " << _streamDesc.mReserved << std::endl;
    std::cout << "mSampelRate:       " << _streamDesc.mSampleRate << std::endl << std::endl << std::endl;
}