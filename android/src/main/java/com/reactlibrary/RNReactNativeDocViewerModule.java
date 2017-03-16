package com.reactlibrary;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;
//Third Libraries
import java.io.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.webkit.CookieManager;
import android.webkit.MimeTypeMap;

public class RNReactNativeDocViewerModule extends ReactContextBaseJavaModule {
  public static final int ERROR_NO_HANDLER_FOR_DATA_TYPE = 53;
  public static final int ERROR_FILE_NOT_FOUND = 2;
  public static final int ERROR_UNKNOWN_ERROR = 1;
  private final ReactApplicationContext reactContext;

  public RNReactNativeDocViewerModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNReactNativeDocViewer";
  }
    
  @ReactMethod
  public void openDoc(WritableNativeArray args, Callback callback) {
      try {
        final WritableNativeMap arg_object = args;
        System.out.println("Found: " + arg_object);
        /*if (arg_object.getString("url") != null && arg_object.getString("fileName") != null) {

            // parameter parsing
            final String url = arg_object.getString("url");
            final String fileName =arg_object.getString("fileName") ;
            System.out.println("Found: " + url);

            // Begin the Download Task
            new FileDownloaderAsyncTask(callback, url, fileName).execute();
*/
            //return true;
            callback.invoke(true);
        /*}else{
            callback.invoke(false);
        }*/
        //return false;
       } catch (Exception e) {
            callback.invoke(false);
       }
  }
    
    // used for all downloaded files, so we can find and delete them again.
    private final static String FILE_TYPE_PREFIX = "DH_";
    /**
     * downloads the file from the given url to external storage.
     *
     * @param url
     * @return
     */
    private File downloadFile(String url, Callback callback) {

        try {
            // get an instance of a cookie manager since it has access to our
            // auth cookie
            CookieManager cookieManager = CookieManager.getInstance();

            // get the cookie string for the site.
            String auth = null;
            if (cookieManager.getCookie(url) != null) {
                auth = cookieManager.getCookie(url).toString();
            }

            URL url2 = new URL(url);
            HttpURLConnection conn = (HttpURLConnection) url2.openConnection();
            if (auth != null) {
                conn.setRequestProperty("Cookie", auth);
            }

            InputStream reader = conn.getInputStream();

            String extension = MimeTypeMap.getFileExtensionFromUrl(url);
            if (extension.equals("")) {
                extension = "pdf";
                System.out.println("extension (default): " + extension);
            }
            File f = File.createTempFile(FILE_TYPE_PREFIX, "." + extension,
                    null);
            // make sure the receiving app can read this file
            f.setReadable(true, false);
            FileOutputStream outStream = new FileOutputStream(f);

            byte[] buffer = new byte[1024];
            int readBytes = reader.read(buffer);
            while (readBytes > 0) {
                outStream.write(buffer, 0, readBytes);
                readBytes = reader.read(buffer);
            }
            reader.close();
            outStream.close();
            return f;

        } catch (FileNotFoundException e) {
            e.printStackTrace();
            //callback.error(ERROR_FILE_NOT_FOUND);
            return null;
        } catch (IOException e) {
            e.printStackTrace();
            //callback.error(ERROR_UNKNOWN_ERROR);
            return null;
        }
    }
/**
     * Returns the MIME Type of the file by looking at file name extension in
     * the URL.
     *
     * @param url
     * @return
     */
    private static String getMimeType(String url) {
        String mimeType = null;

        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
        if (extension != null) {
            MimeTypeMap mime = MimeTypeMap.getSingleton();
            mimeType = mime.getMimeTypeFromExtension(extension);
        }

        System.out.println("Mime Type: " + mimeType);

        if (mimeType == null) {
            mimeType = "application/pdf";
            System.out.println("Mime Type (default): " + mimeType);
        }

        return mimeType;
    }
    
  private class FileDownloaderAsyncTask extends AsyncTask<Void, Void, File> {

        private final Callback callbackContext;
        private final String url;
        private final String fileName;

        public FileDownloaderAsyncTask(Callback callbackContext,
                String url, String fileName) {
            super();
            this.callbackContext = callbackContext;
            this.url = url;
            this.fileName = fileName;
        }

        @Override
        protected File doInBackground(Void... arg0) {
            if (!url.startsWith("file://")) {
                return downloadFile(url, callbackContext);
            } else {
                File file = new File(url.replace("file://", ""));
                return file;
            }
        }

        @Override
        protected void onPostExecute(File result) {
            if (result == null) {
                // Has already been handled
                return;
            }

            //Context context = ((Activity)getReactApplicationContext().getBaseContext());

            // mime type of file data
            String mimeType = getMimeType(url);
            if (mimeType == null) {
                //callbackContext.error(ERROR_UNKNOWN_ERROR);
                return;
            }
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setDataAndType(Uri.fromFile(result), mimeType);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                //context.startActivity(intent);

                //callbackContext.success(fileName); // Thread-safe.
            } catch (ActivityNotFoundException e) {
				// happens when we start intent without something that can
                // handle it
                e.printStackTrace();
                //callbackContext.error(ERROR_NO_HANDLER_FOR_DATA_TYPE);
            }

        }

    }
}