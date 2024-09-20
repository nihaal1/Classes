package com.example.stopwatchsample;

import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    private StopwatchViewModel viewModel;
    private TextView tvTime;
    private Button btnStartStop, btnReset;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Initialize ViewModel
        viewModel = new ViewModelProvider(this).get(StopwatchViewModel.class);

        // TODO: Initialize UI components (TextView, Buttons)

        // TODO: Set up button listeners for Start/Stop and Reset
    }

    // TODO: Format elapsed time for display
}
