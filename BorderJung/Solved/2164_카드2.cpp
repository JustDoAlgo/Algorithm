#include <iostream>
#include <queue>
using namespace std;

int main()
{
    cin.tie(0);
    ios::sync_with_stdio(false);

    int n; cin >> n;
    queue<int> q;
    for (int i=1; i<=n; ++i)
        q.push(i);

    if (n == 1)
    {
        cout << 1;
        return 0;
    }

    while (!q.empty())
    {
        q.pop();
        q.push(q.front());
        q.pop();

        if (q.size() == 1)
        {
            cout << q.front();
            break;
        }
    }
}