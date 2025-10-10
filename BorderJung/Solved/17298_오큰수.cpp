#include <iostream>
#include <stack>
#include <vector>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int n; cin >> n;
    stack<pair<int, int>> s;
    vector<int> result(n, -1);

    for (int i = 0; i<n; ++i)
    {
        int a; cin >> a;
        
        while (!s.empty() && s.top().first < a)
        {
            result[s.top().second] = a;
            s.pop();
        }
        s.push({a, i});
    }

    for (auto& e : result)
        cout << e << ' ';
}