// 13549

#include <iostream>
#include <algorithm>
#include <deque>
using namespace std;

int t[200000]; // *2 대비 메모리 넉넉히 설정

void printT(int n)
{
    cout << '[';
    for (int i=0; i<n; ++i)
    {
        if (i == n - 1)
            cout << t[i];
        else
            cout << t[i] << ", ";
    }
    cout << ']';
    cout << '\n';
}

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(false);

    int n, k; cin >> n >> k;

    /*
    t[i]: 위치 i에 도달하기까지 걸린 최소 시간. -1로 초기화
    만약 t[i]가 -1이 아니라면 이미 도달했기에 건너뜀
    BFS하다가 발견하면 시간 반환
    1. 현재 X가 K보다 작다면, -1, +1, x2 중 하나 선택
    2. 현재 X가 K보다 크다면, -1 선택
    */

    fill(t, t+200004, -1); // t는 -1로 초기화

    deque<int> dq;
    dq.push_front(n); // 현재 위치
    t[n] = 0;  // 현재 위치는 0초
    int result = 987654321;
    while (!dq.empty()) // q.front()가 K가 될 때까지 반복
    {
        int here = dq.front(); dq.pop_front();
        if (here == k)
        {
            result = min(result, t[here]);
        }

        // case3)2X(, 너무 커지면 시간 손해이니 적당히 조절) <- 필요하면 최적화
        if (here <= 100000 && t[here * 2] == -1)
        {
            t[here * 2] = t[here];
            dq.push_front(here * 2); // x2는 무조건 싸니까 먼저 처리해야 함
        }
        // 가능한 다음 위치를 Q에 넣음
        // case1)X - 1
        if (here - 1 >= 0 && t[here - 1] == -1)
        {
            t[here - 1] = t[here] + 1;
            dq.push_back(here - 1);
        }
        // case2)X + 1
        if (here + 1 <= 200000 && t[here + 1] == -1)
        {
            t[here + 1] = t[here] + 1;
            dq.push_back(here + 1);
        }
    }

    cout << result;
}