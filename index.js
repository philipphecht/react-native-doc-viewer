
import { NativeModules } from 'react-native';
const RNReactNativeDocViewer = NativeModules.RNReactNativeDocViewer;
export default {
  open: RNReactNativeDocViewer.open,
  //addEvent: RNReactNativeDocViewer.addEvent
}
