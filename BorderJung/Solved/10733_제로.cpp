#include <iostream>
#include <stack>
using namespace std;

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(0);

    int K; cin >> K;
    stack<int> s;
    while (K--)
    {
        int n; cin >> n;
        if (n == 0)
            s.pop();
        else
            s.push(n);
    }

    int result = 0;
    while (!s.empty())
    {
        result += s.top();
        s.pop();
    }
    cout << result;
}