/*
2026.03.12 20:45~21:30
1182 부분수열의 합
잘못 생각한 점은 기저 사례이다.
나는 중간에 부분합이 s가 된 시점에 끝내면 된다 생각했지만
결국 n개를 모두 확인한 뒤의 부분합을 보는게 맞다.
왜냐하면 넣거나, 넣지 않거나 의 경우를 모두 담는 트리들이기 때문에 중간에 멈추면 안 된다.
*/

#include <iostream>
#include <vector>
using namespace std;

/*
처음에는 DP인가 싶었음. 현재 인덱스의 부분합으로 진행하나?
하지만 DP로 하기에는 부분합의 범위가 너무 넓지. 이건 아니다.

그럼 하나 넣고 빼고인 백트래킹이겠네
- 현재 원소 선택, i+1, part sum 을 넘기겠군
- 문제는 '동일한 원소' 처리인데, 어쩜 좋을까.

만약 이전꺼를 선택 안 했으면 끝.
만약 이전꺼를 선택했으면 선택 or 안 선택

a1을 고름: 다음부터는 부분합이 ps - a1 인 것을 찾기
    a2 o: ps - a1 -a2
    a2 x: ps - a1
a1을 안 고름: 부분합이 ps인 것을 찾기
    ...
    ...
*/

int n, s;
vector<int> v;
int result = 0;

void func(int i, int ps)
{
    if (i == n)
    {
        if (ps == s)
            result += 1;
        return;
    }    

    func(i+1, ps+v[i]);
    func(i+1, ps);
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> s;
    v = vector<int>(n);
    for (auto& e : v) cin >> e;

    func(0, 0);
    if (s==0) result -= 1;
    cout << result;
}