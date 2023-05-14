from pathlib import Path
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge

def parse_vectors(filepath):
    vectors = []
    with open(filepath) as f:
        for line in f:
            x1, x2, correct = [eval(x) for x in line.strip().split(";")]
            vectors.append((x1, x2, correct))

    return vectors

async def reset_l(dut):
    dut.reset_l.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    dut.reset_l.value = 1

#used for debuging
def resolveStateEnum(state):
    enum = {0b0000: "INIT",
            0b0001: "W0",
            0b0010: "W1",
            0b0011: "W2",
            0b0100: "N",
            0b0101: "X1",
            0b0110: "X2",
            0b0111: "COMPI",
            0b1000: "CHECK",
            0b1001: "T1",
            0b1010: "T2"}
    return enum.get(state, "Invalid State")

#helper function for initializing weights
async def initialize(dut, w0, w1, w2, n):
    #load enable
    dut.go.value = 1

    #LOAD W0
    dut.in_val.value = w0
    await RisingEdge(dut.clk)
    
    #LOAD W1
    dut.in_val.value = w1
    await RisingEdge(dut.clk)

    #LOAD W2
    dut.in_val.value = w2
    await RisingEdge(dut.clk)

    #LOAD N
    dut.in_val.value = n
    await RisingEdge(dut.clk)

    #disable load
    dut.go.value = 0

    await FallingEdge(dut.clk)

#helper function for running inference
async def inference(dut, x1, x2, classification):
    #turn off updating the weights
    dut.update.value = 0

    #load enable
    dut.go.value = 1

    #LOAD X1
    dut.in_val.value = x1
    await RisingEdge(dut.clk)

    #LOAD X2
    dut.in_val.value = x2
    await RisingEdge(dut.clk)

    #disable load
    dut.go.value = 0

    #wait for end of computation
    await RisingEdge(dut.done)

    #get ready to run again
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

    #grab classification
    classification[0] = dut.classification.value

#helper function for doing training
async def training(dut, x1, x2, correct):
    #turn on updating the weights
    dut.update.value = 1

    #load enable
    dut.go.value = 1

    #correct output
    dut.correct.value = correct

    #LOAD X1
    dut.in_val.value = x1
    await RisingEdge(dut.clk)

    #LOAD X2
    dut.in_val.value = x2
    await RisingEdge(dut.clk)

    #disable load
    dut.go.value = 0

    #wait for end of computation
    await RisingEdge(dut.done)

    #get ready to run again
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)

#Run series of training and inference
async def run_test(dut, training_data, inference_data):
    # Reset DUT
    dut.go.value = 0
    await reset_l(dut)

    #initialize weights and training rate
    w0 = 0b000010
    w1 = 0b000001
    w2 = 0b000001
    n =  0b000111
    await initialize(dut, w0, w1, w2, n)
    print("Weights before training:")
    print("W0:", dut.data.w0.value)
    print("W1:", dut.data.w1.value)
    print("W2:", dut.data.w2.value, "\n")

    #run inference before training
    total = 0
    yes = 0
    print("Inference before training:")
    for (x1, x2, correct) in inference_data:
        classification = [2] #invalid value, we know if error occurs, should be 0 or 1
        await inference(dut, x1, x2, classification)
        total += 1
        if (classification[0] == correct): yes += 1
        print("Guess:", classification[0], "Correct", correct)
    print("Accuracy:", yes/total, "\n")

    #do training and print updated weights
    for (x1, x2, correct) in training_data:
        await training(dut, x1, x2, correct)
    print("Weights after training:")
    print("W0:", dut.data.w0.value)
    print("W1:", dut.data.w1.value)
    print("W2:", dut.data.w2.value, "\n")

    #run inference after training
    total = 0
    yes = 0
    print("Inference after training:")
    for (x1, x2, correct) in inference_data:
        classification = [2] #invalid value, we know if error occurs, should be 0 or 1
        await inference(dut, x1, x2, classification)
        total += 1
        if (classification[0] == correct): yes += 1
        print("Guess:", classification[0], "Correct", correct)
    print("Accuracy:", yes/total, "\n")


@cocotb.test()
async def test_perceptron(dut):
    # Automatic clock (timescale is for VCD files)
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    print("\nTEST ON LOGICAL AND")
    training_data = parse_vectors("tests/and_training.txt")
    inference_data = parse_vectors("tests/and_inference.txt")
    await run_test(dut, training_data, inference_data)

    print("\nTEST ON LOGICAL OR")
    training_data = parse_vectors("tests/or_training.txt")
    inference_data = parse_vectors("tests/or_inference.txt")
    await run_test(dut, training_data, inference_data)

    print("\nTEST ON XOR (Should fail)")
    training_data = parse_vectors("tests/xor_training.txt")
    inference_data = parse_vectors("tests/xor_inference.txt")
    await run_test(dut, training_data, inference_data)