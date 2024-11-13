package com.example.objectscanner;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.Camera;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageProxy;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;

import android.Manifest;
import android.annotation.SuppressLint;
import android.content.pm.PackageManager;
import android.media.Image;
import android.os.Bundle;
import android.util.Size;
import android.widget.TextView;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.label.ImageLabel;
import com.google.mlkit.vision.label.ImageLabeler;
import com.google.mlkit.vision.label.ImageLabeling;
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions;

import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class MainActivity extends AppCompatActivity {
    private ListenableFuture<ProcessCameraProvider> cameraProviderFuture;
    private PreviewView previewView;
    private ImageAnalysis.Builder builder;
    private ImageAnalysis imageAnalysis;
    private Executor executor;
    private ImageAnalysis.Analyzer analyzer;
    private CameraSelector cameraSelector;
    private Camera camera;
    private String text;
    private int index;
    private float confidence;
    private String output;
    private TextView textView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        textView = findViewById(R.id.textView);
        if (ContextCompat.checkSelfPermission(

                this, Manifest.permission.CAMERA) ==

                PackageManager.PERMISSION_GRANTED) {

            // You can use the API that requires the permission.



        } else {

            // You can directly ask for the permission.

            ActivityCompat.requestPermissions(this,

                    new String[] { Manifest.permission.CAMERA },

                    1);

        }
        cameraSelector = new CameraSelector.Builder()
                .requireLensFacing(CameraSelector.LENS_FACING_BACK)
                .build();
        previewView = findViewById(R.id.previewView);
        cameraProviderFuture = ProcessCameraProvider.getInstance(this);
        cameraProviderFuture.addListener(() -> {
            try {
                ProcessCameraProvider cameraProvider = cameraProviderFuture.get();
                bindPreview(cameraProvider);
            } catch (ExecutionException | InterruptedException e) {
                // No errors need to be handled for this Future.
                // This should never be reached.
            }
        }, ContextCompat.getMainExecutor(this));

        imageAnalysis = new ImageAnalysis.Builder().setTargetResolution(new Size(1280, 720))
                .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST)
                .build();
//        executor = new Executor() {
//            @Override
//            public void execute(Runnable runnable) {
//
//            }
//        };
//        analyzer = new ImageAnalysis.Analyzer() {
//            @Override
//            public void analyze(@NonNull ImageProxy image) {
//
//            }
//        };

        imageAnalysis.setAnalyzer(Executors.newFixedThreadPool(1), new ImageAnalysis.Analyzer() {
            @Override
            public void analyze(@NonNull ImageProxy imageProxy) {
                InputImage image = null;
                //textView.setText("bingo");
                int rotationDegree = imageProxy.getImageInfo().getRotationDegrees();
                // insert your code here.
                @SuppressLint("UnsafeOptInUsageError") Image mediaImage = imageProxy.getImage();
                if (mediaImage != null) {
                    image = InputImage.fromMediaImage(mediaImage, imageProxy.getImageInfo().getRotationDegrees());
                    // Pass image to an ML Kit Vision API
                }

                ImageLabeler labeler = ImageLabeling.getClient(ImageLabelerOptions.DEFAULT_OPTIONS);

                //InputImage image1 = InputImage.fromBitmap(bitmap, rotationDegree);

                // after done, release the ImageProxy object
                //imageProxy.close();
                labeler.process(image)
                        .addOnSuccessListener(new OnSuccessListener<List<ImageLabel>>() {
                            @Override
                            public void onSuccess(List<ImageLabel> labels) {
                                //for (ImageLabel label : labels) {
                                    for(int i = 0; i < labels.size(); i++){
                                        text = labels.get(i).getText();
                                        confidence = labels.get(i).getConfidence() * 100;
                                        index = labels.get(i).getIndex();
                                        output += text + ", " + confidence + "%, " + index + "\n";
                                    }
                                    textView.setText(output);
                                    output = "";
                                //}
                                imageProxy.close();
                            }
                        })
                        .addOnFailureListener(new OnFailureListener() {
                            @Override
                            public void onFailure(@NonNull Exception e) {
                                imageProxy.close();
                            }
                        });
            }
        });

        //cameraProviderFuture.bindToLifecycle((LifecycleOwner) this, cameraSelector, imageAnalysis, previewView);

    }

    void bindPreview(@NonNull ProcessCameraProvider cameraProvider) {
        Preview preview = new Preview.Builder()
                .build();

        preview.setSurfaceProvider(previewView.getSurfaceProvider());

        camera = cameraProvider.bindToLifecycle((LifecycleOwner)this, cameraSelector, imageAnalysis, preview);
    }
}