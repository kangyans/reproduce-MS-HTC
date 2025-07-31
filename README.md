# reproduce-MS-HTC

This repository reproduces the results of [MS-HTC](https://github.com/loyalliu/MS-HTC), a method for jointly reconstructing multi-slice undersampled k-space data using Low-Rank Tensor Completion. Please note that the original implementation's core function, i.e. ```MS-HTC.p```, is obfuscated and provided as an execute-only file. This project provides a reproduction based on the published method.

## Prerequisite

The [Tensor Toolbox](https://www.tensortoolbox.org/index.html) must be installed prior to running the code.

## Notes

- If you encounter a memory crash error, try replacing the ```hosvd.m``` function with version provided in ```.\func\ ``` directory. The original ```hosvd.m``` is not memory-optimized.
- Spiral case is not included.

## Reference
Liu, Yilong, et al. "Calibrationless parallel imaging reconstruction for multislice MR data using low‐rank tensor completion." Magnetic Resonance in Medicine 85.2 (2021): 897-911.
