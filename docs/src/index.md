LabjackU6Library.jl is a Julia package to communicate with Labjack series U6 multifunction DAQ device. The package is partial wrapper to the low-level [Labjack Linux driver](https://github.com/labjack/exodriver). 

The driver provides a series of C functions to communicate with the DAQ device. A shared static library is obtained by compiling the files in the U6 directory. 