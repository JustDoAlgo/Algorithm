/*
2026.03.12 22:10~22:25
15652 - N과 M (4)
이지
*/

#include <iostream>
#include <vector>
using namespace std;

/*
이전 자연수와 벡터를 같이 넘기면 될 것 같은데
*/

int n, m;

void func(int prev, vector<int> v)
{
    if (v.size() == m)
    {
        for (auto& e : v) cout << e << ' ';
        cout << '\n';
        return;
    }

    for (int i=prev; i<=n; ++i)
    {
        v.push_back(i);
        func(i, v);
        v.pop_back();
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    vector<int> v;
    func(1, v);
}