package com.example.stopwatchsample;

import android.os.Bundle;
import android.view.View;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;

import android.widget.TextView;
import android.widget.Button;
import static android.text.format.DateUtils.formatElapsedTime;

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
        tvTime = findViewById(R.id.tvElapsedTime);
        btnStartStop = findViewById(R.id.btnStartStop);
        btnReset = findViewById(R.id.btnReset);

        // TODO: Set up button listeners for Start/Stop and Reset
        viewModel.getElapsedTime().observe(this, new Observer<Long>() {
            @Override
            public void onChanged(Long elapsedTime) {
                tvTime.setText(formatElapsedTime(elapsedTime));
            }
        });

        btnStartStop.setOnClickListener(new View.OnClickListener(){
            @Override
        })
    }

    // TODO: Format elapsed time for display
}
