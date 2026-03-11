/*
26.03.11 20:45~21:05
15649 N과 M (1)
vector api 공부를 좀 해야 겠다.
find, reverse, 등등 있을건데, 내부 구현이나 그런 것들을.
그리고 기본형을 이해하고 문제를 풀자.
*/

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int n, m;

/*
m개의 정수를 쌓아가야 해.
func에 인자에 하나씩 쌓으면서 순서대로 넣어.

func은 for문으로 i = 1 ~ i = n 까지 반복하면서 func 함수를 실행해.
func(i, cnt); 이런 식으로. 이때 cnt는 쌓인 정수 수

그런데 현재 트리에서 쌓인 것을 출력해야 하니까 vector<int>에 같이 넣어줘야 해
그럼 cnt를 넘길게 아니라 vector를 넘기면 되겠다. vector.size() == m 이면 끝난거지.

=> 시간 복잡도, 공간 복잡도는 얼마나 될까.
- 공간 복잡도 = O(N). 벡터 메모리를 동일한 걸 나눠쓰니까 N=8 만큼만 씀
- 시간 복잡도 = O(N^M). find()를 매 번 돌리는 것도 비효율적으로 보이긴 한다. 8^8이면 2^24 
    시간 초과가 날 것만 같은 기분이다. 하지만 이게 완전 저거는 아니고, 논리적으로는 N! 인데, 잘 모르겠네

*/ 
void func(vector<int>& v)
{
    // 다 모았으면 출력 후 return
    if (v.size() == m)
    {
        for (auto& e : v)
            cout << e << ' ';
        cout << '\n';
        return;
    }

    for (int i=1; i<=n; ++i)
    {
        // 여기서 벡터 안에 i가 없다면, 추가해서 보냄
        if (find(v.begin(), v.end(), i) == v.end())
        {
            v.push_back(i);
            func(v);
            v.pop_back();
        }
    }
}

/*
아래 로직은 바킹독 강의에서 나온 것인데, find()를 쓰지 않고, n <= 8 이니 작은 배열을 만들어서 체크한다.
*/

bool visited[10];
int arr[10];

void func2(int k)
{
    if (k == m)
    {
        for (int i=0; i<m; ++i) cout << arr[i] << ' ';
        cout << '\n';
    }

    for (int i=1; i<=n; ++i)
    {
        if (!visited[i])
        {
            visited[i] = true;
            arr[k] = i;
            func2(k + 1);
            visited[i] = false;
        }
    }
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(0);

     cin >> n >> m;

    // vector<int> v;
    // func(v);

    func2(0);
}