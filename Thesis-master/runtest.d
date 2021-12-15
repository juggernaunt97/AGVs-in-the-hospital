import std.stdio;

auto runProgram(int k, int square){
	import std.exception,  std.process, std.conv;

	auto s = "python generateBig.py " ~ to!string(square) ~ " | ./a.out -k " ~ to!string(k);

	auto result = executeShell(s);

	return result.output;
}

void main(){
	for(int i=0;i<=25;i++){
		write(i," ",runProgram(i,i));
	}
}
