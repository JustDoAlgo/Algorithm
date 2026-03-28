// BOJ 15650 N과M(2)
/*
2026.03.12 21:30~21:50
15650 - N과 M (2)

*/

#include <iostream>
#include <vector>
using namespace std;

/*
카운트하는 경우, 아닌 경우 2개로 재귀 돌리면 되는 문제아닌가??
*/

int n, m;

void func(int k, vector<int>& v)
{
    if (k == n+1)
    {
        if (!v.empty() && v.size() == m)
        {
            for (auto& e : v)
                cout << e << ' ';
            cout << '\n';
        }
        return;
    }

    // 1. 현재 자연수 추가
    v.push_back(k);
    func(k+1, v);
    // 2. 현재 자연수 패스
    if (!v.empty())
        v.pop_back();
    func(k+1, v);
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