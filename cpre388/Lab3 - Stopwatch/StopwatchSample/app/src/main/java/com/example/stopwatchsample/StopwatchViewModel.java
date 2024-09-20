package com.example.stopwatchsample;

import android.os.Handler;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class StopwatchViewModel extends ViewModel {

    private long elapsedTime = 0L;
    private boolean isRunning = false; // Ensure this is private
    private final Handler handler = new Handler();
    private final MutableLiveData<Long> elapsedTimeLiveData = new MutableLiveData<>();

    public StopwatchViewModel() {
        elapsedTimeLiveData.setValue(elapsedTime);
    }

    public LiveData<Long> getElapsedTime() {
        return elapsedTimeLiveData;
    }

    public boolean isRunning() { // Add a getter method for isRunning
        return isRunning;
    }

    public void start() {
        if (!isRunning) {
            isRunning = true;
            handler.postDelayed(runnable, 10);
        }
    }

    public void stop() {
        if (isRunning) {
            isRunning = false;
            handler.removeCallbacks(runnable);
        }
    }

    public void reset() {
        elapsedTime = 0L;
        elapsedTimeLiveData.setValue(elapsedTime);
        if (isRunning) {
            handler.removeCallbacks(runnable);
        }
    }

    private final Runnable runnable = new Runnable() {
        @Override
        public void run() {
            if (isRunning) { // This should be true to increment time
                elapsedTime += 100;
                elapsedTimeLiveData.setValue(elapsedTime);
                handler.postDelayed(this, 10);
            }
        }
    };

    @Override
    protected void onCleared() {
        super.onCleared();
        handler.removeCallbacks(runnable);
    }
}
