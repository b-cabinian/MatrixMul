MatrixMul: MatrixMul.s MatrixMul.o ../../lib/cs12Lib/cs12Lib.o MatrixMulLib.o
	 gcc -no-pie -g -o MatrixMul MatrixMul.o ../../lib/cs12Lib/cs12Lib.o MatrixMulLib.o

MatrixMulLib.o: MatrixMulLib.s
	as -g -o MatrixMulLib.o MatrixMulLib.s
	
clean:
	rm -rf MatrixMul
	rm -rf MatrixMul.o
	rm -rf MatrixMulLib.o

