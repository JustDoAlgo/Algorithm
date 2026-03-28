// BOJ 15657 N과M(11)
/*
26.03.13 20:45~20:46
15665 - N과 M (11)
*/

#include <iostream>
#include <vector>
#include <algorithm>
#include <unordered_map>
#include <map>
using namespace std;

int n, m;
int arr[10];
int num[10];

void func(int k)
{
    if (k == m)
    {
        for (int i=0; i<m; ++i)
            cout << arr[i] << ' ';
        cout << '\n';
        return;
    }
    // 중복 확인을 위해 현재 깊이에서
    // 마지막에 선택한 요소 저장
    int last = 0;
    for (int i=0; i<n; ++i)
    {
        if (last==num[i]) continue;

        arr[k] = num[i];
        last = num[i];
        func(k+1);
    }
}

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    for (int i=0; i<n; ++i)
        cin >> num[i];
    sort(num, num + n);
    func(0);
}