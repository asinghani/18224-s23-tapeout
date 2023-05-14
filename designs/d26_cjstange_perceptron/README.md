# Perceptron

18-224/624 Spring 2023 Final Tapeout Project
Chris Stange

## Overview

The perceptron is one of the earliest machine learning models and acts as a binary classifier for linearly separable functions.  The perceptron can run both training and inference.

## How it Works

At the implementation level, the perceptron is a pipelined MAC unit with some fancy control logic.  The perceptron uses a 6-bit (3.3) fixed point number representation which means numbers in the range of -4 to 3.875 can be used with a precision of .125.  Arbitrary weights, learning rates, and values can loaded onto the perceptron.  Weights can be read out combinationally after training.  

![Computation](/docs/computation.png)

![Datapath](/docs/Perceptron_datapath.pdf)

![FSM](/docs/Perceptron_fsm.pdf)

## Inputs/Outputs

All signals are 1-bit unless otherwise stated.

### Input signals:
* go - Used to control the loading of input values. Set to 1 to load in_val and move to next state.
* update - Set to 0 if running inference. Set to 1 if running training.
* correct - The correct classification of the inputs.  Used for training.
* sel_out - 2-bit input select line for out_val.  Used to read weights combinationally. 0 -> output of the adder, 1 -> W2, 2 -> W1, 3 -> W0.
* in_val - Where all 6-bit inputs are loaded.  Used to loads weights, learning rate, and input values.

### Output signal:
* done - Notifies when the computation is finished.  Classification will be valid on next clock edge if running inference, weights already available if running training.
* classification - The perceptrons classification of the inputs.
* sync - Set high after successfully loading an input. Allows synchronization of hardware thread with external drivers.
* out_val - Where weights can be read out of the perceptron. Output selected by sel_out.

## Design Testing / Bringup

* Simulation: In order to run the testbench ensure that the oss-cad-suite is enabled and that you are running on an x86 machine.  Use the command "make -f perceptron.mk" in the terminal.  The expected output can be seen below in the media section.  The testbench initializes the weights of the perceptron, runs inference, runs training, and then re-runs inference.  This is done for the logical functions OR, AND, and XOR.  This demonstrates the perceptrons ability to learn linearly separable functions (OR and AND) but also demonstrates its limitations in learning non-linearly separable functions (XOR).

* Testing after fabrication: In order to test after fabrication, I believe running a simple test on inference should be done.  The correct weights for the AND operation can be taken from output of the testbench below and loaded into the perceptron using the control sequence from the FSM or the initialize function in perceptronTester.py.  From here different variations of the inputs 0b000000 (0.0) and 0b001000 (1.0) can be loaded into the perceptron using the control sequence from the FSM or the inference function in perceptronTester.py.  The update signal should be set to 0 to ensure inference is being run.  The output of the perceptron will be available on the classification signal the cycle after done is asserted.  This can be compared to the expected outputs of the AND operation for correctness.  The same process can be repeated for the OR, XOR or any other function of your choice.  Setting update to 1 and following the control sequence from the FSM for training or the training function in perceptronTester.py will allow for training to be tested.

## Media
### Testbench output:
![Testbench output](/docs/test.png)

## Further development

I plan to continue to development of the perceptron on my free time for fun.  I believe that an interesting next step would be to add a non-linearity in order to create a complete artificial neuron.  From here I aim to create a single layer artificial neural network in hardware.
