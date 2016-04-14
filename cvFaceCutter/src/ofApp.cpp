#include "ofApp.h"

//   _ \  _ \    _ \  \ | __| __ __||  |_ _|  \ |  __| 
//   |  |(   |  (   |.  | _|     |  __ |  |  .  | (_ | 
//  ___/\___/  \___/_|\_|___|   _| _| _|___|_|\_|\___| 
//                                                    
// 
//                     \    \ | _ \
//                    _ \  .  | |  | 
//                  _/  _\_|\_|___/  
//                                   
// 
//       _ \  _ \  _ _|__ __| \ \      /__| |    |    
//       |  |(   |   |    |    \ \ \  / _|  |    |    
//      ___/\___/  ___|  _|     \_/\_/ ___|____|____| 
//                                               

bool going = true;

//--------------------------------------------------------------
void ofApp::setup(){
    // close app if no arguments
    if (arguements.size() == 1){
        cout << "No arguments" << endl;
        ofExit();
    }
    
    // take in the arguments checking for images 
    for (unsigned int file = 1; file < arguements.size(); file++){
        std::string arguement = arguements[file];
        ofFile image;
        image.open(arguement.c_str());
        std::string fileType = image.getExtension();

        if (fileType.compare("jpg") == 0 || fileType.compare("png") == 0 || fileType.compare("bmp") == 0) {
            images.push_back(ofImage(image));
            filePaths.push_back(image);
        }
    }

    // close app if no images 
    if (images.empty()){
        cout << "No images" << endl;
        ofExit();
    }

    for (unsigned int image = 0; image < images.size(); image++){
        ofxCvHaarFinder haar;
        haar.setup("haarcascade_frontalface_default.xml");
        finder.push_back(haar);
        ofImage temp;
        temp = images[image];
        temp.resize(temp.getWidth()/4,temp.getHeight()/4);
	    images[image] = temp;
	    finder[image].findHaarObjects(images[image]);

    }
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::draw(){
    for (unsigned int image = 0; image < images.size(); image++){
	    images[image].draw(0, 0);
	    ofNoFill();
        if (finder[image].blobs.size() < 1)
            continue;
        vector<ofImage> faces;
        cout << finder[image].blobs.size() << endl;
	    for(unsigned int i = 0; i < finder[image].blobs.size(); i++) {
            ofImage face; 
	    	ofRectangle cur = finder[image].blobs[i].boundingRect;
	    	ofDrawRectangle(cur.x, cur.y, cur.width, cur.height);
            face.cropFrom(images[image], cur.x, cur.y, cur.width, cur.height);
            faces.push_back(face);
	    }

        int location = images[image].getHeight();
        for(unsigned int i = 0; i < faces.size(); i++){
            ofImage face = faces[i];
            ofPixels tempPix;
            tempPix = face.getPixels();
            tempPix.resize(384,384,OF_INTERPOLATE_NEAREST_NEIGHBOR);
            face.setFromPixels(tempPix);
            face.setImageType(OF_IMAGE_GRAYSCALE);
            face.draw(0,location);
            location += 384;
            // make a new file
            ofFile faceOutput = ofFile(filePaths[image].path().substr(0, filePaths[image].path().find_last_of('.')) + string("-") + to_string(i) + string(".png"));
            if (faceOutput.exists()){
                cout << "hello! " << faceOutput.path() <<  endl; 
            } else {
                face.save(faceOutput.path(),OF_IMAGE_QUALITY_BEST);  
            }
        }
    }
    ofExit();
}

