import glob
import subprocess
import yaml
import sys

def yosys_script(name, files):
    files = " ".join([f"{name}/src/{fn}" for fn in files])

    return f"read_verilog -sv {files}; synth -flatten -top toplevel_chip; setundef -undriven -zero; setundef -zero; async2sync; synth -top toplevel_chip; rename toplevel_chip {name}; write_verilog -attr2comment {name}/flattened.v; check; stat;"

def run_yosys(name, files):
    out = subprocess.check_output(["yosys", "-p", yosys_script(name, files)]).decode()
    out = out.split("Printing statistics.")[-1].split("End of script")[0].split("Warnings")[0].strip()
    with open(f"{name}/flattened_stats.txt", "w+") as f:
        f.write(out+"\n")

def write_wrapper(name, topname):
    wrapper = """
        module toplevel_chip (
            input [13:0] io_in,
            output [13:0] io_out
        );

            CHIPNAME mchip (
                .io_in(io_in[7:0]),
                .io_out(io_out[7:0])
            );

        endmodule
    """.replace("CHIPNAME", topname)

    with open(f"{name}/src/wrapper.v", "w+") as f:
        f.write(wrapper)

def write_wrapper_clocked(name, topname):
    wrapper = """
        module toplevel_chip (
            input [13:0] io_in,
            output [13:0] io_out
        );

            // CLOCKED
            CHIPNAME mchip (
                .io_in({io_in[7:1], io_in[12]}),
                .io_out(io_out[7:0])
            );

        endmodule
    """.replace("CHIPNAME", topname)

    with open(f"{name}/src/wrapper.v", "w+") as f:
        f.write(wrapper)

if len(sys.argv) > 1:
    g = sys.argv[1]
else:
    g = "d*"

for des in sorted(list(glob.glob(g))):
    with open(f"{des}/info.yaml") as f:
        data = yaml.load(f, Loader=yaml.Loader)

    if "tt02_fmt" in data["project"] and data["project"]["tt02_fmt"] == "clocked":
        print("Processing OLD (clocked)", des)
        sources = data["project"]["source_files"] + ["wrapper.v"]

        write_wrapper_clocked(des, data["project"]["top_module"])
        run_yosys(des, sources)

    elif "tt02_fmt" in data["project"] and data["project"]["tt02_fmt"]:
        print("Processing OLD (async)", des)
        sources = data["project"]["source_files"] + ["wrapper.v"]

        write_wrapper(des, data["project"]["top_module"])
        run_yosys(des, sources)

    else:
        print("Processing NEW", des)
        assert data["project"]["top_module"] == "toplevel_chip"
        sources = data["project"]["source_files"]

        run_yosys(des, sources)
