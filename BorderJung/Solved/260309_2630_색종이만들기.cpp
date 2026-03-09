/*
26.03.09 19:20-19:40
2630 색종이 만들기
전에 풀었던 문제라 쉽게 풀었다.
*/

#include <iostream>
#include <vector>
using namespace std;

/*
n == 1 이면, 현재 숫자 반환
n >= 2 이면, 1/4 등분한 결과를 비교해서,
    1) 만약 모두 동일하면, 현재 값 반환
    2) 만약 다르면 즉시 카운팅, 더미값 반환

반환 값을 받았는데 더미값이다? 그럼 가망 없으니 그냥 즉시 카운팅 하면 됨
*/

vector<vector<int>> board;
vector<int> result(2, 0);

// (x, y)가 왼쪽 위 이고 변의 길이가 n 인 경우
int func(int x, int y, int n)
{
    if (n == 1) return board[x][y];

    int a1 = func(x, y, n/2);
    int a2 = func(x, y+n/2, n/2);
    int a3 = func(x+n/2, y, n/2);
    int a4 = func(x+n/2, y+n/2, n/2);

    // 더미값이 아니고 모두 동일한 숫자이면, 그대로 다음 타자에 넘김
    if (a1 != 2 && a1 == a2 && a2 == a3 && a3 == a4)
    {
        return a1;
    }

    // 동일한 숫자 규칙은 깨짐. 카운팅하고 다음에 이미 늦었다고 알리기
    if (a1 != 2) result[a1]++;
    if (a2 != 2) result[a2]++;
    if (a3 != 2) result[a3]++;
    if (a4 != 2) result[a4]++;

    return 2;
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);
    cout.tie(0);

    int n; cin >> n;
    board = vector<vector<int>>(n);
    
    for (auto& e : board)
    {
        vector<int> v(n);
        for (auto& v1 : v)
            cin >> v1;
        e = v;
    }

    int f = func(0, 0, n);
    if (f != 2)
        result[f] += 1;
    cout << result[0] << '\n' << result[1];
}