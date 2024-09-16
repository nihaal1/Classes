package edu.iastate.netid.pocketcalculator;
// Declares the package for this application

import android.os.Bundle; 
// Import the Bundle class, used for saving and passing data between activities

import android.view.View; 
// Import the View class, the base class for all UI components in Android

import android.widget.Button; 
// Import the Button class to create and manage buttons

import android.widget.TextView; 
// Import the TextView class to display text on the screen

import androidx.appcompat.app.AppCompatActivity; 
// Import the AppCompatActivity class, which provides compatibility support for older Android versions

public class MainActivity extends AppCompatActivity { 
// Defines the MainActivity class that extends AppCompatActivity

    private TextView display; 
    // Declares a TextView variable to show the calculator’s display

    private double firstNumber = 0; 
    // Declares a variable to store the first number entered by the user

    private double secondNumber = 0; 
    // Declares a variable to store the second number entered by the user

    private String operator = ""; 
    // Declares a variable to store the operator (+, -, *, /) selected by the user

    private boolean isOperatorSelected = false; 
    // Boolean flag to check if an operator has been selected

    @Override
    protected void onCreate(Bundle savedInstanceState) { 
    // onCreate is the entry point when the activity is created

        super.onCreate(savedInstanceState); 
        // Calls the superclass’s onCreate method

        setContentView(R.layout.activity_main); 
        // Sets the layout from the activity_main.xml file to this activity

        display = findViewById(R.id.display); 
        // Binds the display TextView from the XML layout

        setNumberButtonListeners(); 
        // Calls the method to set listeners for all the number buttons

        setOperatorButtonListeners(); 
        // Calls the method to set listeners for the operator buttons (+, -, *, /)

        findViewById(R.id.btnEqual).setOnClickListener(new View.OnClickListener() { 
        // Sets a listener for the "=" button

            @Override
            public void onClick(View v) {
                secondNumber = Double.parseDouble(display.getText().toString()); 
                // Converts the text in the display to a number and stores it as the second number

                calculateResult(); 
                // Calls the method to perform the calculation based on the selected operator
            }
        });

        findViewById(R.id.btnClear).setOnClickListener(new View.OnClickListener() { 
        // Sets a listener for the "C" button to clear the display and reset the calculator

            @Override
            public void onClick(View v) {
                resetCalculator(); 
                // Calls the method to reset all variables and the display
            }
        });

        findViewById(R.id.btnDot).setOnClickListener(new View.OnClickListener() { 
        // Sets a listener for the decimal point button (.)

            @Override
            public void onClick(View v) {
                String currentText = display.getText().toString(); 
                // Gets the current text from the display

                if (!currentText.contains(".")) { 
                // If the display does not already contain a decimal point, add one

                    display.setText(currentText + "."); 
                    // Adds a decimal point to the display
                }
            }
        });
    }

    private void setNumberButtonListeners() { 
    // Method to set listeners for number buttons 0-9

        View.OnClickListener numberListener = new View.OnClickListener() { 
        // Creates a listener for number buttons

            @Override
            public void onClick(View v) {
                Button numberButton = (Button) v; 
                // Casts the clicked view as a Button

                String number = numberButton.getText().toString(); 
                // Gets the text of the clicked button, which is the number

                updateDisplayWithNumber(number); 
                // Calls a method to update the display with the clicked number
            }
        };

        // Assigns the same listener to all number buttons (0-9)
        findViewById(R.id.btn0).setOnClickListener(numberListener);
        findViewById(R.id.btn1).setOnClickListener(numberListener);
        findViewById(R.id.btn2).setOnClickListener(numberListener);
        findViewById(R.id.btn3).setOnClickListener(numberListener);
        findViewById(R.id.btn4).setOnClickListener(numberListener);
        findViewById(R.id.btn5).setOnClickListener(numberListener);
        findViewById(R.id.btn6).setOnClickListener(numberListener);
        findViewById(R.id.btn7).setOnClickListener(numberListener);
        findViewById(R.id.btn8).setOnClickListener(numberListener);
        findViewById(R.id.btn9).setOnClickListener(numberListener);
    }

    private void setOperatorButtonListeners() { 
    // Method to set listeners for the operator buttons (+, -, *, /)

        View.OnClickListener operatorListener = new View.OnClickListener() { 
        // Creates a listener for the operator buttons

            @Override
            public void onClick(View v) {
                Button operatorButton = (Button) v; 
                // Casts the clicked view as a Button

                operator = operatorButton.getText().toString(); 
                // Stores the clicked operator in the 'operator' variable

                firstNumber = Double.parseDouble(display.getText().toString()); 
                // Stores the current display value as the first number

                isOperatorSelected = true; 
                // Sets the flag to true, indicating that an operator was selected

                display.setText(""); 
                // Clears the display for entering the second number
            }
        };

        // Assigns the same listener to all operator buttons
        findViewById(R.id.btnAdd).setOnClickListener(operatorListener);
        findViewById(R.id.btnSub).setOnClickListener(operatorListener);
        findViewById(R.id.btnMul).setOnClickListener(operatorListener);
        findViewById(R.id.btnDiv).setOnClickListener(operatorListener);
    }

    private void updateDisplayWithNumber(String number) { 
    // Method to update the display when a number button is clicked

        String currentText = display.getText().toString(); 
        // Gets the current text on the display

        if (isOperatorSelected) { 
        // If an operator was just selected, replace the display with the new number

            display.setText(number); 
            // Sets the display to the new number

            isOperatorSelected = false; 
            // Resets the flag because the operator is no longer in focus
        } else {
            if (currentText.equals("0")) { 
            // If the current display is "0", replace it with the new number

                display.setText(number); 
            } else {
                display.setText(currentText + number); 
                // Otherwise, append the new number to the current display
            }
        }
    }

    private void calculateResult() { 
    // Method to perform the calculation based on the selected operator

        double result = 0; 
        // Variable to hold the result of the calculation

        switch (operator) { 
        // Switch statement to determine which operator was selected

            case "+": 
                result = firstNumber + secondNumber; 
                // Adds the two numbers
                break;

            case "-": 
                result = firstNumber - secondNumber; 
                // Subtracts the two numbers
                break;

            case "*": 
                result = firstNumber * secondNumber; 
                // Multiplies the two numbers
                break;

            case "/": 
                if (secondNumber != 0) { 
                // If the second number is not zero, perform the division

                    result = firstNumber / secondNumber; 
                } else {
                    display.setText("Error"); 
                    // If trying to divide by zero, show an error message
                    return; 
                    // Return to avoid updating the display with a result
                }
                break;
        }
        display.setText(String.valueOf(result)); 
        // Sets the display to the result of the calculation
    }

    private void resetCalculator() { 
    // Method to reset the calculator

        display.setText("0"); 
        // Resets the display to "0"

        firstNumber = 0; 
        // Resets the first number to 0

        secondNumber = 0; 
        // Resets the second number to 0

        operator = ""; 
        // Clears the operator

        isOperatorSelected = false; 
        // Resets the operator flag
    }
}
