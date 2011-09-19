//
//  choppedScrewedViewController.m
//  choppedScrewed
//
//  Created by Baek Chang on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "choppedScrewedViewController.h"
#import "mo_audio.h"

#define SRATE 44100
#define FRAMESIZE 256
#define NUM_CHANNELS 2

double g_fc = 440.0; 

void audioCallback( Float32 * buffer, UInt32 framesize, void* userData);

// Implement audio callback here
void audioCallback( Float32 * buffer, UInt32 framesize, void* userData)
{
    InMemoryAudioFile *audioFile = (InMemoryAudioFile *) userData;
    audioFile->getAudioFrames(framesize);
    
    // use 2 channels, fix it up later
    for (int i = 0; i < 2*framesize; i++) {
        buffer[i] = audioFile->audioData[i];
    }
}

@implementation choppedScrewedViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    MoAudio::init(SRATE, FRAMESIZE, NUM_CHANNELS);

    inMemoryAudioFile = new(InMemoryAudioFile);
    inMemoryAudioFile->open([[NSBundle mainBundle] pathForResource:@"04-Eyesdown-float" ofType:@"wav"], FRAMESIZE);
    
    MoAudio::start(audioCallback, inMemoryAudioFile);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    // remove resources for audio file
    delete inMemoryAudioFile;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
