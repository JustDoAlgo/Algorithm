#include <iostream>
#include <queue>
using namespace std;

int t[100002];

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(0);

    int n, k; cin >> n >> k;
    fill(t, t + 100002, -1);
    queue<int> q;
    q.push(n);
    t[n] = 0;
    while (t[k] == -1)
    {
        int here = q.front(); q.pop();
        for (int nx : {here + 1, here - 1, here * 2})
        {
            if (nx < 0 || nx > 100000) continue;
            if (t[nx] != -1) continue;
            t[nx] = t[here] + 1;
            q.push(nx);
        }
    }
    cout << t[k];
}