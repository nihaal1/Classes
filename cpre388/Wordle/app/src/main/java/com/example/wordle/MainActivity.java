/*

package com.example.wordle;


import android.os.Bundle;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
       // ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
    }
}
 */

package com.example.wordle;

import android.graphics.Color;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;

import com.example.wordle.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private final String WORD = "dubai";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        keepPassingFocus();
        setupRowValidation();
    }

    private void setupRowValidation() {
        addTextWatcher(binding.edt15, binding.edt11, binding.edt12, binding.edt13, binding.edt14, binding.edt15);
        addTextWatcher(binding.edt25, binding.edt21, binding.edt22, binding.edt23, binding.edt24, binding.edt25);
        addTextWatcher(binding.edt35, binding.edt31, binding.edt32, binding.edt33, binding.edt34, binding.edt35);
        addTextWatcher(binding.edt45, binding.edt41, binding.edt42, binding.edt43, binding.edt44, binding.edt45);
        addTextWatcher(binding.edt55, binding.edt51, binding.edt52, binding.edt53, binding.edt54, binding.edt55);
        addTextWatcher(binding.edt65, binding.edt61, binding.edt62, binding.edt63, binding.edt64, binding.edt65);
    }

    private void addTextWatcher(EditText lastEditText, EditText... rowEditTexts) {
        lastEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {}

            @Override
            public void afterTextChanged(Editable s) {
                if (s != null && s.length() == 1) {
                    validateRow(rowEditTexts);
                }
            }
        });
    }

    private void validateRow(EditText... rowEditTexts) {
        String[] inputs = new String[rowEditTexts.length];
        String[] wordParts = WORD.split("");

        for (int i = 0; i < rowEditTexts.length; i++) {
            inputs[i] = rowEditTexts[i].getText().toString();

            if (inputs[i].equals(wordParts[i])) {
                rowEditTexts[i].setBackgroundColor(Color.parseColor("#33cc33")); // Green
            } else if (WORD.contains(inputs[i])) {
                rowEditTexts[i].setBackgroundColor(Color.parseColor("#ffff00")); // Yellow
            } else {
                rowEditTexts[i].setBackgroundColor(Color.parseColor("#ff3333")); // Red
            }
        }

        if (WORD.equals(String.join("", inputs))) {
            binding.idTVCongo.setText("Congratulations, you have guessed the right word.");
            binding.idTVCongo.setVisibility(View.VISIBLE);
            makeGameInactive();
            Toast.makeText(getApplicationContext(), "Congratulations, you have guessed the right word.", Toast.LENGTH_SHORT).show();
        } else if (rowEditTexts[rowEditTexts.length - 1].getId() == R.id.edt_65) {
            binding.idTVCongo.setText("Sorry, you couldn't guess the word. The correct word was: " + WORD);
            binding.idTVCongo.setVisibility(View.VISIBLE);
            makeGameInactive();
            Toast.makeText(getApplicationContext(), "The correct word was: " + WORD, Toast.LENGTH_SHORT).show();        }
    }

    private void makeGameInactive() {
        for (View view : new View[]{
                binding.edt11, binding.edt12, binding.edt13, binding.edt14, binding.edt15,
                binding.edt21, binding.edt22, binding.edt23, binding.edt24, binding.edt25,
                binding.edt31, binding.edt32, binding.edt33, binding.edt34, binding.edt35,
                binding.edt41, binding.edt42, binding.edt43, binding.edt44, binding.edt45,
                binding.edt51, binding.edt52, binding.edt53, binding.edt54, binding.edt55,
                binding.edt61, binding.edt62, binding.edt63, binding.edt64, binding.edt65
        }) {
            view.setEnabled(false);
        }
    }

    private void keepPassingFocus() {
        passFocusToNextEdt(binding.edt11, binding.edt12);
        passFocusToNextEdt(binding.edt12, binding.edt13);
        passFocusToNextEdt(binding.edt13, binding.edt14);
        passFocusToNextEdt(binding.edt14, binding.edt15);

        passFocusToNextEdt(binding.edt21, binding.edt22);
        passFocusToNextEdt(binding.edt22, binding.edt23);
        passFocusToNextEdt(binding.edt23, binding.edt24);
        passFocusToNextEdt(binding.edt24, binding.edt25);

        passFocusToNextEdt(binding.edt31, binding.edt32);
        passFocusToNextEdt(binding.edt32, binding.edt33);
        passFocusToNextEdt(binding.edt33, binding.edt34);
        passFocusToNextEdt(binding.edt34, binding.edt35);

        passFocusToNextEdt(binding.edt41, binding.edt42);
        passFocusToNextEdt(binding.edt42, binding.edt43);
        passFocusToNextEdt(binding.edt43, binding.edt44);
        passFocusToNextEdt(binding.edt44, binding.edt45);

        passFocusToNextEdt(binding.edt51, binding.edt52);
        passFocusToNextEdt(binding.edt52, binding.edt53);
        passFocusToNextEdt(binding.edt53, binding.edt54);
        passFocusToNextEdt(binding.edt54, binding.edt55);

        passFocusToNextEdt(binding.edt61, binding.edt62);
        passFocusToNextEdt(binding.edt62, binding.edt63);
        passFocusToNextEdt(binding.edt63, binding.edt64);
        passFocusToNextEdt(binding.edt64, binding.edt65);
    }

    private void passFocusToNextEdt(EditText edt1, EditText edt2) {
        edt1.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {}

            @Override
            public void afterTextChanged(Editable s) {
                if (s != null && s.length() == 1) {
                    edt2.requestFocus();
                }
            }
        });
    }
}
