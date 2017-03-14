
import { NativeModules } from 'react-native';
const RNReactNativeDocViewer = NativeModules.RNReactNativeDocViewer;
export default {
  openDoc: RNReactNativeDocViewer.open,
  testModule: RNReactNativeDocViewer.testModule
}
