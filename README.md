
# react-native-doc-viewer [![npm version](https://img.shields.io/npm/v/react-native-doc-viewer.svg?style=flat)](https://www.npmjs.com/package/react-native-doc-viewer)

![nodei.co](https://nodei.co/npm/react-native-doc-viewer.png?downloads=true&downloadRank=true&stars=true)

A React Native bridge module: Document Viewer for files (pdf, png, jpg, xls, doc, ppt, xlsx, docx, pptx etc.)

#### 2017 Roadmap
- Loading Spinner for big Files IOS and Android
#### 2018 Roadmap
- Android file without external Application
- Loading Spinner for big Files Android
- Windows Phone Support

#### IMPORTANT INFORMATION: THIS IS A OPEN SOURCE PROJECT, SOMETIMES I HAVE NO TIME TO DEVELOP THIS PROJECT. THANK YOU FOR YOUR PULL REQUEST AND YOUR SUPPORT. I will continue to develop it as it is possible in time.




Changelog:

```
2.6.0 -   Android Openbase64
2.5.2 -   OpenDocAndroid
2.5.1 -   Cleanings
2.5.0  -  Update Project for React Native 0.50.3

```


## Getting started

`$ npm install react-native-doc-viewer --save`

### Automatic installation

`$ react-native link react-native-doc-viewer`


### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-doc-viewer` and add `RNReactNativeDocViewer.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeDocViewer.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Linked Frameworks and Libraries must have this 2 Libraries (AssetsLibrary.framework & QuickLock.framework). When not you have to add them.

   ![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/screenshot_xcode_addlibrary.png "Xcode add Library")
   
   ![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/screenshot_xcode_addlibrary2.png "Xcode add Library")
   
5.  When you Show http Links don't forget to set APP Transport Security Settings ->
    Allow Arbitrary Loads to YES

![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/plist_file.png "Plist")
   
6. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNReactNativeDocViewerPackage;` to the imports at the top of the file
  - Add `new RNReactNativeDocViewerPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-doc-viewer'
  	project(':react-native-doc-viewer').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-doc-viewer/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-doc-viewer')
  	```

#### Windows on the Roadmap
[Read it! :D](https://github.com/ReactWindows/react-native)

1. In Visual Studio add the `RNReactNativeDocViewer.sln` in `node_modules/react-native-react-native-doc-viewer/windows/RNReactNativeDocViewer.sln` folder to their solution, reference from their app.
2. Open up your `MainPage.cs` app
  - Add `using Com.Reactlibrary.RNReactNativeDocViewer;` to the usings at the top of the file
  - Add `new RNReactNativeDocViewerPackage()` to the `List<IReactPackage>` returned by the `Packages` method


## API DOC
### IOS Document Viewer Doc

| resource                    | description                       |
|:----------------------------|:----------------------------------|
| `openDoc`      | {url:String,fileNameOptional:String (optional)} |
| `openDocb64`| {url:String,fileName:String,fileType:String }|
| `openDocBinaryinUrl` | {url:String,fileName:String,fileType:String } |

### Android Document Viewer Doc

| resource                    | description                       |
|:----------------------------|:----------------------------------|
| `openDoc`      | {url:String,fileName:String, cache:boolean} |
| `openDocb64`| {url:String,fileName:String,fileType:String, cache:boolean }|
| `openDocBinaryinUrl` | not implemented yet |

## Usage
```javascript
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Platform,
  Button,
  Alert
} from 'react-native';
import OpenFile from 'react-native-doc-viewer';
var RNFS = require('react-native-fs');
var SavePath = Platform.OS === 'ios' ? RNFS.MainBundlePath : RNFS.DocumentDirectoryPath;

  /*
  * Handle WWW File Method
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url the File Extension is missing.
  */
  handlePress = () => {
   if(Platform.OS === 'ios'){
      //IOS
      OpenFile.openDoc([{
        url:"https://www.cmu.edu/blackboard/files/evaluate/tests-example.xls",
        fileNameOptional:"sample-test"
      }], (error, url) => {
         if (error) {
           console.error(error);
         } else {
           console.log(url)
         }
       })
    }else{
      //Android
      OpenFile.openDoc([{
        url:"http://mail.hartl-haus.at/uploads/tx_hhhouses/htf13_classic153s(3_giebel_haus).jpg", // Local "file://" + filepath
        fileName:"sample",
        cache:false,
        fileType:"jpg"
      }], (error, url) => {
         if (error) {
           console.error(error);
         } else {
           console.log(url)
         }
       })
    }
  }

  /*
  * Binary in URL
  * Binary String in Url
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressBinaryinUrl = () => {
    if(Platform.OS === 'ios'){
      //IOS
      OpenFile.openDocBinaryinUrl([{
        url:"https://storage.googleapis.com/need-sure/example",
        fileName:"sample",
        fileType:"xml"
      }], (error, url) => {
          if (error) {
            console.error(error);
          } else {
            console.log(url)
          }
        })
    }else{
      //Android
      Alert.alert("Coming soon for Android")
    }
  }
  
  /*
  * Handle local File Method
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressLocalFile = () => {
    if(Platform.OS === 'ios'){
        OpenFile.openDoc([{
        url:SavePath+"filename.pdf",
        fileName:"sample",
        fileType:"",
        fileExt:""
      }], (error, url) => {
          if (error) {
            console.error(error);
          } else {
            console.log(url)
          }
        })
    }else{
      //Android
      OpenFile.openDoc([{
        url:SavePath+"filename.pdf",
        fileName:"sample",
        cache:true /*Use Cache Folder Android*/
      }], (error, url) => {
          if (error) {
            console.error(error);
          } else {
            console.log(url)
          }
        })
    }
  }

  /*
  * Base64String
  * put only the base64 String without data:application/octet-stream;base64
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressb64 = () => {
    if(Platform.OS === 'ios'){
      OpenFile.openDocb64([{
        base64:"{BASE64String}"
        fileName:"sample",
        fileType:"png"
      }], (error, url) => {
          if (error) {
            console.error(error);
          } else {
            console.log(url)
          }
        })
    }else{
      //Android
      OpenFile.openDocb64([{
        base64:"{BASE64String}"
        fileName:"sample",
        fileType:"png",
        cache:true /*Use Cache Folder Android*/
      }], (error, url) => {
          if (error) {
            console.error(error);
          } else {
            console.log(url)
          }
        })
    }
    
    /*
  * Video File
  */
  handlePressVideo = () => {
    if(Platform.OS === 'ios'){
      OpenFile.playMovie(video, (error, url) => {
                if (error) {
                    console.error(error);
                } else {
                    console.log(url)
                }
            })
    }else{
      Alert.alert("Android coming soon");
    }
  }
  
  
  <Button
          onPress={this.handlePress.bind(this)}
          title="Press Me Open Doc Url"
          accessibilityLabel="See a Document"
        />
        <Button
          onPress={this.handlePressBinaryinUrl.bind(this)}
          title="Press Me Open BinaryinUrl"
          accessibilityLabel="See a Document"
        />
        <Button
          onPress={this.handlePressb64.bind(this)}
          title="Press Me Open Base64 String"
          accessibilityLabel="See a Document"
        />
        <Button
          onPress={()=>this.handlePressVideo("http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4")}
          title="Press Me Open Video"
          accessibilityLabel="See a Document"
        />
```


## Screenshots

![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot.png "Screenshot 1")


![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot1.png "Screenshot 2")


![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot2.png "Screenshot 3")

 
 Copyright (c) 2017-present, Philipp Hecht
 philipp.hecht@icloud.com


  
