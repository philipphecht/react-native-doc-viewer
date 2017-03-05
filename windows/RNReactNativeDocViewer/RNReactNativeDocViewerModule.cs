using ReactNative.Bridge;
using System;
using System.Collections.Generic;
using Windows.ApplicationModel.Core;
using Windows.UI.Core;

namespace Com.Reactlibrary.RNReactNativeDocViewer
{
    /// <summary>
    /// A module that allows JS to share data.
    /// </summary>
    class RNReactNativeDocViewerModule : NativeModuleBase
    {
        /// <summary>
        /// Instantiates the <see cref="RNReactNativeDocViewerModule"/>.
        /// </summary>
        internal RNReactNativeDocViewerModule()
        {

        }

        /// <summary>
        /// The name of the native module.
        /// </summary>
        public override string Name
        {
            get
            {
                return "RNReactNativeDocViewer";
            }
        }
    }
}
