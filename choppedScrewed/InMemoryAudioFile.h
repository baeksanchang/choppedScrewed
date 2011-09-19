//
//  InMemoryAudioFile.h
//  choppedScrewed
//
//  Created by Baek Chang on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#ifndef __IN_MEMORY_AUDIO_FILE_H__
#define __IN_MEMORY_AUDIO_FILE_H__

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

class InMemoryAudioFile
{
public:
    // constructor
    InMemoryAudioFile();

    // descrutctor
    ~InMemoryAudioFile();
    
    //opens a wav file
    OSStatus open (NSString *filePath, UInt16 frameSize);

    //gets the infor about a wav file, stores it locally
    OSStatus getFileInfo (void);
    
    // Get next frame buffer and store it in audioData buffer
    void getAudioFrames (UInt32 frames);
    
    //gets the current index (where we are up to in the buffer)
    SInt64 getIndex (void);
    
    //reset the index to the start of the file
    void reset (void);
    
//    SInt16                          mChannels;
//    SInt32                          mSampleRate;
//    AudioConverterRef               *mAudioConvertor;
    
//    UInt32							bufferByteSize;                 
//    SInt64							mCurrentPacket;                 
//    UInt32							mNumPacketsToRead;              
//    AudioStreamBasicDescription		mDataFormat;                    
//    AudioStreamPacketDescription	*mPacketDescs;                  

    AudioFileID						mAudioFile;                     
	Float32							*audioData;
	SInt64							packetIndex;
	SInt64							packetCount;
};

#endif //__IN_MEMORY_AUDIO_FILE_H__