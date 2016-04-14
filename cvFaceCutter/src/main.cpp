#include "ofMain.h"
#include "ofApp.h"

//========================================================================
int main(int argc, char *argv[]){

	ofSetupOpenGL(1024,680, OF_WINDOW);			// <-------- setup the GL context
    ofApp *app = new ofApp();
	app->arguements = vector<string>(argv, argv + argc);
    ofRunApp(app);

}
