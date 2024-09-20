package com.example.stopwatchsample;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;

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

        // Initialize UI components (TextView, Buttons)
        tvTime = findViewById(R.id.tvElapsedTime);
        btnStartStop = findViewById(R.id.btnStartStop);
        btnReset = findViewById(R.id.btnReset);

        // Observe LiveData from ViewModel
        viewModel.getElapsedTime().observe(this, new Observer<Long>() {
            @Override
            public void onChanged(Long elapsedTime) {
                tvTime.setText(formatElapsedTime(elapsedTime));
            }
        });

        // Set up button listeners
        btnStartStop.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (viewModel.isRunning()) { // Use getter method
                    viewModel.stop();
                    btnStartStop.setText("Start");
                } else {
                    viewModel.start();
                    btnStartStop.setText("Stop");
                }
            }
        });

        btnReset.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                viewModel.reset();
                btnStartStop.setText("Start");
            }
        });
    }

    // Method to format elapsed time for display
    private String formatElapsedTime(long elapsedTime) {
        long seconds = (elapsedTime / 1000) % 60;
        long minutes = (elapsedTime / (1000 * 60)) % 60;
        long hours = (elapsedTime / (1000 * 60 * 60)) % 24;
        long tenths = (elapsedTime / 100) % 10;

        return String.format("%02d:%02d:%02d.%1d", hours, minutes, seconds, tenths);
    }
}
