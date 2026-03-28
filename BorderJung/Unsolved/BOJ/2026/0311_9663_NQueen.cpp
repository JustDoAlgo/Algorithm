// BOJ 9663 NQueen
/*
2026.03.11 22:00~23:00
2026.03.12 20:30~20:40
9663 N-Queen

대각선 계산하기
결국 y = x + d 또는 y = -x + d 이다. 이때 바뀌는 건 d이기 때문에
y-x=d or y+x=d 인 지점들이 중요한 것.
아래에서 문제 풀 때
diag1[r+c]와 diag2[r-c+n-1]의 의미를 이해하자.
r+c는 결국 x+y이고, x+y에서 동일한 값이 나왔다면 동일한 대각선 위에 있다는 것
    값 범위: 0~2(n-1)

r-c는 결국 y-x이고, y-x에서 동일한 값이 나왔다면 동일한 대각선 위에 있다는 것
다만, r-c는 음수가 될 수 있기에(값 범위:-(n-1)~(n-1)), n-1을 더해서
값 범위를 0~2(n-1)로 맞춘 것이다.
*/

#include <iostream>
using namespace std;

int n;
int result = 0;

int v_column[20];
int diag1[50];
int diag2[50];

void func(int r)
{
    if (r == n)
    {
        result += 1;
        return;
    }

    for (int c=0; c<n; ++c)
    {
        if (v_column[c] || diag1[r+c] || diag2[r-c+n-1]) continue;
        v_column[c] = true;
        diag1[r+c] = true; // x+y 대각선
        diag2[r-c+n-1] = true;  // x-y 대각선인데 양수로 만들기 위해 n-1 더함
        func(r+1);
        v_column[c] = false;
        diag1[r+c] = false;
        diag2[r-c+n-1] = false;
    }
}

int main()
{
    cin.tie(0); cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n;
    func(0);

    cout << result;
}