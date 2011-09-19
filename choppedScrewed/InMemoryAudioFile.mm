//
//  InMemoryAudioFile.mm
//  choppedScrewed
//
//  Created by Baek Chang on 9/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "InMemoryAudioFile.h"

InMemoryAudioFile::InMemoryAudioFile() {
    packetIndex = 0;
}

InMemoryAudioFile::~InMemoryAudioFile() {
    if (audioData)
        free(audioData);            
}

OSStatus InMemoryAudioFile::open (NSString *filePath, UInt16 frameSize) {
	
	NSLog(@"FilePath: ");
	NSLog(@"%@", [NSString stringWithFormat:@"%@", filePath]);
    
	//get a ref to the audio file, need one to open it
	CFURLRef audioFileURL = CFURLCreateFromFileSystemRepresentation (NULL, (const UInt8 *)[filePath cStringUsingEncoding:[NSString defaultCStringEncoding]] , strlen([filePath cStringUsingEncoding:[NSString defaultCStringEncoding]]), false);
	
	//open the audio file
	OSStatus result = AudioFileOpenURL (audioFileURL, 0x01, 0, &mAudioFile);
	//were there any errors reading? if so deal with them first
	if (result != noErr) {
		NSLog(@"%@", [NSString stringWithFormat:@"Could not open file: %s", filePath]);
		packetCount = -1;
	} else {
		//get the file info
		getFileInfo();

		//how many packets read? (packets are the number of stereo samples in this case)
		NSLog(@"%@", [NSString stringWithFormat:@"File Opened, packet Count: %d", packetCount]);
        
		//if we didn't get any packets dop nothing, nothing to read
		//otherwise fill our in memory audio buffer with the whole file (i wouldnt use this with very large files btw)
		if (packetCount > 0) {
			// allocate the buffer
            // forcing to two channels right now, fix it up laters
			audioData = (Float32 *)malloc(sizeof(Float32) * 2 * frameSize);
        }
	}
    
	CFRelease (audioFileURL);     
    
	return result;
}

OSStatus InMemoryAudioFile::getFileInfo (void) {
	
	OSStatus	result = -1;
	double duration;
	
	if (mAudioFile != NULL) {
		UInt32 dataSize = sizeof packetCount;
		result = AudioFileGetProperty(mAudioFile, kAudioFilePropertyAudioDataPacketCount, &dataSize, &packetCount);
		if (result==noErr)
			duration = ((double)packetCount * 2) / 44100;
        else
			packetCount = -1;
	}
    
	return result;
}

void InMemoryAudioFile::getAudioFrames (UInt32 frames) {
    OSStatus result;
    UInt32 framesRead = 0;

    if (packetIndex >= packetCount){
		packetIndex = 0;
		NSLog(@"Reset player to beginning of file.");
	}
    
    result = AudioFileReadPackets (mAudioFile, false, &framesRead, NULL, packetIndex, &frames, audioData); 
    if (result == noErr)
        packetIndex += frames;
    else
        NSLog(@"Error occured %ld", result);
}                                        

SInt64 InMemoryAudioFile::getIndex (void) {
	return packetIndex;
}

void InMemoryAudioFile::reset(void) {
	packetIndex = 0;
}

