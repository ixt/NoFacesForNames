#pragma once

#include "ofMain.h"
#include "ofxCvHaarFinder.h"

class ofApp : public ofBaseApp{
	public:
		void setup();
		void update();
		void draw();

        vector<string> arguements;

		vector<ofImage> images;
        vector<ofFile> filePaths;
		vector<ofxCvHaarFinder> finder;

};
