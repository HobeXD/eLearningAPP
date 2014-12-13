#include <iostream>
#include <string>

using namespace std;

int main(void){
	string input;
	char type;
	int level, i = 0;

	cerr << "level: ";
	cin >> level;
	getline(cin, input);
	while(getline(cin, input))
		cout << "	[" << level * 1000 + (i++) << "] = \"" << input << "\"," << endl;

	return 0;
}