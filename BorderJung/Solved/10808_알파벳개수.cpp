#include <iostream>
using namespace std;

string input;

int main()
{
    int alphabet[26] = {0, };
    cin >> input;

    for (char c : input)
    {
        int charToInt = c - 'a';
        alphabet[charToInt] += 1;
    }

    for (int i=0; i<26; ++i)
    {
        cout << alphabet[i] << ' ';
    }
}