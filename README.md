
# react-native-doc-viewer


A React Native bridge module: Document Viewer for files (pdf, png, jpg, xls, doc, ppt, xlsx, docx, pptx etc.)

![nodei.co](https://nodei.co/npm/react-native-doc-viewer.png?downloads=true&downloadRank=true&stars=true)


Changelog:

```
2.3.8  -  Method openDocBinaryinUrl for Binary in Url

2.3.2   - Video Player mp4 IOS

2.2.4   - Base64 String Support for IOS

2.2.3 - Android Doc Viewer Implementation. At the moment you have to install a Application that supports the Format

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


## Usage
```javascript
import OpenFile from 'react-native-doc-viewer';
var RNFS = require('react-native-fs');
var SavePath = Platform.OS === 'ios' ? RNFS.MainBundlePath : RNFS.DocumentDirectoryPath;

  /*
  * Handle WWW File Method
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url the File Extension is missing.
  */
  handlePress = () => {
   OpenFile.openDoc([{
     url:"http://www.snee.com/xml/xslt/sample.doc",
     fileName:"sample"
   }], (error, url) => {
      if (error) {
        console.error(error);
      } else {
        console.log(url)
      }
    })
  }

  /*
  * Binary in URL
  * Binary String in Url
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressBinaryinUrl = () => {
   OpenFile.openDocBinaryinUrl([{
     url:"http://mail.hartl-haus.at/uploads/tx_hhhouses/{binaryString}",
     fileName:"sample",
     fileType:"jpg"
   }], (error, url) => {
      if (error) {
        console.error(error);
      } else {
        console.log(url)
      }
    })
  }
  
  /*
  * Handle local File Method
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressLocalFile = () => {
    OpenFile.openDoc([{
     url:SavePath+"filename.pdf",
     fileName:"sample",
   }], (error, url) => {
      if (error) {
        console.error(error);
      } else {
        console.log(url)
      }
    })
  }

  /*
  * Base64String
  * put only the base64 String without data:application/octet-stream;base64
  * fileType Default == "" you can use it, to set the File Extension (pdf,doc,xls,ppt etc) when in the Url you dont have an File Extensions
  */
  handlePressb64 = () => {
    OpenFile.openDocb64([{
      base64:"{BASE64String}"
      fileName:"sample.png",
      fileType:""
    }], (error, url) => {
        if (error) {
          console.error(error);
        } else {
          console.log(url)
        }
      })
  }
  
  
   <Button
          onPress={this.handlePress.bind(this)}
          title="Press Me Open Doc Url"
          accessibilityLabel="See a Document"
        />
        <Button
          onPress={this.handlePressb64.bind(this)}
          title="Press Me Open Doc Base64"
          accessibilityLabel="See a Document"
        />
```


## Screenshots

![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot.png "Screenshot 1")


![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot1.png "Screenshot 2")


![Alt text](https://raw.githubusercontent.com/philipphecht/react-native-doc-viewer/master/Screenshots/Screenshot2.png "Screenshot 3")


### ROADMAP
 * Android Quicklook support without an external application
 * Base64StringtoFile Android
 * Windows Support 
 
 Copyright (c) 2017-present, Philipp Hecht
 philipp.hecht@icloud.com


  