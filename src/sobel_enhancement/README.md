## HDL source files

### In `src` folder

### Test image is `monarch_320x240.jpg`


## Install requires 

```bash
apt-get install python3-tk
```

```bash
python3 setup.py install 
```

## Test bench 

### Test bench with cocotb 

```bash
cd cocotb_test_bench
```
```bash
make WAVES=1
```

### Test bench with system verilog 
```bash
cd sv_test_bench
```
```bash
make 
```