package com.example.stopwatchsample;

import android.os.Handler;
import android.os.SystemClock;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class StopwatchViewModel extends ViewModel {

    // Variable to track elapsed time
    private long elapsedTime = 0L;
    private boolean isRunning = false;
    private final Handler handler = new Handler();
    private  final MutableLiveData<Long> elapsedTimeLiveData = new MutableLiveData<>();

    // TODO: Add methods to start, stop, and reset the stopwatch
    public StopwatchViewModel(){
        elapsedTimeLiveData.setValue(elapsedTime);
    }

//    public long getElapsedTime() {
//        return elapsedTime;
//    }

    public LiveData<Long> getElapsedTime(){
        return elapsedTimeLiveData;
    }

}
