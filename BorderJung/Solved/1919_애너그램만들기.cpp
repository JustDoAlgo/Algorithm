#include <iostream>
#include <vector>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    // input
    string a, b;
    cin >> a >> b;

    vector<int> va(26, 0);
    vector<int> vb(26, 0);
    for (auto& e : a) va[e - 'a'] += 1;
    for (auto& e : b) vb[e - 'a'] += 1;

    // solve
    int result = 0;
    for (int i=0; i<26; ++i)
    {
        result += abs(va[i] - vb[i]);
    }
    cout << result;
}