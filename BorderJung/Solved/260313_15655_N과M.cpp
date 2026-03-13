/*
26.03.13 19:00~19:08
15655 N과 M (6)
*/

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int n, m;
vector<int> v;
vector<int> result;
vector<bool> visited;

void func(int k)
{
    if (k == m)
    {
        if (result.size() != m)
        {
            return;
        }
        for (auto& e : result)
            cout << e << ' ';
        cout << '\n';
        return;
    }

    for (int i=k; i<n; ++i)
    {
        if (visited[i]) continue;
        if (!result.empty() && result.back() >= v[i])
            continue;

        visited[i] = true;
        result.push_back(v[i]);
        func(k+1);
        visited[i] = false;
        result.pop_back();
    }
}

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    v = vector<int>(n, -1);
    visited = vector<bool>(n, false);
    for (auto& e : v)
        cin >> e;
    sort(v.begin(), v.end());

    func(0);
}