Install the julia package

```julia
pkg> add https://github.com/mdpetters/LabjackU6Library.jl.git
```

Install library dependencies (Debian):
```shell
sudo apt install libusb-1.0-0-dev
```

Install Labjack exodriver:
```shell
cd ~/.julia/packages/LabjackU6library/XXXXX/dependencies/exodriver
```

where XXXXX is directory assigned by the Julia package manager

```shell
sudo ./install.sh
sudo reboot
```