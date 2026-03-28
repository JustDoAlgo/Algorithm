// BOJ 15654 N과M(5)
/*
2026.03.12 22:35~23:00
15654 - N과 M (5)
흠 뭔가 앞에꺼에 사로잡혀서 생각이 안 들었음.
담에 다시 풀어보는걸로
*/

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

/*
벡터로 입력 받아서 오름차순 sorting
벡터에 쌓아가면서 재귀 돌리기

유의점은 중복된 수열을 허용하지 않는 것
똑같은거 끼리 바꾸는 건 노 카운트라는거
1 2 3 3 을 예로 들자.
1) 1 2 3 3 
2) 1 2 3 3 <- 이 경우를 막아야 함.

넘어가는 과정을 좀 살펴보자
1 2 3 에서 마지막 3을 넣을지 말지 하겠지
1 2 3 3을 했어. 그런데? 3 다음 동일한 3이 나왔으니, 이건 중복된 경우인걸 알잖아.
*/

int n, m;
vector<int> v;
vector<int> arr;
bool visited[10];

void func(int k)
{
    if (k == m)
    {
        for (int i=0; i<m; ++i)
        {
            cout << arr[i] << ' ';
        }
        cout << '\n';
        return;
    }

    for (int i=0; i<n; ++i)
    {
        if (visited[i]) continue;

        visited[i] = true;
        arr[k] = v[i];
        func(k+1);
        visited[i] = false;
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

    cin >> n >> m;
    v = vector<int>(n);
    arr = vector<int>(n);
    for (auto& e : v) cin >> e;
    sort(v.begin(), v.end());

    func(0);
}