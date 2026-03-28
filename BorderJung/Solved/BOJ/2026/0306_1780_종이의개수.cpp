// BOJ 1780 종이의개수
/*
2026.03.06 08:35-09:15
1780 종이의 개수
아니 분명 쉬운데 왜케 오래걸리지 멍청하게
*/

#include <iostream>
#include <vector>
using namespace std;

/*
n이 완전하려면? n/9도 완전.
n/9가 완전? n/81도 완전.
n==1 은 항상 완전하다.

결국 전체를 9개 그룹씩 되게 쪼개서 이 9개 그룹의 특성을 반환하면 된다.
그럼 최종적으로는 9개만 남게 되니까

9
0 0 0 1 1 1 -1 -1 -1
0 0 0 1 1 1 -1 -1 -1
0 0 0 1 1 1 -1 -1 -1
1 1 1 0 0 0 0 0 0
1 1 1 0 0 0 0 0 0
1 1 1 0 0 0 0 0 0
0 1 -1 0 1 -1 0 1 -1
0 -1 1 0 1 -1 0 1 -1
0 1 -1 1 0 -1 0 1 -1

다 9개씩으로 쪼개자. 왼쪽 위부터 시작하면,
n == 3일 때, 9개를 비교.
    모두 같다면? 그 숫자를 반환
    다른게 있다면? 각 숫자별로 더해주고 반환하지 않는다.(2를 반환)
*/

vector<vector<int>> board;
vector<int> result = {0, 0, 0}; // -1, 0, 1

int func(int r, int c, int n)
{
    if (n == 1)
    {
        return board[r][c];
    }

    // 9등분 해야 해서 계산하고 모두 동일한지 확인
    int a = func(r,c,n/3);
    int b = func(r,c+n/3,n/3);
    int _c = func(r,c+2*n/3,n/3);
    int d = func(r+n/3,c,n/3);
    int e = func(r+n/3,c+n/3, n/3);
    int f = func(r+n/3,c+2*n/3,n/3);
    int g = func(r+2*n/3,c,n/3);
    int h = func(r+2*n/3,c+n/3,n/3);
    int i = func(r+2*n/3,c+2*n/3,n/3);
    if (a!=2&&a==b&&a==_c&&a==d&&a==e&&a==f&&a==g&&a==h&&a==i) 
        return a; // -1,0,1 중 하나
    
    if (a!=2) result[a+1]++;
    if (b!=2) result[b+1]++;
    if (_c!=2) result[_c+1]++;
    if (d!=2) result[d+1]++;
    if (e!=2) result[e+1]++;
    if (f!=2) result[f+1]++;
    if (g!=2) result[g+1]++;
    if (h!=2) result[h+1]++;
    if (i!=2) result[i+1]++;
    return 2;
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    int n; cin >> n;

    board = vector<vector<int>>(n, vector<int>(n));
    for (int i=0; i<n; ++i)
    {
        for (int j=0; j<n; ++j)
        {
            cin >> board[i][j];
        }
    }
    int ret = func(0, 0, n);
    // 모든 숫자가 같은 종이
    if (-1 <= ret && ret <= 1)
    {
        result[ret+1]++;
    }

    for (auto& e : result)
    {
        cout << e << '\n';
    }
}