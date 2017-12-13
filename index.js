
import { NativeModules } from 'react-native';
const RNReactNativeDocViewer = NativeModules.RNReactNativeDocViewer;
export default {
  openDoc: RNReactNativeDocViewer.openDoc,
  openDocb64: RNReactNativeDocViewer.openDocb64,
  playMovie: RNReactNativeDocViewer.playMovie,
  openDocBinaryinUrl:RNReactNativeDocViewer.openDocBinaryinUrl,
  testModule: RNReactNativeDocViewer.testModule
}
