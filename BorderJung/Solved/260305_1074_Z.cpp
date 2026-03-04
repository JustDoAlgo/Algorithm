/*
2026.03.05 01:00-01:30
1074. Z
아니 n 넘겨주는 부분에서 멍청하게 해서 시간 오래 걸렸네. 로직 구성하는건 15분 정도에 끝났고, 디버깅한다고 시간이 다 넘어가버림. 이것도 실력이지. 좀 더 꼼꼼하게 보자.
*/ 

/*
2^n x 2^n 타일을 Z자를 그리며 가기.

(r, c)를 언제 가는가...

왼쪽 위부터 2x2 칸 씩 훝고 가잖아.

N == 1 이면, r % 2, c % 2 결과로 결정 가능 (0,0)(0,1) 이니까
                                        (1,0)(1,1)
N > 1 이면, (r, c) 좌표를 기준으로 어느 구역을 확장할지 정해야 해.
    1사분면: r <  2^(n-1)  && c <  2^(n-1)
    2사분면: r <  2^(n-1)  && c >= 2^(n-1)
    3사분면: r >= 2^(n-1)  && c <  2^(n-1)
    4사분면: r >= 2^(n-1)  && c >= 2^(n-1)

그 다음은 반복.
*/

#include <iostream>
#include <math.h>
using namespace std;

int func(int n, int r, int c)
{
    if (n == 1)
    {
        int rl = r % 2;
        int cl = c % 2;
        if (rl == 0 && cl == 0) return 1; // 0
        if (rl == 0 && cl == 1) return 2; // 1
        if (rl == 1 && cl == 0) return 3; // 2
        if (rl == 1 && cl == 1) return 4; // 3
    }

    // 사분면 결정 밑 더할 값 결정
    int val = pow(2, n-1); // 사분면의 각 변의 길이 = 2^(n-1)
    int quadArea = pow(2, 2 * n - 2); // 전체 넓이의 1/4
    if (r < val  && c <  val) 
    {
        //cout << "1사분면, val = " << val << '\n';
        return                func(n-1, r    , c    ); // 1사분면
    }
    if (r < val  && c >= val) 
    {
        //cout << "2사분면" << '\n';
        return quadArea +     func(n-1, r    , c-val); // 2사분면
    }
    if (r >= val && c <  val) 
    {
        //cout << "3사분면" << '\n';
        return quadArea * 2 + func(n-1, r-val, c    ); // 3사분면
    }
    if (r >= val && c >= val) 
    {
        //cout << "4사분면" << '\n';
        return quadArea * 3 + func(n-1, r-val, c-val); // 4사분면
    }

    return -1;
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    int n, r, c; cin >> n >> r >> c;

    cout << func(n, r, c) - 1;
}