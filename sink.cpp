#include <stdio.h>
#include <math.h>
#include <queue>
#include "portaudio.h"
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include "argtable3.h"
#include <string>

#define SAMPLE_RATE   (44100)
#define FRAMES_PER_BUFFER  (512)

#ifndef M_PI
#define M_PI  (3.14159265)
#endif
#define TWOPI (M_PI * 2.0)

#define TABLE_SIZE   (1024)

typedef struct paTestData { std::queue<float> * bufferptr; } paTestData;

PaError checkErr(PaError err);

static int patestCallback(const void* inputBuffer, void* outputBuffer, unsigned long framesPerBuffer, const PaStreamCallbackTimeInfo* timeInfo, PaStreamCallbackFlags statusFlags, void* userData ) {

    paTestData *data = (paTestData*)userData;
    float *out = (float*)outputBuffer;
    float outSample;
    (void) inputBuffer; /* Prevent unused argument warning. */

    for( unsigned long i=0; i<framesPerBuffer; i++ ) {
        float output = 0.0;
        std::queue<float> * bufferptr = data->bufferptr;
        if (!bufferptr->empty()) {
            output = bufferptr->front();
            bufferptr->pop();
        }
        /* else { */
	        /* output = fmod((float) i/(128), 2.0) - 1.0; */
        /* } */
        outSample = (float) (output * 0.1);
        *out++ = outSample; /* Left */
        *out++ = outSample; /* Right */
    }
    return 0;
}


/* double note(double x) { */
/*     for (int j=0; j < 2; j++) { */
/*         for (unsigned long i=1; i < 2410; i++) { buffer.push( (float) sin( i / 16.0 )); } */
/*         for (unsigned long i=1; i < 2410; i++) { buffer.push( 0.0 ); } */
/*     } */
/*     for (unsigned long i=1; i < 4410; i++) { buffer.push( (float) sin( i / 4.0 )); } */
/*     return 1.0; */
/* }; */
extern double afunc(double x) {
    printf("Hello World");
    return (0.5 * x);
}

int main(int argc, char **argv) {
    std::queue<float> buffer;

    for (int j=0; j < 2; j++) {
        for (unsigned long i=1; i < 2410; i++) { buffer.push( (float) sin( i / 16.0 )); }
        for (unsigned long i=1; i < 2410; i++) { buffer.push( 0.0 ); }
    }
    for (unsigned long i=1; i < 4410; i++) { buffer.push( (float) sin( i / 4.0 )); }

    PaStream*           stream;
    PaStreamParameters  outputParams;
    PaError             err;
    paTestData          data;

    data.bufferptr = &buffer;

    checkErr(Pa_Initialize());

    outputParams.device                    = Pa_GetDefaultOutputDevice();
    if (outputParams.device == paNoDevice) { fprintf(stderr,"Error: No default output device.\n"); Pa_Terminate(); }
    outputParams.channelCount              = 2;
    outputParams.sampleFormat              = paFloat32;
    outputParams.hostApiSpecificStreamInfo = NULL;
    outputParams.suggestedLatency          = Pa_GetDeviceInfo(outputParams.device) ->defaultHighOutputLatency;
    checkErr(Pa_OpenStream(&stream, NULL, &outputParams, SAMPLE_RATE, FRAMES_PER_BUFFER, paClipOff, patestCallback, &data));
    checkErr(Pa_StartStream( stream ));

    /* float x; */
    /* while (1) { */
    /*     in = fopen(fifo_name, "rb"); */
    /*     printf("yes in"); */
    /*     if (in) { */
    /*         while (fread(&x, sizeof(x), 1, in) > 0) { */
    /*             buffer.push(x); */
    /*         } */
    /*     } */
    /*     fclose(in); */
    /* } */
    while (1) {};

    checkErr(Pa_StopStream( stream ));
    checkErr(Pa_CloseStream( stream ));

    Pa_Terminate();
    return err;
}

PaError checkErr(PaError err) {
    if ( err != paNoError ) {
	    Pa_Terminate();
	    fprintf( stderr, "An error occurred while using the portaudio stream\n" );
    	fprintf( stderr, "Error number: %d\n", err );
    	fprintf( stderr, "Error message: %s\n", Pa_GetErrorText( err ) );
    }
    return err;
}
