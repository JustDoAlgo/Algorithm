// 11729
// start: 23:55
// end: 00:35
// elapsed: 40m
// 비고: 이것도 강의에서 힌트 보고 해봄. 재귀적 사고를 가지려면 제일 마지막꺼부터 생각을 해야겠더라 허허. 어렵다 어려워
// 그냥 납득을 해야 해. n==1 일때 잘 동작해? 오키. n==k 일 때를 구하면 n==k+1 도 구해지네? 이것도 납득. 그럼 그냥 재귀로 돌리는거야. 함수 속을 파고 들어갈 필요가 없어. 어차피 자명한거니까

#include <iostream>
#include <queue>
using namespace std;

/*
결국 모든 원판은 3으로 가야 해.
n 원판이 3으로 가려면 아래 과정을 거침
    1. 1~n-1을 모두 2로 옮김
    2. 자신이 3으로 이동
    3. 1~n-1 원판을 3으로 옮김
n-1 원판이 3번으로 가려면 아래 과정을 거침
    1. 1~n-2을 모두 1으로 옮김
    2. 자신이 3로 이동
    3. 1~n-2 원판을 3으로 옮김
...
2 원판이 3번으로 가려면 아래 과정을 거침
    1. 1 원판을 1or2로 옮김
    2. 자신이 3으로 이동
    3. 1 원판을 3으로 옮김

결국, 1~n-1 원판을 a -> 6-a-b로 옮김
n 원판을 a -> b로 옮김
1~n-1 원판을 6-a-b -> b로 옮김

hanoi(1, 3, n) 만 하면 알아서 3번으로 이동된다는 것

총 횟수는 그냥 2^n - 1로 외워.
1번 옮기기 = 1
2번 옮기기 = 1 + 1 + 1 = 3
3번 옮기기 = 3 + 1 + 3 = 7
4번 옮기기 = 7 + 1 + 7 = 15
...
n번 옮기기 = 2^n - 1
*/

queue<pair<int, int>> q;

void hanoi(int a, int b, int n)
{
    if (n == 1) 
    {
        q.push(make_pair(a, b));
        return;
    }
    hanoi(a, 6-b-a, n-1);
    hanoi(a, b, 1);
    hanoi(6-b-a, b, n-1);
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(false);

    int n; cin >> n;
    hanoi(1, 3, n);

    cout << (1<<n) - 1 << '\n';
    while (!q.empty())
    {
        auto here = q.front(); q.pop();
        cout << here.first << ' ' << here.second << '\n';
    }
}