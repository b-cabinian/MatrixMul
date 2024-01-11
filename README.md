# MatrixMul
ARM assembly project that does 4x4 matrix multiplication using SIMD parallel processing

When executed, the program provides a short introduction for what the program does and instructions about what’s possible. You can only enter non-negative integers < 65535 and if the resulting matrix has any entries greater than 65535, they will be incorrectly displayed. 
The user must enter two 4x4 matrices column by column. The entries are separated by a space and you press enter after entering each column. One example entry and matrix is shown to help provide guidance. After a matrix is entered, it is displayed back to the user to verify that it is the matrix they intended. Once both matrices A and B are entered, the program computes the matrix product A*B and displays it as a matrix C.

The two images show example executions of the program. The first computation shown in “rowswap.png” uses matrix multiplication for a simple row swap. The second computation shown in “rowswap_mul_add.png” does a matrix multiplication that makes use of all three elementary row operations. 

