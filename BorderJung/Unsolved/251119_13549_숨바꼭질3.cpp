#include <iostream>
#include <queue>
using namespace std;
#define x first
#define y second

int n, k;
int t[200004];

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    cin >> n >> k;
    fill(t, t+200004, -1);

    t[n] = 0;
    queue<int> q;
    q.push(n);
    if (n == k) 
    {
        cout << 0;
        return 0;
    }
    while (!q.empty())
    {
        int here = q.front(); q.pop();
        for (int next : {here * 2, here - 1, here + 1})
        {
            if (next == k)
            {
                if (next == here * 2)
                {
                    cout << t[here];
                    return 0;
                }
                cout << t[here] + 1;
                return 0;
            }
            if (next < 0 || next > 200000) continue;
            if (t[next] != -1) continue;

            if (next == here * 2 && next > 0)
            {
                q.push(next);
                t[next] = t[here];
            }
            else
            {
                q.push(next);
                t[next] = t[here] + 1;
            }
        }
    }
}