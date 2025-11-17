/*
재시도 횟수: 1/3
*/

#include <iostream>
#include <stack>
using namespace std;

int board[100002];
int state[100002]; // -1: 팀에 속함. 0: 팀에 속하지 않음. 그 외: 현재 사이클에 등장
int n;

void dfs(int here)
{
    int cur = here;

    while (true)
    {
        state[cur] = here;
        cur = board[cur];
        // 만약 사이클을 이루었다면, 현재부터 다시 사이클을 한 번 돌린다.
        if (state[cur] == here)
        {
            while (state[cur] != -1)
            {
                state[cur] = -1;
                cur = board[cur];
            }
            return;
        }
        else if (state[cur] != 0) return;
    }
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    int t; cin >> t;
    while (t--)
    {
        cin >> n;
        fill(state + 1, state + 100001, false);

        for (int i=1; i<=n; ++i)
        {
            cin >> board[i];
        }

        for (int i=1; i<=n; ++i)
        {
            // state가 0이 아니면, 팀을 이뤘거나 이룰 수 없다.
            if (state[i] == 0)
            {
                dfs(i);
            }
        }

        int cnt = 0;
        for (int i=1; i<=n; ++i)
        {
            if (state[i] != -1)
                cnt += 1;
        }
        cout << cnt << '\n';
    }
}